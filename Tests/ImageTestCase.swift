// Copyright © 2018 Alejandro Isaza.
//
// This file is part of JdenticonSwift. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest

class ImageTestCase: XCTestCase {
    /// URL for the directory where reference test images are saved.
    let testImageURL: URL = {
        guard let envDirectory = ProcessInfo.processInfo.environment["TEST_IMAGE_DIR"] else {
            fatalError("Set the TEST_IMAGE_DIR environment variable")
        }
        return URL(fileURLWithPath: envDirectory)
    }()

    /// Wheter testing or recording
    var recording = false

    public func assertUnchanged(_ image: @autoclosure () throws -> UIImage, _ message: @autoclosure () -> String = "Image differs from reference", file: StaticString = #file, line: UInt = #line, function: StaticString = #function) rethrows {
        let imageName = String(function.description.dropFirst(4).dropLast(2))
        let imageURL = testImageURL.appendingPathComponent(imageName).appendingPathExtension("png")

        if recording {
            try? UIImagePNGRepresentation(image())?.write(to: imageURL)
            return
        }

        guard let reference = UIImage(contentsOfFile: imageURL.path) else {
            XCTFail("Test is missing reference image '\(imageName).png'", file: file, line: line)
            return
        }
        let image = try image()
        if image.size != reference.size {
            XCTFail("Reference image is of different size", file: file, line: line)
            return
        }

        if !compare(image, reference, tolerance: 0) {
            XCTFail(message(), file: file, line: line)
        }
    }

    private func compare(_ image1: UIImage, _ image2: UIImage, tolerance: CGFloat) -> Bool {
        precondition(image1.size == image2.size, "Images must have the same size.")

        guard let cgImage1 = image1.cgImage, let cgImage2 = image2.cgImage else {
            return false
        }

        let referenceImageSize = CGSize(width: cgImage1.width, height: cgImage1.height)
        let imageSize = CGSize(width: cgImage2.width, height: cgImage2.height)

        // The images have the equal size, so we could use the smallest amount of bytes because of byte padding
        let minBytesPerRow = min(cgImage1.bytesPerRow, cgImage2.bytesPerRow)
        let referenceImageSizeBytes = Int(referenceImageSize.height) * minBytesPerRow
        let referenceImagePixels = UnsafeMutablePointer<UInt8>.allocate(capacity: referenceImageSizeBytes)
        let imagePixels = UnsafeMutablePointer<UInt8>.allocate(capacity: referenceImageSizeBytes)
        defer {
            referenceImagePixels.deallocate()
            imagePixels.deallocate()
        }

        let maybeReferenceImageContext = CGContext(
            data: referenceImagePixels,
            width: Int(referenceImageSize.width),
            height: Int(referenceImageSize.height),
            bitsPerComponent: cgImage1.bitsPerComponent,
            bytesPerRow: minBytesPerRow,
            space: cgImage1.colorSpace!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
        let maybeImageContext = CGContext(
            data: imagePixels,
            width: Int(imageSize.width),
            height: Int(imageSize.height),
            bitsPerComponent: cgImage2.bitsPerComponent,
            bytesPerRow: minBytesPerRow,
            space: cgImage2.colorSpace!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        guard let referenceImageContext = maybeReferenceImageContext, let imageContext = maybeImageContext else {
            return false
        }
        referenceImageContext.clear(CGRect(origin: .zero, size: referenceImageSize))
        referenceImageContext.draw(cgImage1, in: CGRect(origin: .zero, size: referenceImageSize))
        imageContext.clear(CGRect(origin: .zero, size: imageSize))
        imageContext.draw(cgImage2, in: CGRect(origin: .zero, size: imageSize))

        // Do a fast compare if we can
        if tolerance == 0 {
            let diff = memcmp(referenceImagePixels, imagePixels, referenceImageSizeBytes)
            return diff == 0
        }

        // Go through each pixel in turn and see if it is different
        let pixelCount = Int(referenceImageSize.width * referenceImageSize.height)

        var numDiffPixels = 0
        for i in 0 ..< referenceImageSizeBytes {
            let p1 = referenceImagePixels[i]
            let p2 = imagePixels[i]
            if p1 != p2 {
                numDiffPixels += 1

                let percent = CGFloat(numDiffPixels) / CGFloat(pixelCount)
                if percent > tolerance {
                    return false
                }
            }
        }

        return true

    }
}

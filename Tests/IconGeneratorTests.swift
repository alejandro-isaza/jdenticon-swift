// Copyright © 2018 Alejandro Isaza.
//
// This file is part of JdenticonSwift. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
@testable import JdenticonSwift

class IconGeneratorTests: ImageTestCase {
    let icon0Hash = Data(bytes: [0xe7, 0xb0, 0xf1, 0x79, 0xa2, 0x1c, 0x48, 0x6b, 0xcf, 0x84, 0x41, 0x04, 0xfe, 0x6e, 0x5b, 0x9f, 0x3c, 0x19, 0x9f, 0x84])
    let icon1Hash = Data(bytes: [0x9f, 0xaf, 0xf4, 0xf3, 0xd6, 0xd7, 0xd7, 0x55, 0x77, 0xce, 0x81, 0x0e, 0xc6, 0xd6, 0xa0, 0x6b, 0xe4, 0x9c, 0x3a, 0x5a])
    let icon2Hash = Data(bytes: [0xfb, 0xb0, 0xf1, 0x2e, 0xd6, 0x40, 0x1d, 0x30, 0x46, 0x73, 0x1b, 0x54, 0x69, 0x08, 0x91, 0x5c, 0x89, 0xa1, 0x4e, 0x8f])

    override func setUp() {
        super.setUp()
    }

    func testIcon0() throws {
        let generator = IconGenerator(size: 100, hash: icon0Hash)
        let image = UIImage(cgImage: generator.render()!)
        assertUnchanged(image)
    }

    func testIcon1() throws {
        let generator = IconGenerator(size: 100, hash: icon1Hash)
        let image = UIImage(cgImage: generator.render()!)
        assertUnchanged(image)
    }

    func testIcon2() throws {
        let generator = IconGenerator(size: 100, hash: icon2Hash)
        let image = UIImage(cgImage: generator.render()!)
        assertUnchanged(image)
    }

    func testShortHash() throws {
        let generator = IconGenerator(size: 100, hash: Data(bytes: [0x00]))
        _ = UIImage(cgImage: generator.render()!)
        // Just to verify that it doesn' crash
    }
}

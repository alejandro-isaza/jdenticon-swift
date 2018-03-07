// Copyright © 2018 Alejandro Isaza.
//
// This file is part of JdenticonSwift. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
@testable import JdenticonSwift

class ShapeTests: ImageTestCase {
    let size = 100 as CGFloat
    var context: CGContext!

    override func setUp() {
        super.setUp()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        context = CGContext(data: nil, width: Int(size), height: Int(size), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        context.translateBy(x: 0, y: size)
        context.scaleBy(x: 1, y: -1)
        context.setStrokeColor(UIColor.red.cgColor)
        context.setFillColor(UIColor.black.cgColor)
    }

    func drawShape(_ shape: Shape, function: StaticString = #function) {
        context.stroke(CGRect(x: 0, y: 0, width: size, height: size), width: 1)

        shape.draw(in: context, size: size, index: 0)
        context.fillPath(using: .winding)

        let image = UIImage(cgImage: context.makeImage()!)
        assertUnchanged(image, function: function)
    }

    func testCutCorner() {
        drawShape(CutCorner())
    }

    func testSideTriangle() {
        drawShape(SideTriangle())
    }

    func testMiddleSquare() {
        drawShape(MiddleSquare())
    }

    func testCornerSquare() {
        drawShape(CornerSquare())
    }

    func testOffCenterCircle() {
        drawShape(OffCenterCircle())
    }

    func testNegativeTriangle() {
        drawShape(NegativeTriangle())
    }

    func testCutSquare() {
        drawShape(CutSquare())
    }

    func testCornerPlusTriangle() {
        drawShape(CornerPlusTriangle())
    }

    func testNegativeSquare() {
        drawShape(NegativeSquare())
    }

    func testNegativeCircle() {
        drawShape(NegativeCircle())
    }

    func testNegativeRhombus() {
        drawShape(NegativeRhombus())
    }

    func testConditionalCircle() {
        drawShape(ConditionalCircle())
    }

    func testHalfTriangle() {
        drawShape(HalfTriangle())
    }

    func testTriangle() {
        drawShape(Triangle())
    }

    func testTriangleCorner1() {
        drawShape(Triangle(corner: 1))
    }

    func testTriangleCorner2() {
        drawShape(Triangle(corner: 2))
    }

    func testTriangleCorner3() {
        drawShape(Triangle(corner: 3))
    }

    func testBottomHalfTriangle() {
        drawShape(BottomHalfTriangle())
    }

    func testRhombus() {
        drawShape(Rhombus())
    }

    func testCircle() {
        drawShape(Circle())
    }
}

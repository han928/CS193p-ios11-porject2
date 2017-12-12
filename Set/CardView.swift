//
//  CardView.swift
//  Set
//
//  Created by Han Lai on 12/9/17.
//  Copyright © 2017 Han Lai. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable
    var symbol: String = "diamond" { didSet { setNeedsDisplay(); setNeedsLayout()}} // options: oval, squiggle, diamond
    @IBInspectable
    var number: Int = 2 { didSet { setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var shading: String = "striped" { didSet { setNeedsDisplay(); setNeedsLayout()}} // options: solid, open, striped
    @IBInspectable
    var color: String = "red" { didSet { setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var isFaceup: Bool = true
    

    
    private func createDiamond(in newBound: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: newBound.minX + newBound.xSpacing, y: newBound.midY ))
        path.addLine(to: CGPoint(x: newBound.minX + newBound.xSpacing + newBound.drawingWidth / 2, y: newBound.minY + newBound.ySpacing))
        path.addLine(to: CGPoint(x: newBound.maxX - newBound.xSpacing, y: newBound.midY))
        path.addLine(to: CGPoint(x: newBound.minX + newBound.xSpacing + newBound.drawingWidth / 2, y: newBound.maxY - newBound.ySpacing))
        path.close()
        return path
    }

    private func createOval(in newBound: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let radius = (newBound.width - newBound.xSpacing * 2) / 5
        path.addArc(withCenter: CGPoint(x: newBound.minX +  newBound.xSpacing + radius, y: newBound.minY + newBound.ySpacing + radius), radius: radius, startAngle: 3 * CGFloat.pi / 2, endAngle: CGFloat.pi/2, clockwise: false)
        
        path.addArc(withCenter: CGPoint(x: newBound.maxX -  newBound.xSpacing - radius, y: newBound.minY + newBound.ySpacing + radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: 3 * CGFloat.pi / 2, clockwise: false)
        path.close()

        return path
    }
    
    private func createSquiggle(in newBound: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: newBound.minX + newBound.xSpacing, y: newBound.midY))
        
        path.addCurve(to: CGPoint(x: newBound.maxX - newBound.xSpacing, y: newBound.midY), controlPoint1: CGPoint(x: newBound.midX - 2 * newBound.xSpacing, y: newBound.minY + newBound.ySpacing), controlPoint2: CGPoint(x: newBound.midX + 2 * newBound.xSpacing, y: newBound.midY + 2 * newBound.ySpacing))
        
        path.addCurve(to: CGPoint(x: newBound.minX + newBound.xSpacing, y: newBound.midY), controlPoint1: CGPoint(x: newBound.midX + 2 * newBound.xSpacing, y: newBound.maxY), controlPoint2: CGPoint(x:newBound.maxX, y: newBound.midY  +  2 * newBound.ySpacing))

        return path
    }
    
    
    
    
    private func drawLine(path: UIBezierPath, x: CGFloat, y: CGFloat, height: CGFloat){
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x, y: y + height))
        
        switch color{
            case "red":
                path.lineWidth = shadedLineWidth
                UIColor.red.setStroke()
                path.stroke()
            case "blue":
                path.lineWidth = shadedLineWidth
                UIColor.blue.setStroke()
                path.stroke()
            case "green":
                path.lineWidth = shadedLineWidth
                UIColor.green.setStroke()
                path.stroke()
            default:
                print("color value not in rgb")
                UIColor.black.setStroke()
        }
        path.stroke()
        
    }
    
    private func drawLineForShading(path: UIBezierPath, x: CGFloat, y: CGFloat, height: CGFloat, width: CGFloat) {
        let spacing = CGFloat(width / 50)
        for i in 0..<50 {
            drawLine(path: path, x: x + CGFloat(i) * spacing, y: y, height: height)
        }
        
    }
    
    private func configureView(path: UIBezierPath) {
        
        switch color{
            case "red":
                path.lineWidth = lineWidth
                UIColor.red.setStroke()
                path.stroke()
            case "blue":
                path.lineWidth = lineWidth
                UIColor.blue.setStroke()
                path.stroke()
            case "green":
                path.lineWidth = lineWidth
                UIColor.green.setStroke()
                path.stroke()
            default:
                print("color value not in rgb")
                UIColor.black.setStroke()
        }
        
        switch shading {
            case "solid":
                switch color {
                case "red":
                    UIColor.red.setFill()
                    path.fill()
                case "blue":
                    UIColor.blue.setFill()
                    path.fill()
                case "green":
                    UIColor.green.setFill()
                    path.fill()
                default:
                    print("color value not in rgb")
                    UIColor.black.setStroke()
                }
            case "open":
                
                break
            case "striped":
                path.addClip()
                drawLineForShading(path: path, x: bounds.minX, y: bounds.minY, height: bounds.height, width: bounds.width)
            default:
                print ("shading out of range")
        }
        
    }
    
    private func drawSymbol () {
        var symbolGenerator: (CGRect) -> UIBezierPath
        symbolGenerator = createOval
        switch symbol {
        case "oval":
            symbolGenerator = createOval
        case "squiggle":
            symbolGenerator = createSquiggle
        case "diamond":
            symbolGenerator = createDiamond
        default:
            print("symbol variable not a valid value")
        }
        var paths = [UIBezierPath]()
        var boundList = [CGRect]()
        
        
        switch number {
        case 1: boundList.append(bounds.middle)
        case 2:
            boundList.append(bounds.topHalf)
            boundList.append(bounds.bottomHalf)
        case 3:
            boundList.append(bounds.oneOfThree)
            boundList.append(bounds.twoOfThree)
            boundList.append(bounds.threeOfThree)
        default:
            print ("number exceed max possible number")
        }
        
        for newBound in boundList {
            paths.append(symbolGenerator(newBound))
        }
        
        var path = UIBezierPath()
        
        for (i, p) in paths.enumerated(){
            if i == 0 {
                path = p
            }
            else {
                path.append(p)
            }
        }
        
        configureView(path: path)
    }
    
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceup {
            drawSymbol()
        }
        
    }
 }


extension CardView {
    private struct SizeRatio {
        static let circleRadiusRatio: CGFloat = 0.1
        static let lineWidth: CGFloat = 0.02
    }
    
    private var circleRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) * SizeRatio.circleRadiusRatio
    }
    
    private var objectSpacing: CGFloat {
        return circleRadius * 3
    }
    
    private var lineWidth: CGFloat {
        return bounds.size.width * SizeRatio.lineWidth
    }
    private var shadedLineWidth: CGFloat {
        return bounds.size.width * SizeRatio.lineWidth / 3
    }

}

extension CGRect {
    var topHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width, height: height/2)
    }
    
    var bottomHalf: CGRect {
        return CGRect(x: minX, y: midY, width: width, height: height/2)
    }
    
    var middle: CGRect {
        return CGRect(x: minX, y: minY + height/4 , width: width, height: height/2 )
    }
    
    var oneOfThree: CGRect {
        return CGRect(x: minX, y: minY, width: width, height: height/3)

    }
    var twoOfThree: CGRect {
        return CGRect(x: minX, y: minY + height/3, width: width, height: height/3)
        
    }
    var threeOfThree: CGRect {
        return CGRect(x: minX, y: minY + 2 * height/3, width: width, height: height/3)
        
    }
    
    var ySpacing: CGFloat {
        return self.size.height / 4
    }
    var xSpacing: CGFloat {
        return self.size.width / 10
    }
    var drawingHeight: CGFloat {
        return self.size.height - 2 * self.ySpacing
    }
    var drawingWidth: CGFloat {
        return self.size.width - 2 * self.xSpacing
    }


}


extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

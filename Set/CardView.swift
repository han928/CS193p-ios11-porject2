//
//  CardView.swift
//  Set
//
//  Created by Han Lai on 12/9/17.
//  Copyright © 2017 Han Lai. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBInspectable
    var symbol: String = "oval" { didSet { setNeedsDisplay(); setNeedsLayout()}} // options: oval, squiggle, diamond
    @IBInspectable
    var number: Int = 3 { didSet { setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var shading: String = "open" { didSet { setNeedsDisplay(); setNeedsLayout()}} // options: solid, open, striped
    @IBInspectable
    var color: String = "blue" { didSet { setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var isFaceup: Bool = true
    

    private func createCircle(newBound: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: newBound.midX, y: newBound.midY), radius: 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        return path
    }
    
    
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
        
        return path
    }
    
    private func createSquare(x: CGFloat, y: CGFloat, width: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(rect: CGRect(x: x - width/2 , y: y - width/2, width: width, height: width))
        return path
    }
    
    private func createTriangle(x: CGFloat, y: CGFloat, height: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x , y: y - height/2))
        path.addLine(to: CGPoint(x: x + (height / CGFloat(3.0.squareRoot())), y: y + height/2 ))
        path.addLine(to: CGPoint(x: x - (height / CGFloat(3.0.squareRoot())), y: y + height/2 ))
        path.close()
        return path
    }
    
    
    
    private func drawLine(path: UIBezierPath, x: CGFloat, y: CGFloat, height: CGFloat){
//        let path = UIBezierPath()
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
                print ("shading not included")
        }
        
    }
    
    
    
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        
        
        
        let path = createDiamond(in: bounds.oneOfThree)
        let path2 = createOval(in: bounds.twoOfThree)
        let path3 = createOval(in: bounds.threeOfThree)

        path.append(path2)
        path.append(path3)
        configureView(path: path)

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
        return self
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

//
//  CircleView.swift
//  Lab3
//
//  Created by Xiaoyi Xie on 9/23/16.
//  Copyright © 2016 Xiaoyi Xie. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var arcCenter : [CGPoint] = []
    var arcRadius = CGFloat()
    var arcColor = UIColor.clearColor()
    var arcLineStyle = Bool()
    
    func updateCircle(center: [CGPoint], radius: CGFloat, color: UIColor, line: Bool){
        arcCenter = center
        arcRadius = radius
        arcColor = color
        arcLineStyle = line
        setNeedsDisplay()
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        arcColor.setFill()
        
        var path = UIBezierPath()
        
        if arcCenter.count<=1 {
            path.addArcWithCenter(arcCenter[0], radius: arcRadius/2, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
            path.fill()

        }
        else {
            path = createQuadPath(arcCenter)
            path.lineWidth = arcRadius
            arcColor.setStroke()
            if arcLineStyle {
                let dashes: [CGFloat] = [path.lineWidth * 0, path.lineWidth * 2]
                path.setLineDash(dashes, count: dashes.count, phase: 0)
                path.lineCapStyle = CGLineCap.Round
            }
            else{
                path.lineCapStyle = CGLineCap.Round
            }
            path.stroke()
        }
        
    }
    
    private func findMidpoint(firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint {
        return CGPoint(x:(firstPoint.x+secondPoint.x)/2, y: (firstPoint.y+secondPoint.y)/2)
    }
    
    func createQuadPath(arrayOfPoints: [CGPoint]) -> UIBezierPath {
        let newPath = UIBezierPath()
        let firstLocation = arrayOfPoints[0]
        newPath.moveToPoint(firstLocation)
        let secondLocation = arrayOfPoints[1]
        let firstMidpoint = findMidpoint(firstLocation, secondPoint: secondLocation)
        newPath.addLineToPoint(firstMidpoint)
        for index in 1 ..< arrayOfPoints.count-1 {
            let currentLocation = arrayOfPoints[index]
            let nextLocation = arrayOfPoints[index + 1]
            let midpoint = findMidpoint(currentLocation, secondPoint: nextLocation)
            newPath.addQuadCurveToPoint(midpoint, controlPoint: currentLocation)
        }
        let lastLocation = arrayOfPoints.last
        newPath.addLineToPoint(lastLocation!)
        return newPath
    }

    


    
    
}
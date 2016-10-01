//
//  TrianglifyView.swift
//  Trianglify
//
//  Created by Christopher Laganiere on 8/19/16.
//  Copyright © 2016 Chris Laganiere. All rights reserved.
//

import Foundation
import UIKit
import DynamicColor

public class TrianglifyView: UIView {
    
    /// public
    
    public var cellSize = CGRectMake(50, 50, 50, 50) {
        didSet {
            setNeedsLayout()
        }
    }
    public var offset: Int = 25
    public var variation: CGFloat = 0.65 {
        didSet {
            // 0.0 < x < 1.0
            variation = min(1.0, max(0.0, variation))
        }
    }
    public var colors: [UIColor] = Colorbrewer.colors("GnBu") ?? []
    
    /// private
    
    private var shapeLayers = [CAShapeLayer]()
    private let colorResolution = 100
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateTrianglePoints()
    }
    
    struct Triangle {
        let color: UIColor
        let points: [CGPoint]
        init?(points: [CGPoint], parentFrame: CGRect, potentialColors: [UIColor]) {
            guard points.count == 3 else {
                return nil
            }
            
            let triangleCenterX = points.reduce(0, combine: { sum, next in
                sum + next.x
            }) / 3.0
            
            let triangleCenterY = points.reduce(0, combine: { sum, next in
                sum + next.y
            }) / 3.0
            
            // percent down diagonal axis (TL / BR) at which triangle's center point sits
            let triangleAxisPercent = 0.5 * (triangleCenterX / parentFrame.width) + 0.5 * (triangleCenterY / parentFrame.height)
            
            let firstColor = potentialColors[1] ?? UIColor.greenColor() // potentialColors[Int(floor(CGFloat(potentialColors.count - 1) * triangleAxisPercent))]
            let secondColor = potentialColors[7] ?? UIColor.blueColor() // potentialColors[Int(ceil(CGFloat(potentialColors.count - 1) * triangleAxisPercent))]
            let colorMixWeight = triangleAxisPercent // CGFloat(potentialColors.count) * triangleAxisPercent - floor(CGFloat(potentialColors.count) * triangleAxisPercent)
            
            self.color = firstColor.mixWithColor(secondColor, weight: colorMixWeight)
            self.points = points
        }
    }
    
    private func updateTrianglePoints() {
        let numRows = Int(frame.width / cellSize.width)
        let xSpacing = frame.width / CGFloat(numRows)
        
        let numCols = Int(frame.height / cellSize.height)
        let ySpacing = frame.height / CGFloat(numCols)
        
        // recalculate triangles
        var triangles = [Triangle]()
        var pointRows = [[CGPoint]]()
        for r in 0...numRows {
            var newRow = [CGPoint]()
            for c in 0...numCols {
                
                // calculate triangle point position
                let startPoint = CGPoint(x: CGFloat(r) * xSpacing, y: CGFloat(c) * ySpacing)
                let angle = CGFloat(arc4random_uniform(UInt32(variation * 2 * CGFloat(M_PI)))) % CGFloat(2 * M_PI)
                var newPoint = CGPoint(
                    x: startPoint.x + cos(angle) * variation * CGFloat(arc4random_uniform(UInt32(offset))),
                    y: startPoint.y + sin(angle) * variation * CGFloat(arc4random_uniform(UInt32(offset))))
                
                // 'edge' cases: end points should align with edges of view
                if r == 0 || r == numRows {
                    newPoint.x = startPoint.x
                }
                if c == 0 || c == numCols {
                    newPoint.y = startPoint.y
                }
                
                // calculate triangles
                if let lastRow = pointRows.last,
                    let bottomLeftPoint = newRow.last {
                    let topLeftPoint = lastRow[newRow.count - 1]
                    let topRightPoint = lastRow[newRow.count]
                    let bottomRightPoint = newPoint
                    
                    // .50 / .50 chance of (top left + bottom right) or (top right + bottom left) triangles
                    let flipStyle = (arc4random_uniform(2) == 0)
                    
                    // calculate top triangle of rect
                    let triangle1Points = flipStyle ? [topLeftPoint, topRightPoint, bottomLeftPoint] : [topLeftPoint, topRightPoint, bottomRightPoint]
                    if let triangle1 = Triangle(points: triangle1Points, parentFrame: frame, potentialColors: colors) {
                        triangles.append(triangle1)
                    }
                    
                    // calculate bottom triangle of rect
                    let triangle2Points = flipStyle ? [topRightPoint, bottomLeftPoint, bottomRightPoint] : [topLeftPoint, bottomLeftPoint, bottomRightPoint]
                    if let triangle2 = Triangle(points: triangle2Points, parentFrame: frame, potentialColors: colors) {
                        triangles.append(triangle2)
                    }
                }
                
                newRow.append(newPoint)
            }
            pointRows.append(newRow)
        }
        
        // reset layout
        for staleShape in shapeLayers {
            staleShape.removeFromSuperlayer()
        }
        shapeLayers = []
        
        // layout triangles
        for triangle in triangles {
            let trianglePath = UIBezierPath()
            trianglePath.moveToPoint(triangle.points[0])
            trianglePath.addLineToPoint(triangle.points[1])
            trianglePath.addLineToPoint(triangle.points[2])
            trianglePath.closePath()
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = trianglePath.CGPath
            shapeLayer.fillColor = triangle.color.CGColor
            shapeLayer.lineWidth = 1.0
            shapeLayer.strokeColor = triangle.color.CGColor
            layer.addSublayer(shapeLayer)
            shapeLayers.append(shapeLayer)
        }
        
    }
    
    
}

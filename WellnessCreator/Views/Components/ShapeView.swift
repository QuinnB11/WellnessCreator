//
//  ShapeView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/1/24.
//

import Foundation
import SwiftUI

struct PolygonShape: Shape {
    var corners: Int
    var center: CGPoint
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if corners == 0 {
            // Circle path
            path.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
            return path
        }
        
        let angleIncrement = 360.0 / Double(corners)
        var currentAngle = 0.0
        let firstPoint = CGPoint(x: center.x + radius * cos(currentAngle.toRadians()), y: center.y + radius * sin(currentAngle.toRadians()))
        
        path.move(to: firstPoint)
        
        for _ in 1..<corners {
            currentAngle += angleIncrement
            let nextPoint = CGPoint(x: center.x + radius * cos(currentAngle.toRadians()), y: center.y + radius * sin(currentAngle.toRadians()))
            path.addLine(to: nextPoint)
        }
        
        path.closeSubpath()
        
        return path
    }
}



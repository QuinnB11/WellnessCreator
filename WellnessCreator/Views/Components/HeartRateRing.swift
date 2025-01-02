//
//  HeartRateRing.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 11/19/24.
//

import SwiftUI

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let sideLength = min(rect.size.width, rect.size.height)
        
        let width = sideLength * 0.3
        let height = sideLength * 0.2
        
        let centerX = rect.size.width / 2
        let centerY = rect.size.height / 2
        
        // Start at the bottom point of the heart
        path.move(to: CGPoint(x: centerX, y: centerY + height / 2))
        
        // Left curve of the heart
        path.addCurve(to: CGPoint(x: centerX - width / 2, y: centerY - height / 3),
                      control1: CGPoint(x: centerX - width / 4, y: centerY + height / 4),
                      control2: CGPoint(x: centerX - width / 2, y: centerY))
        
        // Left arc of the heart (top left bulge)
        path.addArc(center: CGPoint(x: centerX - width / 4, y: centerY - height / 3),
                    radius: width / 4,
                    startAngle: .degrees(180),
                    endAngle: .degrees(0),
                    clockwise: false)
        
        // Right arc of the heart (top right bulge)
        path.addArc(center: CGPoint(x: centerX + width / 4, y: centerY - height / 3),
                    radius: width / 4,
                    startAngle: .degrees(180),
                    endAngle: .degrees(0),
                    clockwise: false)
        
        // Right curve of the heart
        path.addCurve(to: CGPoint(x: centerX, y: centerY + height / 2),
                      control1: CGPoint(x: centerX + width / 2, y: centerY),
                      control2: CGPoint(x: centerX + width / 4, y: centerY + height / 4))
        
        return path
    }
}

struct HeartRateRing: View {
    var heartRate: Int 

    var ringColor: Color {
        switch heartRate {
        case ..<40:
            return Color(red: 1.0, green: 0.8, blue: 0.9)
        case 40..<60:
            return Color(red: 1.0, green: 0.6, blue: 0.7)
        case 60..<80:
            return Color(red: 1.0, green: 0.4, blue: 0.5)
        case 80..<120:
            return Color(red: 0.8, green: 0.2, blue: 0.3)
        default:
            return Color(red: 0.6, green: 0.1, blue: 0.2)
        }
    }


    var body: some View {
        ZStack {
            HeartShape()
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .foregroundColor(.black.opacity(0.2))
                .scaleEffect(2.5)
            HeartShape()
                .trim(from: 0, to: CGFloat(min(self.heartRate, 120)) / 120)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .scaleEffect(2.5)
                .foregroundColor(ringColor)
            Text("\(heartRate)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(ringColor)
        }

    }
}

#Preview {
    HeartRateRing(heartRate: 90)
}

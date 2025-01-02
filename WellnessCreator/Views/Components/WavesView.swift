//
//  WavesView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 11/18/24.
//


import SwiftUI

struct WavesView: View {
   
    let universialSize = UIScreen.main.bounds
    @State var isAnimated = false
    var body: some View {
        ZStack {
                getWavePath(interval: universialSize.width * 1.5, amplitude: 110, baseline: 65 + universialSize.height / 2)
                    .foregroundColor(Color.red.opacity(0.4))
                    .offset(x: isAnimated ? -universialSize.width * 1.5 : 0)
                    .animation(
                        Animation.linear(duration: 5)
                            .repeatForever(autoreverses: false)
                    )
                
                getWavePath(interval: universialSize.width, amplitude: 200, baseline: 70 + universialSize.height / 2)
                    .foregroundColor(Color.blue.opacity(0.2))
                    .offset(x: isAnimated ? -universialSize.width : 0)
                    .animation(
                        Animation.linear(duration: 11)
                            .repeatForever(autoreverses: false)
                    )
                
                getWavePath(interval: universialSize.width * 3, amplitude: 200, baseline: 95 + universialSize.height / 2)
                    .foregroundColor(Color.green.opacity(0.24))
                    .offset(x: isAnimated ? -universialSize.width * 3 : 0)
                    .animation(
                        Animation.linear(duration: 4)
                            .repeatForever(autoreverses: false)
                    )
                getWavePath(interval: universialSize.width * 1.2, amplitude: 30, baseline: 75 + universialSize.height / 2)
                    .foregroundColor(Color.black.opacity(0.2))
                    .offset(x: isAnimated ? -universialSize.width * 1.2 : 0)
                    .animation(
                        Animation.linear(duration: 5)
                            .repeatForever(autoreverses: false)
                    )
                
            }
            .onAppear {
                isAnimated = true
            }

        
    }
        
    
    func getWavePath(interval:CGFloat, amplitude: CGFloat = 100, baseline:CGFloat = UIScreen.main.bounds.height/2) -> Path {
        Path{path in
            path.move(to: CGPoint(x:0, y: baseline))
            path.addCurve(to: CGPoint(x: interval, y: baseline), control1: CGPoint(x: interval * 0.35, y: amplitude + baseline), control2: CGPoint(x: interval * 0.65, y: -amplitude + baseline))
            path.addCurve(to: CGPoint(x: 2*interval, y: baseline), control1: CGPoint(x: interval * 1.35, y: amplitude + baseline), control2: CGPoint(x: interval * 1.65, y: -amplitude + baseline))
            path.addLine(to: CGPoint(x: 2*interval, y: universialSize.height))
            path.addLine(to: CGPoint(x: 0, y: universialSize.height))
        }
    }
}

#Preview {
    WavesView()
}

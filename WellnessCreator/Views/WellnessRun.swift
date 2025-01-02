//
//  WellnessRun.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/15/24.
//

import SwiftUI

struct WellnessRun: View {
    @Environment(WellnessManager.self) var wellnessManager
    @Environment(\.dismiss) private var dismiss
    
    // Input
    var creation: WellnessCreation?
    
    // Basic needs for display
    let radius: CGFloat = 50
    let startDate = Date()
    let center = CGPoint(x: 50, y: 50)
    
    
    // Timer
    @State private var timeRemaining = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Font for breathe in
    @State private var fontSize: CGFloat = 40

    @State private var showBreatheIn = true
    
    var body: some View {
        NavigationView {
            if creation == nil {
                Text("There's been an error reset the app please!")
            } else {
                ZStack{
                    Color.black
                        .ignoresSafeArea()
                    VStack {
                        ZStack {
                            ForEach(0..<creation!.numberOfCircles, id: \.self) { index in
                                TimelineView(.animation) { context in
                                    PolygonShape(corners: creation!.corners, center: center, radius: radius)
                                        .fill(Color(hex: creation!.colors[index % creation!.colors.count])!)
                                        .frame(width: radius * 2, height: radius * 2)
                                        .offset(x: xOffset(for: index, factor: creation!.xOffsetFactor * oscillatingFactor(for: CGFloat(startDate.timeIntervalSinceNow))), y: yOffset(for: index, factor: creation!.yOffsetFactor * oscillatingFactor(for: CGFloat(startDate.timeIntervalSinceNow))))
                                        .opacity(0.5)
                                        .colorEffect(ShaderLibrary.noise(.float(startDate.timeIntervalSinceNow), .float(creation!.noiseStrength), .float(creation!.noiseEnabled ? 1 : 0)))
                                        .colorEffect(ShaderLibrary.checkerboard(.float(startDate.timeIntervalSinceNow), .float(20), .float(10), .float(creation!.checkerEnabled ? 1 : 0)))
                                        .colorEffect(ShaderLibrary.flipHue(.float(startDate.timeIntervalSinceNow), .float(creation!.flipHueEnabled ? 1 : 0)))
                                        .visualEffect { content, proxy in
                                            content
                                                .distortionEffect(ShaderLibrary.complexWave(
                                                    .float(startDate.timeIntervalSinceNow),
                                                    .float2(proxy.size),
                                                    .float(0.1),
                                                    .float(3),
                                                    .float(10),
                                                    .float(creation!.waveEnabled ? 1 : 0)
                                                ), maxSampleOffset: .zero)
                                            
                                        }
                                    
                                }
                            }
                        }
                        Text(showBreatheIn ? "Breathe In" : "Breathe Out")
                            .font(.custom("Snell Roundhand", size: fontSize))
                            .bold()
                            .foregroundColor(Color.white)
                            .transition(.opacity)
                            .frame(width: 300, height: 200)
                            .animation(.easeInOut(duration: 1), value: fontSize)
                            .onChange(of: oscillatingFactor(for: CGFloat(startDate.timeIntervalSinceNow))) {
                                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: false)) {
                                    if showBreatheIn {
                                        let elapsedTime = CGFloat(Date().timeIntervalSince(startDate))
                                        fontSize = 30 + 20 * oscillatingFactor(for: elapsedTime)
                                    } else {
                                        let elapsedTime = CGFloat(Date().timeIntervalSince(startDate))
                                        fontSize = 30 - 20 * oscillatingFactor(for: elapsedTime)
                                    }
                                }
                            }
                            .onChange(of: oscillatingFactor(for: CGFloat(startDate.timeIntervalSinceNow))) {
                                let factor = oscillatingFactor(for: CGFloat(startDate.timeIntervalSinceNow))
                                if factor <= 0.75 {
                                    showBreatheIn = true
                                } else {
                                    showBreatheIn = false
                                }
                            }

                        Text("\(timeRemaining)")
                            .font(.custom("Snell Roundhand", size: 50))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .onAppear {
                    wellnessManager.fetchAllRecording()
                    if creation!.audioRecording != nil {
                        wellnessManager.startPlaying(url: creation!.audioRecording!.fileURL)
                    }
                }
                .onReceive(timer) { time in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                    else {
                        timer.upstream.connect().cancel()
                        wellnessManager.addWellnessData()
                        wellnessManager.updateCompletions(name: creation!.name)
                        dismiss()
                        if creation!.audioRecording != nil && creation!.audioRecording!.isPlaying {
                            wellnessManager.stopPlaying(url: creation!.audioRecording!.fileURL)
                        }

                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }

    private func xOffset(for index: Int, factor: CGFloat) -> CGFloat {
        let angle = angleForCircle(at: index)
        return radius * cos(angle) * CGFloat(factor)
    }
    
    private func yOffset(for index: Int, factor: CGFloat) -> CGFloat {
        let angle = angleForCircle(at: index)
        return radius * sin(angle) * factor
    }
    private func angleForCircle(at index: Int) -> CGFloat {
        return CGFloat(2) * CGFloat.pi / CGFloat(creation!.numberOfCircles) * CGFloat(index)
    }
    
    func oscillatingFactor(for startDate: CGFloat) -> CGFloat {
        let sineValue = sin(startDate)
        let oscillation = (sineValue + 1) / 2
        return 0.5 + oscillation * 0.5
    }
    
}

#Preview {
    WellnessRun()
        .environment(WellnessManager())
}

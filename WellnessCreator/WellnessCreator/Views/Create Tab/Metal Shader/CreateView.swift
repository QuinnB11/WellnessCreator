//
//  CreateView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 11/27/24.
//

import SwiftUI

struct CreateView: View {
    
    @Environment(WellnessManager.self) var wellnessManager

    // Audio Recording
    @State private var selectedRecording: Recording?

    
    // Number of Shapes + Shape + Name
    @State private var strength = 3.0
    @State private var numberOfCircles : Int = 5
    @State private var corners : Int = 0
    @State private var name: String = "Wellness 1"

    
    //Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Enabled Variables
    @State private var noiseEnabled : Bool = false
    @State private var waveEnabled : Bool = false
    @State private var checkerEnabled: Bool = false
    @State private var flipHueEnabled: Bool = false
    
    
    
    // Color variables
    @State private var colors: [Color] = [.blue, .green, .yellow, .red, .purple]
    
    
    
    // Movment variables
    @State private var xOffsetFactor: CGFloat = 1
    @State private var xIsEditing = false
    @State private var yOffsetFactor: CGFloat = 1
    @State private var yIsEditing = false
    
    
    // Strength of Animation Features
    @State private var waveStrength : CGFloat = 1
    @State private var noiseStrength: CGFloat = 1
    @State private var checkerboardSize: CGFloat = 10
    
    // Basic needs for movement and size for app
    let radius: CGFloat = 50
    let startDate = Date()
    let center = CGPoint(x: 50, y: 50)

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.black).ignoresSafeArea()
                VStack {
                    Button(action: {
                        if wellnessManager.wellnessCreations.contains(where: { $0.name == name }) {
                               alertMessage = "You must have a different name than previous ones."
                               showAlert = true
                           } else {
                               wellnessManager.appendWellnessCreation(
                                   name: name,
                                   audioRecording: selectedRecording,
                                   strength: strength,
                                   numberOfCircles: numberOfCircles,
                                   corners: corners,
                                   noiseEnabled: noiseEnabled,
                                   waveEnabled: waveEnabled,
                                   checkerEnabled: checkerEnabled,
                                   flipHueEnabled: flipHueEnabled,
                                   colors: colors,
                                   xOffsetFactor: xOffsetFactor,
                                   xIsEditing: xIsEditing,
                                   yOffsetFactor: yOffsetFactor,
                                   yIsEditing: yIsEditing,
                                   waveStrength: waveStrength,
                                   noiseStrength: noiseStrength,
                                   checkerboardSize: checkerboardSize
                               )
                           }
                       }) {
                        Text("Submit")
                            .font(.custom("Snell Roundhand", size: 30))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(20)
                            
                        
                    }
                    .padding(.top,50)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Duplicate Name"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    ZStack {
                        ForEach(0..<numberOfCircles, id: \.self) { index in
                            TimelineView(.animation) { context in
                                PolygonShape(corners: corners, center: center, radius: radius)
                                    .fill(colors[index % colors.count])
                                    .frame(width: radius * 2, height: radius * 2)
                                    .offset(x: xOffset(for: index, factor: xOffsetFactor * oscillatingFactor(for: CGFloat(startDate.timeIntervalSinceNow))), y: yOffset(for: index, factor: yOffsetFactor * oscillatingFactor(for: CGFloat(startDate.timeIntervalSinceNow))))
                                    .opacity(0.5)
                                    .colorEffect(ShaderLibrary.noise(.float(startDate.timeIntervalSinceNow), .float(noiseStrength), .float(noiseEnabled ? 1 : 0)))
                                    .colorEffect(ShaderLibrary.checkerboard(.float(startDate.timeIntervalSinceNow), .float(20), .float(10), .float(checkerEnabled ? 1 : 0)))
                                    .colorEffect(ShaderLibrary.flipHue(.float(startDate.timeIntervalSinceNow), .float(flipHueEnabled ? 1 : 0)))
                                    .visualEffect { content, proxy in
                                        content
                                            .distortionEffect(ShaderLibrary.complexWave(
                                                .float(startDate.timeIntervalSinceNow),
                                                .float2(proxy.size),
                                                .float(0.1),
                                                .float(3),
                                                .float(10),
                                                .float(waveEnabled ? 1 : 0)
                                            ), maxSampleOffset: .zero)
                                        
                                    }
                                
                                
                                
                            }
                        }
                    }
                    .frame(width: radius * 4, height: radius * 4)
                    .padding(.vertical, 30)
                    FancyTextField(name: $name)
                    Picker("Select a recording", selection: $selectedRecording) {
                        ForEach(wellnessManager.recordingsList, id: \.createdAt) {
                                   Text($0.fileURL.lastPathComponent)
                                        .tag($0 as Recording?)
                                   }
                               }
                               .pickerStyle(MenuPickerStyle())
                    ScrollView(.vertical, showsIndicators: false) {
                        Menu(
                            xOffsetFactor: $xOffsetFactor,
                            yOffsetFactor: $yOffsetFactor,
                            numberOfCircles: $numberOfCircles,
                            corners: $corners,
                            colors: $colors,
                            xIsEditing: $xIsEditing,
                            yIsEditing: $yIsEditing,
                            waveIsOn: $waveEnabled,
                            noiseIsOn: $noiseEnabled,
                            checkerboardIsOn: $checkerEnabled,
                            flipHueIsOn: $flipHueEnabled,
                            waveStrength: $waveStrength,
                            noiseStrength: $noiseStrength,
                            checkboardSize: $checkerboardSize
                        )
                    }
                }
                .padding()
            }

        }
        
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
        return CGFloat(2) * CGFloat.pi / CGFloat(numberOfCircles) * CGFloat(index)
    }
    
    func oscillatingFactor(for startDate: CGFloat) -> CGFloat {
        let sineValue = sin(startDate)
        let oscillation = (sineValue + 1) / 2
        return 0.5 + oscillation * 0.5
    }
}

#Preview {
    CreateView()
        .environment(WellnessManager())
}

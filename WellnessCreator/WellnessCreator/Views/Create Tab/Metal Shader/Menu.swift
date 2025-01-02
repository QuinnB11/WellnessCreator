//  Menu.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/1/24.
//
import SwiftUI

struct Menu: View {
    
    @Binding var xOffsetFactor: CGFloat
    @Binding var yOffsetFactor: CGFloat
    @Binding var numberOfCircles: Int
    @Binding var corners: Int
    @Binding var colors: [Color]
    
    @Binding var xIsEditing: Bool
    @Binding var yIsEditing: Bool
    
    
    
    
    @Binding var waveIsOn: Bool
    @Binding var noiseIsOn: Bool
    @Binding var checkerboardIsOn : Bool
    @Binding var flipHueIsOn : Bool
    
    @Binding var waveStrength: CGFloat
    @Binding var noiseStrength: CGFloat
    @Binding var checkboardSize: CGFloat
    

    
    var body: some View {
        VStack {
            // X Offset Slider
            Section {
                Slider(value: $xOffsetFactor, in: 0...2, step: 0.01) {
                    Text("X Offset")
                }
                minimumValueLabel: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.white)
                }
                maximumValueLabel: {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                onEditingChanged: { editing in
                    xIsEditing = editing
                }
                Text(String(format: "%.2f", xOffsetFactor))
                    .foregroundColor(xIsEditing ? Color.red : Color.white)
                    .font(.system(size: 16, weight: .bold))
                    .shadow(color: Color.black, radius: 4, x: 2, y: 2)
                    .padding()
            }.accentColor(.gray)

            // Y Offset Slider
            Section {
                Slider(value: $yOffsetFactor, in: 0...2, step: 0.01) {
                    Text("Y Offset")
                }
                minimumValueLabel: {
                    Image(systemName: "arrow.down")
                        .foregroundColor(.white)
                }
                maximumValueLabel: {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.white)
                }
                onEditingChanged: { editing in
                    yIsEditing = editing
                }
                Text(String(format: "%.2f", yOffsetFactor))
                    .foregroundColor(yIsEditing ? .red : .white)
                    .font(.system(size: 16, weight: .bold))
                    .shadow(color: .black, radius: 4, x: 2, y: 2)
                    .padding()
            }.accentColor(.gray)

            // Color Pickers in a row
            Section(header: Text("Colors")
                .foregroundColor(.white)
                .font(.headline)
                .bold()
            ) {
                HStack {
                    ForEach(0..<colors.count, id: \.self) { index in
                        ColorPicker("Color \(index + 1)", selection: $colors[index])
                            .padding(.horizontal)
                    }
                }
            }

            // Number of Circles Picker
            Section(header: Text("Number of Shapes")
                .foregroundColor(.white)
                .font(.headline)
                .bold()
                .padding(.bottom, 5)
            ) {
                Picker("Number of Circles", selection: $numberOfCircles) {
                    ForEach(0..<8, id: \.self) { count in
                        Text("\(count)")
                            .tag(count)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Capsule().fill(Color.gray.opacity(0.3)))
            }

            // Number of Corners Picker
            Section(header: Text("Number of Corners")
                .foregroundColor(.white)
                .font(.headline)
                .bold()
                .padding(.bottom, 5)
            ) {
                Picker("Number of Corners", selection: $corners) {
                    ForEach([0, 3, 4, 5, 6, 7, 8, 9], id: \.self) { count in
                        Text("\(count)")
                            .tag(count)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Capsule().fill(Color.gray.opacity(0.3)))
            }
            
            // Animation Features
            Section(header: Text("Animation Features")
                .foregroundColor(.white)
                .font(.headline)
                .bold()
                .padding(.bottom, 5)
            ) {
                VStack {
                    ToggleWithSlider(
                        title: "Checkerboard Effect",
                        toggleIsOn: $checkerboardIsOn
                    )
                    
                    ToggleWithSlider(
                        title: "Wave Effect",
                        toggleIsOn: $waveIsOn,
                        sliderValue: $waveStrength,
                        sliderLabel: "Wave Strength"
                    )
                    
                    ToggleWithSlider(
                        title: "Noise Effect",
                        toggleIsOn: $noiseIsOn,
                        sliderValue: $noiseStrength,
                        sliderLabel: "Noise Strength"
                    )
                    
                    ToggleWithSlider(
                        title: "Flip Hue Effect",
                        toggleIsOn: $flipHueIsOn
                    )
                }
                .padding()
            }
            
        }
        .padding()
    }
}

#Preview {
    ZStack {
        Color(.black).ignoresSafeArea()
        Menu(
            xOffsetFactor: .constant(1),
            yOffsetFactor: .constant(1),
            numberOfCircles: .constant(5),
            corners: .constant(5),
            colors: .constant([.blue, .green, .yellow, .red, .purple]),
            xIsEditing: .constant(false),
            yIsEditing: .constant(false),
            waveIsOn: .constant(false),
            noiseIsOn: .constant(true),
            checkerboardIsOn: .constant(true),
            flipHueIsOn: .constant(false),
            waveStrength: .constant(0.5),
            noiseStrength: .constant(0.5),
            checkboardSize: .constant(0.5)
            
        )
    }
}

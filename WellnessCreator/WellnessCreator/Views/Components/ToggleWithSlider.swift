//
//  ToggleWithSlider.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/2/24.
//

import SwiftUI

struct ToggleWithSlider: View {
    var title: String
    @Binding var toggleIsOn: Bool
    var sliderValue: Binding<CGFloat>?
    var sliderLabel: String?

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .bold))
                    .shadow(color: .black, radius: 4, x: 2, y: 2)
                    .padding()
                
                Toggle(title, isOn: $toggleIsOn)
                    .toggleStyle(SwitchToggleStyle(tint: .gray))
            }
            
            if toggleIsOn, let sliderValue = sliderValue, let sliderLabel = sliderLabel {
                Slider(value: sliderValue, in: 0...1, step: 0.01) {
                    Text(sliderLabel)
                }
                .accentColor(.gray)
                
                Text(String(format: "%.2f", sliderValue.wrappedValue))
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .shadow(color: .black, radius: 4, x: 2, y: 2)
                    .padding()
            }
        }
    }
}

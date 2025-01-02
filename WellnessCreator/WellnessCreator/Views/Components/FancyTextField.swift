//
//  FancyTextField.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/2/24.
//


import SwiftUI

struct FancyTextField: View {
    @Binding var name: String

    var body: some View {
        VStack {
            TextField("Enter text", text: $name)
                .font(.custom("Snell Roundhand", size: 40))
                .foregroundColor(.white)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .frame(width: 300, height: 1)
                .padding(.top, -4)
                .foregroundColor(.white)
        }
        .padding()
    }
}


#Preview {
    ZStack {
        Color(.black)
        FancyTextField(name: .constant("Wellness 1"))

    }
}

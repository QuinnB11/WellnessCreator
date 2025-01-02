//
//  LoginView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 11/18/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(WellnessManager.self) var wellnessManager

    @State private var dragOffset = CGSize.zero
    @State private var isSwipedUp = false
    
    var body: some View {
        ZStack {
            if !isSwipedUp {
                Color.black.ignoresSafeArea()
                
                WavesView()
                
                VStack {
                    Spacer()
                    
                    Text("Welcome")
                        .font(.custom("Zapfino", size: 30))
                        .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.up")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    if dragOffset.height < -5 {
                                        withAnimation {
                                            isSwipedUp = true
                                        }
                                    }
                                    dragOffset = .zero
                                }
                        )
                }
                .padding()
            } else {
                RootView()
            }
        }
    }
}





#Preview {
    LoginView()
        .environment(WellnessManager())

}

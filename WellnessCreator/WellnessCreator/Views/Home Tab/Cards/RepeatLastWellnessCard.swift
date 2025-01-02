//
//  RepeatLastWellnessCard.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/2/24.
//

import SwiftUI

struct RepeatLastWellnessCard: View {
    @Environment(WellnessManager.self) var wellnessManager
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray)
                .cornerRadius(15)
                .opacity(0.5)
                .overlay(
                    VStack {
                        VStack (alignment: .leading, spacing: 5) {
                            Text("Repeat")
                                .font(.custom("Snell Roundhand", size: 30))
                                .foregroundColor(Color.white)
                            Divider()
                                .background(Color.gray)
                        }
                        if let creationInfo = wellnessManager.getCreationWithHighestCompletions()?.split(separator: ":") {
                            
                            VStack (alignment: .leading, spacing: -5) {
                                Text(creationInfo.first ?? "")
                                        .font(.custom("Snell Roundhand", size: 25))
                                        .foregroundColor(Color.white)
                                
                                Text("  Completions: \(creationInfo.last ?? "")")
                                        .font(.custom("Snell Roundhand", size: 15))
                                        .foregroundColor(Color.white)
                            }
                            } else {
                                Text("No creations found")
                                    .foregroundColor(Color.white)
                                    .font(.custom("Snell Roundhand", size: 30))
                            }
                        
                    }
                )
                .padding()
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    RepeatLastWellnessCard()
        .environment(WellnessManager())
}

//
//  HeartRateCardView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 11/19/24.
//

import SwiftUI

struct HeartRateCardView: View {
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
                                Text("Heart Rate")
                                    .font(.custom("Snell Roundhand", size: 30))
                                    .foregroundColor(Color.white)
                                Divider()
                                    .background(Color.gray)
                            }
                            HeartRateRing(heartRate: wellnessManager.heartRateToday)
                        }
                    )
                    .padding()
            }
            .frame(width: 200, height: 200)
        }
    }

#Preview {
    HeartRateCardView()
        .environment(WellnessManager())
}

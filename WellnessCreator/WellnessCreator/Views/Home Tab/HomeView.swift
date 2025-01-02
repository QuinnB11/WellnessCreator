//
//  HomeView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 11/18/24.
//

import SwiftUI

struct HomeView: View {

    @Environment(WellnessManager.self) var wellnessManager
    let currentDate = Date()

    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: -30) {
                        Text(wellnessManager.dateFormatter.string(from: currentDate))
                            .font(.custom("Snell Roundhand", size: 30))
                            .foregroundColor(Color.white)
                        Text("Summary")
                            .font(.custom("Snell Roundhand", size: 50))
                            .foregroundColor(Color.white)
                    }.padding()
                    Spacer()
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .padding()
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    DailyHourCard()
                    HStack {
                        HeartRateCardView()
                        RepeatLastWellnessCard()
                    }
                    WeeklyHeartRateCardView()
                }
                
            }
        }
    }
    
    
}

#Preview {
    HomeView()
        .environment(WellnessManager())
}

//
//  DailyHourCard.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/1/24.
//


import SwiftUI

struct DailyHourCard: View {
    @Environment(WellnessManager.self) var wellnessManager
    var body: some View {
            VStack {
                Rectangle()
                    .fill(Color.gray)
                    .cornerRadius(15)
                    .opacity(0.4)
                    .overlay(
                        VStack {
                            VStack (alignment: .leading, spacing: -15) {
                                Text("Wellness Minutes")
                                    .font(.custom("Snell Roundhand", size: 40))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 4)
                                Divider()
                                    .background(Color.white)
                            }
                            HStack(spacing: 40) {
                                ZStack {
                                    Circle()
                                        .stroke(Color.black.opacity(0.3), lineWidth: 20)
                                        .frame(width: 125, height: 125)

                                    Circle()
                                        .trim(from: 0.0, to: wellnessManager.getWellnessMins()/10)
                                        .stroke(
                                            .pink,
                                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                        )
                                        .rotationEffect(.degrees(-90))
                                        .frame(width: 125, height: 125)
                                        .opacity(0.7)
                                    
                                    Image(systemName: "figure")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                        .offset(y: -62)
                                        .opacity(0.6)
                                        .foregroundColor(.white)
                                    
                                    Circle()
                                        .stroke(Color.black.opacity(0.3), lineWidth: 20)
                                        .frame(width: 85, height: 85)
                                    Circle()
                                        .trim(from: 0.0, to: wellnessManager.getTotalWellnessMinsForWeek()/35)
                                           .stroke(
                                               .blue,
                                               style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                           )
                                        .rotationEffect(.degrees(-90))
                                        .frame(width: 85, height: 85)
                                        .opacity(0.7)
                                    Image(systemName: "calendar")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                        .offset(y: -42)
                                        .opacity(0.6)
                                        .foregroundColor(.white)


                                }
                                .padding(.trailing,20)
                                VStack {
                                    VStack (alignment: .leading, spacing: -10) {
                                        Text("Daily")
                                            .font(.custom("Snell Roundhand", size: 30))
                                            .foregroundColor(.white)
                                        Text ("\(wellnessManager.getWellnessMins())"+"/5 Mins")
                                            .font(.custom("Snell Roundhand", size: 20))
                                            .foregroundColor(.pink)
                                    }
                                    VStack (alignment: .leading, spacing: -10) {
                                        Text("Weekly")
                                            .font(.custom("Snell Roundhand", size: 30))
                                            .foregroundColor(.white)
                                        Text ("\(wellnessManager.getTotalWellnessMinsForWeek())"+"/35 Mins")
                                            .font(.custom("Snell Roundhand", size: 20))
                                            .foregroundColor(.blue)
                                    }
                                    
                                }
                            }
                        }
                    )
                    .padding()
            }
            .frame(width: 400, height: 265)
        }
}

#Preview {
    DailyHourCard()
        .environment(WellnessManager())
}

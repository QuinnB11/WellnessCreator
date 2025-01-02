//
//  WeaklyHeartRateCardView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/2/24.
//

import SwiftUI
import Charts

struct WeeklyHeartRateCardView: View {
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
                            Text("Weekly Heart Rate")
                                .font(.custom("Snell Roundhand", size: 30))
                                .foregroundColor(.white)
                            Divider()
                                .background(Color.gray)
                        }
                        ZStack {
                            Chart {
                                ForEach(wellnessManager.thisWeeksHeartRate.keys.sorted(), id: \.self) { day in
                                    PointMark(
                                        x: .value("Day", wellnessManager.dayNames[day] ?? ""),
                                        y: .value("Heart Rate", wellnessManager.thisWeeksHeartRate[day] ?? 0)
                                    )
                                    .symbol(.circle)
                                    .foregroundStyle(Color.pink)
                                }
                                
                                ForEach(wellnessManager.thisWeeksHeartRate.keys.sorted(), id: \.self) { day in
                                    LineMark(
                                        x: .value("Day", wellnessManager.dayNames[day] ?? ""),
                                        y: .value("Heart Rate", wellnessManager.thisWeeksHeartRate[day] ?? 0)
                                    )
                                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 3]))
                                    .foregroundStyle(Color.pink.opacity(0.6))
                                    
                                }
                            }
                            .foregroundColor(.white)
                            .frame(height: 150)
                            .padding()
                            .chartXAxis {
                                AxisMarks(values: .automatic) { value in
                                    AxisTick()
                                        .foregroundStyle(.white)
                                    AxisGridLine()
                                        .foregroundStyle(.white)
                                    AxisValueLabel()
                                        .foregroundStyle(.white)
                                }
                            }
                            .chartYAxis {
                                AxisMarks(values: .automatic) { value in
                                    AxisGridLine()
                                        .foregroundStyle(.white)
                                    AxisTick()
                                        .foregroundStyle(.white)
                                    AxisValueLabel()
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                )
                .padding()
        }
        .frame(width: 400, height: 275)

    }
}

#Preview {
    WeeklyHeartRateCardView()
        .environment(WellnessManager())
}

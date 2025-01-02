//  RecordingView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/14/24.
//

import SwiftUI

struct RecordingListView: View {
    @Environment(WellnessManager.self) var wellnessManager
    var body: some View {
        
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(wellnessManager.recordingsList, id: \.createdAt) { recording in
                        VStack {
                            HStack {
                                Image(systemName: "headphones.circle")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)

                                
                                VStack(alignment: .leading) {
                                    Text("\(recording.fileURL.lastPathComponent)")
                                }
                                
                                VStack {
                                    Button(action: {
                                        wellnessManager.deleteRecording(url: recording.fileURL)
                                    }) {
                                        Image(systemName: "xmark.circle")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if recording.isPlaying {
                                            wellnessManager.stopPlaying(url: recording.fileURL)
                                        } else {
                                            wellnessManager.startPlaying(url: recording.fileURL)
                                        }
                                    }) {
                                        Image(systemName: recording.isPlaying ? "stop" : "play")
                                            .foregroundColor(.white)
                                            .font(.system(size: 30))
                                    }
                                    
                                }
                                
                            }
                            .padding()
                        }
                        .padding(.horizontal, 10)
                        .frame(width: 370, height: 85)
                        .background(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                        .cornerRadius(30)
                        .shadow(color: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.3), radius: 10, x: 0, y: 10)
                    }
                }
            }
        }
        .padding(.top,30)
        .navigationBarTitle("Recordings")
        
    }
}

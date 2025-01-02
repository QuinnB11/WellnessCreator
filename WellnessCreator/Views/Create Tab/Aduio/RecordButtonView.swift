//
//  RecordButtonView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/14/24.
//

import SwiftUI


struct RecordButtonView: View {
    
    @Environment(WellnessManager.self) var wellnessManager
    
    @State private var showingList = false
    @State private var showingAlert = false
    
    @State private var effect1 = false
    @State private var effect2 = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack{
                if wellnessManager.isRecording {
                    VStack(alignment : .leading , spacing : -5){
                        HStack (spacing : 3) {
                            Image(systemName: wellnessManager.isRecording && wellnessManager.toggleColor ? "circle.fill" : "circle")
                                .font(.system(size:10))
                                .foregroundColor(.red)
                            Text("Rec")
                        }
                        Text(wellnessManager.timer)
                            .font(.system(size:60))
                            .foregroundColor(.white)
                    }
                    
                } else {
                    VStack{
                        Text("Press the Recording Button below and stop when its done. 30 seconds is the max time limit currently!")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                    }.frame(width: 300, height: 200, alignment: .center)
                    
                    
                }
                
                
                Button(action: {
                    if wellnessManager.isRecording == true {
                        wellnessManager.stopRecording()
                    }
                    wellnessManager.fetchAllRecording()
                    showingList.toggle()
                }) {
                    Label("List of Recordings", systemImage: "list.bullet")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }.sheet(isPresented: $showingList, content: {
                    RecordingListView()
                })
                
                
                Spacer()
                ZStack {
                    Circle()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color(#colorLiteral(red: 0.4157493109, green: 0.8572631, blue: 0.9686274529, alpha: 0.4940355314)))
                        .scaleEffect(effect2 ? 1 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 0.5)
                                .repeatForever(autoreverses: true)
                                .speed(1),
                            value: effect2
                        )
                        .onAppear(){
                            self.effect2.toggle()
                        }
                    
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                        .scaleEffect(effect2 ? 1 : 1.5)
                        .animation(
                            Animation.easeInOut(duration: 0.5)
                                .repeatForever(autoreverses: true)
                                .speed(2),
                            value: effect1
                        )
                        .onAppear(){
                            self.effect1.toggle()
                        }
                    
                    Image(systemName: wellnessManager.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 45))
                        .onTapGesture {
                            if wellnessManager.isRecording == true {
                                wellnessManager.stopRecording()
                            } else {
                                wellnessManager.startRecording()
                            }
                        }
                }.padding(.bottom, 30)
            }
        }
    }
}




#Preview {
    RecordButtonView()
        .environment(WellnessManager())
    
    
}

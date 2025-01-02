//
//  RootView.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/2/24.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab = 1
    @Environment(WellnessManager.self) var wellnessManager

    var body: some View {
        TabView(selection: $selectedTab) {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "building.columns")
                }
                .tag(0)

            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)

            CreateView()
                .tabItem {
                    Label("Create", systemImage: "plus")
                }
                .tag(2)
            RecordButtonView()
                .tabItem {
                    Label("Record", systemImage: "microphone")
                }
                .tag(3)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .onChange(of: selectedTab) {
            if selectedTab < 0 {
                selectedTab = 0
            } else if selectedTab > 3 {
                selectedTab = 3
            }
            wellnessManager.fetchAllRecording()
        }
        .ignoresSafeArea()
        .background(Color.black)
        .tint(.gray)

    }
}
#Preview {
    RootView()
        .environment(WellnessManager())
}

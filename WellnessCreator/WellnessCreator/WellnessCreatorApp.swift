//
//  WellnessCreatorApp.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 11/15/24.
//

import SwiftUI

@main
struct WellnessCreatorApp: App {
    @State var wellnessManager = WellnessManager()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(wellnessManager)
        }
    }
}

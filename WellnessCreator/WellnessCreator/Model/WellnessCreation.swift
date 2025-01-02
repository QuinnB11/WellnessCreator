//
//  WellnessCreation.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/2/24.
//

import SwiftUI
import Foundation

struct WellnessCreation: Identifiable, Codable {
    var id: String { name }
    var name: String
    var audioRecording: Recording?
    var completions: Int
    var strength: Double
    var numberOfCircles: Int
    var corners: Int
    
    var noiseEnabled: Bool
    var waveEnabled: Bool
    var checkerEnabled: Bool
    var flipHueEnabled: Bool
    
    var colors: [String]
    
    var xOffsetFactor: CGFloat
    var xIsEditing: Bool
    var yOffsetFactor: CGFloat
    var yIsEditing: Bool
    
    var waveStrength: CGFloat
    var noiseStrength: CGFloat
    var checkerboardSize: CGFloat
    
}


//
//  WellnessManager.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 11/18/24.
//

import Foundation
import HealthKit
import WidgetKit
import AVFoundation
import SwiftUI



@Observable
class WellnessManager : NSObject, AVAudioPlayerDelegate {
    
    // MARK: -- Wellness Variables
    
    //Persistance
    let persistanceWellness : StorageManager = StorageManager<[WellnessData]>(filename: "WellnessData")
    let persistanceWellnessCreations : StorageManager = StorageManager<[WellnessCreation]>(filename: "WellnessCreations")
    
    
    var wellnessData : [WellnessData]
    var wellnessCreations : [WellnessCreation]
    
    
    //Audio
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var countSec = 0
    var timerCount : Timer?
    var blinkingCount : Timer?
    var timer : String = "0:00"
    var toggleColor : Bool = false
    var isRecording : Bool = false
    var recordingsList = [Recording]()
    var playingURL : URL?
    
    
    //Health
    let health: HKHealthStore = HKHealthStore()
    let heartRateUnit:HKUnit = HKUnit(from: "count/min")
    let heartRateType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
    var heartRateQuery:HKSampleQuery?
    
    
    // Heart Rate Saved Information
    var heartRateYesterday: Int = 0
    var heartRateToday: Int = 0
    var thisWeeksHeartRate: [Int: Int] = [1: 0, 2: 0, 3: 0,
                                          4: 0, 5: 0, 6: 0, 7: 0]
    
    // Heart Rate Day storage
    var dayNames: [Int: String] = [
        1: "Sunday", 2: "Monday", 3: "Tuesday", 4: "Wednesday", 5: "Thursday",
        6: "Friday", 7: "Saturday"
    ]
    
    override init() {
        wellnessData = persistanceWellness.modelData ?? []
        wellnessCreations = persistanceWellnessCreations.modelData ?? []
        super.init()
        requestAuthorization()
        fetchAllRecording()
        resetWellnessDataIfNeeded()

    }
    
    
    // MARK: -- Wellness Private Functions
    
    /// Checks if date needs to be switched for wellness minutes today and for the week.
    private func resetWellnessDataIfNeeded() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        if let lastSavedDate = UserDefaults.standard.object(forKey: "lastSavedDate") as? Date {
            if !calendar.isDate(currentDate, inSameDayAs: lastSavedDate) {
                var newWellnessData = WellnessData(wellnessMinsToday: 30, thisweeksWellnessMins: [0, 0, 0, 0, 0, 0, 0])
                let lastWeekWellnessData = wellnessData.prefix(7)
                let wellnessMinsFromLastWeek = lastWeekWellnessData.map { $0.thisweeksWellnessMins }.flatMap { $0 }
                let combinedWellnessData = Array(wellnessMinsFromLastWeek.suffix(6) + [0])
                newWellnessData.thisweeksWellnessMins = Array(combinedWellnessData.suffix(7))
                wellnessData.append(newWellnessData)
            }
        }
        
        UserDefaults.standard.set(currentDate, forKey: "lastSavedDate")
    }
    
    
    
    
    // MARK: -- Public Functions
    
    /// Returns the wellness minutes for today
    /// - Returns: A `CGFloat` indicating the wellness minutes today
    func getWellnessMins() -> CGFloat {
        return CGFloat(wellnessData.last?.wellnessMinsToday ?? 0)
    }
    
    /// Returns the total wellness minutes for the week
    /// - Returns: A `CGFloat` indicating the total wellness minutes for the current week
    func getTotalWellnessMinsForWeek() -> CGFloat {
        return CGFloat(wellnessData.last!.thisweeksWellnessMins.reduce(0) { $0 + CGFloat($1) })
    }
    
    /// Adds wellness data for today, incrementing today's wellness minutes and the weekly total
    func addWellnessData() {
        if wellnessData.count > 0 {
            var lastData = wellnessData[wellnessData.count - 1]
            lastData.wellnessMinsToday += 1
            lastData.thisweeksWellnessMins[6] += 1
            wellnessData[wellnessData.count - 1] = lastData
        }
        persistanceWellness.save(components: wellnessData)
    }
    
    /// Appends a new wellness creation to the list of creations
    /// - Parameters:
    ///   - name: The name of the wellness creation
    ///   - audioRecording: An optional audio recording associated with the creation
    ///   - strength: The strength of the wellness creation
    ///   - numberOfCircles: The number of circles in the creation
    ///   - corners: The number of corners in the creation
    ///   - noiseEnabled: Whether noise is enabled for the creation
    ///   - waveEnabled: Whether wave effect is enabled for the creation
    ///   - checkerEnabled: Whether checkerboard effect is enabled for the creation
    ///   - flipHueEnabled: Whether hue flipping is enabled for the creation
    ///   - colors: A list of colors used in the creation
    ///   - xOffsetFactor: The X offset factor for positioning
    ///   - xIsEditing: Whether the X position is being edited
    ///   - yOffsetFactor: The Y offset factor for positioning
    ///   - yIsEditing: Whether the Y position is being edited
    ///   - waveStrength: The strength of the wave effect
    ///   - noiseStrength: The strength of the noise effect
    ///   - checkerboardSize: The size of the checkerboard pattern
    func appendWellnessCreation(
        name: String,
        audioRecording: Recording?,
        strength: Double,
        numberOfCircles: Int,
        corners: Int,
        noiseEnabled: Bool,
        waveEnabled: Bool,
        checkerEnabled: Bool,
        flipHueEnabled: Bool,
        colors: [Color],
        xOffsetFactor: CGFloat,
        xIsEditing: Bool,
        yOffsetFactor: CGFloat,
        yIsEditing: Bool,
        waveStrength: CGFloat,
        noiseStrength: CGFloat,
        checkerboardSize: CGFloat
    ) {
        let colorStrings = colors.map { color in
            return color.toHex() ?? "#FFFFFF"
        }
        
        let newCreation = WellnessCreation(
            name: name,
            audioRecording: audioRecording,
            completions: 0,
            strength: strength,
            numberOfCircles: numberOfCircles,
            corners: corners,
            noiseEnabled: noiseEnabled,
            waveEnabled: waveEnabled,
            checkerEnabled: checkerEnabled,
            flipHueEnabled: flipHueEnabled,
            colors: colorStrings,
            xOffsetFactor: xOffsetFactor,
            xIsEditing: xIsEditing,
            yOffsetFactor: yOffsetFactor,
            yIsEditing: yIsEditing,
            waveStrength: waveStrength,
            noiseStrength: noiseStrength,
            checkerboardSize: checkerboardSize
        )
        
        wellnessCreations.append(newCreation)
        
        persistanceWellnessCreations.save(components: wellnessCreations)
    }
    
    // Deletes a WellnessCreation based on the given name.
    /// - Parameter name: The name of the wellness creation to delete.
    func deleteWellnessCreation(named name: String) {
        if let index = wellnessCreations.firstIndex(where: { $0.name == name }) {
            wellnessCreations.remove(at: index)
            persistanceWellnessCreations.save(components: wellnessCreations)
        } else {
            print("No wellness creation found with the name \(name)")
        }
    }
    
    /// Updates the completion count for a specific wellness creation by name
    /// - Parameter name: The name of the wellness creation to update
    func updateCompletions(name: String) {
        if let index = wellnessCreations.firstIndex(where: { $0.name == name }) {
            wellnessCreations[index].completions += 1
        }
        persistanceWellnessCreations.save(components: wellnessCreations)
    }
    
    /// Returns the name and completion count of the wellness creation with the highest number of completions
    /// - Returns: A `String?` containing the name and completion count of the most completed creation, or `nil` if no creations exist
    func getCreationWithHighestCompletions() -> String? {
        guard let highestCompletionCreation = wellnessCreations.max(by: { $0.completions < $1.completions }) else {
            return nil
        }
        return highestCompletionCreation.name + ":" + String(highestCompletionCreation.completions)
    }
    
    /// Returns a configured `DateFormatter` for long date style without time
    /// - Returns: A `DateFormatter` object set to long date style
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
}

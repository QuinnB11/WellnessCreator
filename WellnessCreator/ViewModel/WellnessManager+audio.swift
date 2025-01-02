//
//  WellnessManager+audio.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/13/24.
//

import Foundation
import AVFoundation


extension WellnessManager {
    
    /// Called when the audio player finishes playing a file, updating the `isPlaying` status of the relevant recording
    /// - Parameters:
    ///   - player: The `AVAudioPlayer` instance that finished playing
    ///   - flag: A boolean indicating whether the playback finished successfully
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == playingURL {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
    /// Starts a new audio recording session, setting up the audio session and preparing to record
    /// Records the audio to a file with a timestamped filename
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Cannot setup the Recording")
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = path.appendingPathComponent("WellnessCreator : \(Date().toString(dateFormat: "dd-MM-YY 'at' HH:mm:ss")).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
            
            timerCount = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (value) in
                self.countSec += 1
                self.timer = self.covertSecToMinAndHour(seconds: self.countSec)
            })
            blinkColor()
            
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    /// Stops the current audio recording session and resets related properties
    func stopRecording() {
        audioRecorder.stop()
        
        isRecording = false
        
        self.countSec = 0
        
        timerCount!.invalidate()
        blinkingCount!.invalidate()
    }
    
    /// Fetches all recorded files from the document directory and sorts them by creation date
    /// Updates the `recordingsList` with the file URLs and creation dates
    func fetchAllRecording() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        
        recordingsList = []
        for i in directoryContents {
            recordingsList.append(Recording(fileURL: i, createdAt: getFileDate(for: i), isPlaying: false))
        }
        
        recordingsList.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })
    }
    
    /// Starts playing an audio file from the given URL and updates the `isPlaying` status for the recording
    /// - Parameter url: The URL of the recording to play
    func startPlaying(url: URL) {
        let playSession = AVAudioSession.sharedInstance()
        
        do {
            try playSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing failed in Device")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            for i in 0..<recordingsList.count {
                if recordingsList[i].fileURL == url {
                    recordingsList[i].isPlaying = true
                }
            }
            
        } catch {
            print("Playing Failed")
        }
    }
    
    /// Stops playing the audio from the specified URL and updates the `isPlaying` status for the recording
    /// - Parameter url: The URL of the recording to stop playing
    func stopPlaying(url: URL) {
        audioPlayer.stop()
        
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == url {
                recordingsList[i].isPlaying = false
            }
        }
    }
    
    /// Deletes a recording from the file system and removes it from the `recordingsList`
    /// If the recording is currently playing, it stops playing before deletion
    /// - Parameter url: The URL of the recording to delete
    func deleteRecording(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Can't delete")
        }
        
        for i in 0..<recordingsList.count {
            if recordingsList[i].fileURL == url {
                if recordingsList[i].isPlaying == true {
                    stopPlaying(url: recordingsList[i].fileURL)
                }
                
                recordingsList.remove(at: i)
                break
            }
        }
    }
    
    /// Starts a timer that toggles a color every 0.3 seconds,  for a visual effect
    func blinkColor() {
        blinkingCount = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (value) in
            self.toggleColor.toggle()
        })
    }
    
    /// Converts a given number of seconds into a formatted string of "minutes:seconds"
    /// - Parameter seconds: The total number of seconds to convert
    /// - Returns: A `String` formatted as "minutes:seconds"
    func covertSecToMinAndHour(seconds: Int) -> String {
        let (_, m, s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        let sec: String = s < 10 ? "0\(s)" : "\(s)"
        return "\(m):\(sec)"
    }
    
    /// Retrieves the creation date for a given file URL
    /// - Parameter file: The URL of the file to get the creation date for
    /// - Returns: A `Date` representing the creation date of the file
    func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
}

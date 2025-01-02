//
//  WellnessData.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/2/24.
//

import Foundation

struct WellnessData : Codable {
    var wellnessMinsToday: Int
    var thisweeksWellnessMins: [Int]
    
    init(wellnessMinsToday: Int = 0, thisweeksWellnessMins: [Int] = []) {
            self.wellnessMinsToday = wellnessMinsToday
            self.thisweeksWellnessMins = thisweeksWellnessMins
        }
    
}

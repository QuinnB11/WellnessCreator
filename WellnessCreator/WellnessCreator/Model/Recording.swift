//
//  Recording.swift
//  WellnessCreator
//
//  Created by Quinn Butcher on 12/13/24.
//

import Foundation

struct Recording : Equatable, Hashable, Codable {
    
    let fileURL : URL
    let createdAt : Date
    var isPlaying : Bool
    
    
}

//
//  Item.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date?
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

//
//  Medication.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import Foundation
import SwiftData

@Model
final class Medication {
    let medId: Int?
    var name: String?
    
    var quantity: Int?
    var timeNotify: Date?
    
    init(name: String, medId: Int, quantity: Int, timeNotify: Date) {
        self.name = name
        self.medId = medId
        self.quantity = quantity
        self.timeNotify = timeNotify
    }
}

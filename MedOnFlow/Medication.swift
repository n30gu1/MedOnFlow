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
    @Attribute(.unique) let medId: String?
    let name: String?
    
    var quantity: Int?
    var timeNotify: DateComponents?
    
    init(name: String, medId: String, quantity: Int, timeNotify: DateComponents) {
        self.name = name
        self.medId = medId
        self.quantity = quantity
        self.timeNotify = timeNotify
    }
}

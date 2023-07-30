//
//  NewMedicationViewModel.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import Foundation
import Observation
import SwiftData
import FirebaseDatabase

@Observable
class NewMedicationViewModel {
    private var ref: DatabaseReference!
    var medications: [MedicationInfo] = []
    var loadingState = LoadingState.loading
    
    init() {
        self.ref = Database.database().reference()
        fetchMedications()
    }
    
    func fetchMedications() {
        self.loadingState = .loading
        self.ref.child("medications").getData { error, snapshot in
            if let error = error {
                self.loadingState = .failed(error)
            }
            print(snapshot?.value)
        }
    }
}

class MedicationInfo {
    let id: Int
    let name: String
    let cautions: [String]
    let dose: Int
    
    init(id: Int, name: String, cautions: [String], dose: Int) {
        self.id = id
        self.name = name
        self.cautions = cautions
        self.dose = dose
    }
}

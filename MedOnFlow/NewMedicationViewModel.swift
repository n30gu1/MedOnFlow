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
    var medicationsFiltered: [MedicationInfo] {
        if query.isEmpty {
            return medications
        } else {
            return medications.filter { return ($0.name.localizedStandardContains(query) || ("\($0.id)").localizedStandardContains(query)) }
        }
    }
    var loadingState = LoadingState.loading
    var query = ""
    
    init() {
        self.ref = Database.database().reference()
        Task {
            await fetchMedications()
        }
    }
    
    func fetchMedications() async {
        self.loadingState = .loading
        do {
            guard let value = ((try await self.ref.child("medications").getData()).value as? [[String : Any]]) else {
                throw NSError()
            }
            
            let result = try value.map {
                return try MedicationInfo(from: $0)
            }
            
            self.medications = result
            
            self.loadingState = .success
        } catch {
            self.loadingState = .failed(error)
        }
    }
    
    
}

class MedicationInfo: Codable {
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
    
    init(from dict: [String : Any]) throws {
        guard let id = (dict["id"] as? Int),
              let name = (dict["name"] as? String),
              let cautions = (dict["cautions"] as? [String]),
              let dose = (dict["dose"] as? Int) else {
            throw NSError()
        }
        
        self.id = id
        self.name = name
        self.cautions = cautions
        self.dose = dose
    }
}

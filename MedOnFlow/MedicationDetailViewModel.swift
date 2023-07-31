//
//  MedicationDetailViewModel.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/31/23.
//

import Foundation
import Observation
import FirebaseDatabase

@Observable
class MedicationDetailViewModel {
    private var ref: DatabaseReference!

    var loadingState: LoadingState = .loading
    var medicationInfo: MedicationInfo?
    
    init() {
        self.ref = Database.database().reference()
    }
    
    func fetchMedicationDetails(_ medication: Medication) async {
        self.loadingState = .loading
        do {
            guard let value = ((try await self.ref.child("medications/\(medication.medId!)").getData()).value as? [String : Any]) else {
                throw NSError()
            }
            
            let result = try MedicationInfo(from: value)
            
            self.medicationInfo = result
            
            self.loadingState = .success
        } catch {
            self.loadingState = .failed(error)
        }
    }
}

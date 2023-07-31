//
//  NewMedicationDetailView.swift
//  MedOnFlow
//
//  Created by Sung Park on 8/1/23.
//

import SwiftUI

struct NewMedicationDetailView: View {
    var viewModel: NewMedicationViewModel
    var medications: [Medication]
    var medicationInfo: MedicationInfo
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Form {
            Section("Medication Information") {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(medicationInfo.name)
                }
                
            }
            Section("Purchase") {
                Button {
                    if let item = medications.filter({ $0.medId == medicationInfo.id || $0.name == medicationInfo.name }).first {
                        item.quantity! += medicationInfo.dose
                        dismiss()
                    } else {
                        let newMedication = Medication(name: medicationInfo.name, medId: medicationInfo.id, quantity: medicationInfo.dose, timeNotify: Date())
                        modelContext.insert(newMedication)
                        dismiss()
                    }
                } label: {
                    Text("Purchase \(medicationInfo.name)")
                }
            }
        }
    }
}

#Preview {
    NewMedicationDetailView(viewModel: NewMedicationViewModel(), medications: [], medicationInfo: MedicationInfo(id: 0, name: "", cautions: [], dose: 10))
}

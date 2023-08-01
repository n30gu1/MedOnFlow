//
//  NewMedicationDetailView.swift
//  MedOnFlow
//
//  Created by Sung Park on 8/1/23.
//

import SwiftUI
import MapKit

struct NewMedicationDetailView: View {
    var viewModel: NewMedicationViewModel
    var medications: [Medication]
    var medicationInfo: MedicationInfo
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Form {
            Section("Medication Information") {
                HStack {
                    Text("Name")
                        .bold()
                    Spacer()
                    Text(medicationInfo.name)
                }
                HStack {
                    Text("Doses")
                        .bold()
                    Spacer()
                    Text("\(medicationInfo.dose)")
                }
            }
            Section("Cautions") {
                ForEach(medicationInfo.cautions, id: \.self) {
                    Text($0)
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
            Section("Get From Pharmacy") {
                Map {
                    Marker("Pharmacy", coordinate: CLLocationCoordinate2D(latitude: 35.913969, longitude: 128.819614))
                }
                .aspectRatio(1.0, contentMode: .fill)
            }
        }
        .navigationTitle(medicationInfo.name)
    }
}

#Preview {
    NewMedicationDetailView(viewModel: NewMedicationViewModel(), medications: [], medicationInfo: MedicationInfo(id: 0, name: "", cautions: [], dose: 10))
}

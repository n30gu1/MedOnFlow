//
//  NewMedicationView.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import SwiftUI

struct NewMedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable private var viewModel = NewMedicationViewModel()
    
    let currentMedications: [Medication]
    
    var body: some View {
        NavigationStack {
            switch viewModel.loadingState {
            case .success:
                List {
                    ForEach(viewModel.medicationsFiltered, id: \.id) { med in
                        Button {
                            if let item = currentMedications.filter({ $0.medId == med.id || $0.name == med.name }).first {
                                item.quantity! += med.dose
                                try! self.modelContext.save()
                                dismiss()
                            } else {
                                let newMedication = Medication(name: med.name, medId: med.id, quantity: med.dose, timeNotify: Date())
                                modelContext.insert(newMedication)
                                try! self.modelContext.save()
                                dismiss()
                            }
                        } label: {
                            Text(med.name)
                        }
                    }
                }
                .searchable(text: $viewModel.query)
                .navigationTitle("New Medication")
            case .loading:
                ProgressView()
                    .navigationTitle("New Medication")
            case .failed:
                Text("Failed")
            }
        }
    }
}

#Preview {
    NewMedicationView(currentMedications: [])
}

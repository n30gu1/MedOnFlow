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
                        NavigationLink(destination: NewMedicationDetailView(viewModel: self.viewModel, medications: currentMedications, medicationInfo: med, dismiss: _dismiss)) {
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

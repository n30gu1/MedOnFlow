//
//  MedicationDetailView.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import SwiftUI

struct MedicationDetailView: View {
    let medication: Medication
    @Bindable private var viewModel = MedicationDetailViewModel()
    var body: some View {
        switch viewModel.loadingState {
        case .loading:
            ProgressView()
                .navigationTitle(medication.name!)
                .onAppear {
                    Task {
                        await viewModel.fetchMedicationDetails(self.medication)
                    }
                }
        case .success:
            Form {
                Section("Name") {
                    Text(viewModel.medicationInfo!.name)
                }
                Section("Cautions") {
                    ForEach(viewModel.medicationInfo!.cautions, id: \.self) {
                        Text($0)
                    }
                }
                Section("Doses Left") {
                    Text("\(medication.quantity!)")
                    Button {
                        medication.quantity! -= 1
                    } label: {
                        Text("Had one dose")
                    }
                    if medication.quantity! < 5 {
                        Button {
                            medication.quantity! += viewModel.medicationInfo!.dose
                        } label: {
                            Text("Buy \(viewModel.medicationInfo!.dose) more doses now")
                        }
                    }
                }
            }
            .navigationTitle("\(medication.name!)")
        case .failed(let error):
            Text("\(error.localizedDescription)")
        }
    }
}

#Preview {
    MedicationDetailView(medication: Medication(name: "TestMed", medId: 0, quantity: 10, timeNotify: Date()))
}

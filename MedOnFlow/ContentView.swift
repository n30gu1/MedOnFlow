//
//  ContentView.swift
//  MedOnFlow
//
//  Created by Sung Park on 7/30/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var medications: [Medication]
    @State private var addMedicationIsPresented = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(medications) { item in
                    NavigationLink {
                        MedicationDetailView(medication: item)
                    } label: {
                        HStack {
                            Text(item.name ?? "nil")
                            Spacer()
                            Text("\(item.quantity ?? 0)")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            item.quantity! -= 1
                        } label: {
                            Label("Had", systemImage: "checkmark")
                        }
                        .tint(.blue)
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        for index in indexSet {
                            modelContext.delete(medications[index])
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        addMedicationIsPresented.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Medications")
        } detail: {
            Text("Select an item")
        }
        .sheet(isPresented: $addMedicationIsPresented, content: {
            NewMedicationView(currentMedications: self.medications)
        })
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Medication.self, inMemory: true)
        .previewDevice(.init(rawValue: "iPhone 14 Pro Max"))
}

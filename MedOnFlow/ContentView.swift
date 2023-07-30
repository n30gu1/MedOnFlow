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
//                    NavigationLink {
//                        Text("Item at \(item.timestamp ?? Date(), format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp ?? Date(), format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
                }
                .onDelete { indexSet in
                    
                }
            }
            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
                ToolbarItem {
                    Button {
                        addMedicationIsPresented.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .sheet(isPresented: $addMedicationIsPresented, content: {
            NewMedicationView()
        })
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

#Preview {
    ContentView()
        .modelContainer(for: Medication.self, inMemory: true)
}

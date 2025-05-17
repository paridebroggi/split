//
//  HistoryView.swift
//  Split
//
//  Created by p on 01/05/2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {

    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""

    let expenses: [Expense]
    
    var searchResults: [Expense] {
        if searchText.isEmpty {
            return expenses
        } else {
            return expenses.filter { $0.title.contains(searchText) || $0.payer.name.contains(searchText) }
        }
    }
    
    var body: some View {
        
        List(){
            ForEach(searchResults) { expense in
              NavigationLink(destination: ExpenseView(expense: expense)) {
                    ExpenseRowView(expense: expense)
                }
            }
            .onDelete(perform: deleteRow)
        }
        .searchable(text: $searchText, prompt: "Search")
        .navigationTitle("History")
    }
    
    private func deleteRow(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(expenses[index])
            }
        }
    }
}

#Preview {
  HistoryView(expenses: SampleData.shared.currentTeam!.expenses)
        .modelContainer(SampleData.shared.modelContainer)
}

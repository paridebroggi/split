//
//  RecentView.swift
//  Split
//
//  Created by p on 01/05/2025.
//

import SwiftUI
import SwiftData


struct RecentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var isExpanded = true
     
    let expenses: [Expense]
    let currentTeam: Team
    
    
    var body: some View {
        
        Section("Recent Expenses") {
            
            ForEach(expenses.prefix(5)) { expense in
              NavigationLink(destination: AddNewExpenseView(expense: expense, currentTeam: currentTeam)) {
                    ExpenseRowView(expense: expense)
                }
            }
            .onDelete(perform: deleteRow)
  
            NavigationLink(destination: HistoryView(expenses: expenses)){
                Text("See all")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.blue)
            }
        }
    }
    
    private func deleteRow(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(expenses[index])
            }
        }
    }
}

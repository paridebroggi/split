//
//  AddNewExpenseView.swift
//  Split
//
//  Created by p on 29/04/2025.
//

import SwiftUI
import SwiftData

struct AddNewExpenseView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  var expense: Expense?
  let currentTeam: Team
  
  let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = .current
    return formatter
  }()
  
  
  enum FocusedField: Int, CaseIterable {
    case title, amount
  }
  
  var body: some View {
    
    if expense == nil {
      NavigationView {
        ExpenseFormView(expense: expense, currentTeam: currentTeam, isDisabled: false)
          .navigationTitle("New Expense")
          .navigationBarTitleDisplayMode(.inline)
      }
    }
    else {
      ExpenseFormView(expense: expense, currentTeam: currentTeam, isDisabled: true)
        .navigationTitle("Expense Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}

//#Preview {
//  AddNewExpenseView()
//    .modelContainer(SampleData.shared.modelContainer)
//}

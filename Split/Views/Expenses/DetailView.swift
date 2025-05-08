//
//  ExpenseDetailView.swift
//  Split
//
//  Created by p on 30/04/2025.
//

import Foundation
import SwiftUI

struct ExpenseDetailView: View {

    let expense: Expense
    
    var body: some View {
        Form {
            Section(header: Text("Amount")) {
                Text("\(expense.amount, specifier: "%.2f") \(expense.currency)")
            }
            
            Section(header: Text("Title")) {
                Text(expense.title)
            }
            
            Section(header: Text("Payer")) {
                Text(expense.payer.name)
            }
            
            Section(header: Text("Date")) {
                Text(expense.date.formatted(date: .abbreviated, time: .shortened))
            }
            
            Section(header: Text("Category")) {
                Text(expense.category)
            }
            
            Section(header: Text("Splitting Rate")) {
                Text("\(Int(expense.splittingRate))%")
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

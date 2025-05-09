//
//  ExpenseRowView.swift
//  Split
//
//  Created by p on 30/04/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct ExpenseRowView: View {
    
    @Environment(\.modelContext) private var modelContext
    let expense: Expense
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(expense.title)
                    .font(.headline)
                Spacer()
              Text("\(expense.amount, specifier: "%.2f") \(expense.currency.symbol)")
                    .font(.headline)
            }
            
            HStack {
                Text(expense.date.formatted(date: .numeric, time: .omitted))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(expense.payer.name)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

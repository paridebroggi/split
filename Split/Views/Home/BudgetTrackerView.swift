//
//  BudgetTrackerView.swift
//  Split
//
//  Created by p on 01/05/2025.
//

import SwiftUI

struct BudgetTrackerView: View {
    
    var body: some View {
        
        Section() {
            ProgressView("Monthly Expenses", value: 900, total: 1000)
                .accentColor(.blue)
            
            ProgressView("Food", value: 200, total: 400)
                .accentColor(.mint)

            ProgressView("Transport", value: 12, total: 200)
                .accentColor(.pink)
                .padding(4)
        }
    }
    
}

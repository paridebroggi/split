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
  
  let currentTeam: Team
  
  @State private var showError: Bool = false
  @State private var errorMessage = String()
  @FocusState private var focusedField: FocusedField?
  @State private var currentIndex = Int(0)
  
  @State private var amount = String()
  @State private var title = String()
  @State private var payer = String()
  @State private var category = String("Food")
  @State private var currency = "€"
  @State private var splittingRate: Double = 50.0
  @State private var date: Date = Date()
  
  private let currencies = ["$", "€", "£", "¥"]
  private let categories: [String] = ["Food", "Transport", "Shopping", "Entertainment", "Bills", "Travel", "Health", "Other"]
  
  enum FocusedField: Int, CaseIterable {
    case title, amount
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("What?", text: $title)
            .focused($focusedField, equals: .title)
            .keyboardType(.alphabet)
            .submitLabel(.next)
            .onSubmit {
              goToNextField(offset: 1)
            }
        }
        
        Section {
          TextField("Amount", text: $amount)
            .focused($focusedField, equals: .amount)
            .keyboardType(.decimalPad)
        }
        
        Section {
          Picker("Category", selection: $category) {
            ForEach(categories, id: \.self) { category in
              Text(category).tag(category)
            }
          }
        }
        
        Section {
          Picker("Payer", selection: $payer) {
            ForEach(currentTeam.members, id: \.self){ person in
              Text(person.name).tag(person.name)
            }
          }
        }
        
        Section {
          DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
            .datePickerStyle(.compact)
        }
        
        Section {
          Picker("Currency", selection: $currency) {
            ForEach(currencies, id: \.self){ currency in
              Text(currency).tag(currency)
            }
          }
        }
        
        Section(header: Text("Splitting rate")) {
          VStack {
            Text("\(Int(splittingRate))%")
              .font(.headline)
            Slider(value: $splittingRate, in: 0...100, step: 1)
          }
        }
      }
      .onAppear {
        if let user = currentTeam.members.first(where: {$0.isUser == true}) {
          payer = user.name
        }
        else if let member = currentTeam.members.first {
          payer = member.name
        }
        category = String("Food")
        currency = "€"
        focusedField = .title
      }
      .navigationTitle("New Expense")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(
          leading: Button("Cancel") {
              dismiss()
          },
          trailing: Button("Done") {
            saveExpense()
          }
          .font(.headline)
          .disabled(title.isEmpty || amount.isEmpty)
      )
      .alert("Error", isPresented: $showError) {
        Button("OK", role: .cancel) { }
      } message: {
        Text(errorMessage)
      }
    }
  }
}


extension AddNewExpenseView {
  
  private func goToNextField(offset: Int) {
    currentIndex = (currentIndex + offset) % FocusedField.allCases.count
    focusedField = FocusedField(rawValue: currentIndex)
  }
  
  private func saveExpense() {
    // Validate amount
    guard let amountValue = NumberFormatter().number(from: amount)?.doubleValue, amountValue > 0 else {
      errorMessage = "Please enter a valid amount"
      showError = true
      return
    }
    
    // Create and save expense
    let expense = Expense(
      team: currentTeam,
      date: date,
      amount: amountValue,
      title: title,
      person: currentTeam.members.first(where: { $0.name == payer })!,
      currency: currency,
      splittingRate: splittingRate,
      category: category
    )
    
    modelContext.insert(expense)
    dismiss()
  }
}

//#Preview {
//  AddNewExpenseView()
//    .modelContainer(SampleData.shared.modelContainer)
//}

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
  let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = .current
    return formatter
  }()
  
  @State private var showError: Bool = false
  @State private var errorMessage = String()
  @FocusState private var focusedField: FocusedField?
  @State private var currentIndex = Int(0)
  
  @State private var amount = String()
  @State private var title = String()
  @State private var payer = String()
  @State private var category = String("Food")
  @State private var currency = Locale.current.currency?.identifier ?? "EUR"
  @State private var splittingRate = String()
  @State private var date: Date = Date()
  @State private var showConversionRateField = false
  @State private var conversionRate = String(1)
  
  enum FocusedField: Int, CaseIterable {
    case title, amount, splittingRate
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
            .onSubmit {
                print("asdasdasdasdsadasdsa")
            }
        }
        
        Section {
          Picker("Payer", selection: $payer) {
            ForEach(currentTeam.members, id: \.self){ member in
              Text(member.name).tag(member.name)
            }
          }
        }
        
        Section {
          Picker("Category", selection: $category) {
            ForEach(categories, id: \.self) { category in
              Text(category).tag(category)
            }
          }
        }
        
        Section {
          TextField("Splitting rate", text: $splittingRate)
            .focused($focusedField, equals: .splittingRate)
            .keyboardType(.decimalPad)
        }
        
        Section {
          Picker("Currency", selection: $currency) {
            ForEach(Currency.getAllCurrencies()){ currency in
              Text(currency.code).tag(currency.code)
            }
          }
          .onChange(of: currency){
            showConversionRateField = currency != currentTeam.defaultCurrency.code
          }
          
          if showConversionRateField == true {
            withAnimation() {
              TextField("Convertion Rate", text: $conversionRate)
            }
          }
          
        }
        
        Section {
          DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
            .datePickerStyle(.compact)
        }
      }
      .animation(.default, value: showConversionRateField)
      .onAppear {
        if let user = currentTeam.members.first(where: {$0.isUser == true}) {
          payer = user.name
        }
        else if let member = currentTeam.members.first {
          payer = member.name
        }
        category = String("Food")
        currency = currentTeam.defaultCurrency.code
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
    guard let amountValue = NumberFormatter().number(from: amount)?.doubleValue, amountValue > 0,
          let conversionRateValue = NumberFormatter().number(from: conversionRate)?.doubleValue, conversionRateValue > 0 else {
      errorMessage = "Please enter a valid amount and conversion rate"
      showError = true
      return
    }
    
    // Create and save expense
    let expense = Expense(
      team: currentTeam,
      date: date,
      amount: amountValue,
      rate: conversionRateValue,
      title: title,
      member: currentTeam.members.first(where: { $0.name == payer })!,
      currency: Currency.retrieveCurrency(code: currency),
      splittingRate: Double(splittingRate)!,
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

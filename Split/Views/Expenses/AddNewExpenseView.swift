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
  
  @State private var showError: Bool = false
  @State private var errorMessage = String()
  @State private var currentIndex = Int(0)
  @State private var amount = String()
  @State private var title = String()
  @State private var payer = String()
  @State private var category = String("Food") // to be changed
  @State private var currency = Locale.current.currency?.identifier ?? "EUR"
  @State private var splittingRate = String()
  @State private var conversionRate = String()
  @State private var customCategory = String()
  @State private var date: Date = Date()
  @State private var showConversionRateField = false
  @FocusState private var focusedField: FocusedField?
  
  enum FocusedField: Int, CaseIterable {
    case title, amount
  }
  
  var body: some View {
    
    if expense == nil {
       
      NavigationView {
      }
      Form {
        Section {
          TextField("Description", text: $title)
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
          
          Picker("Currency", selection: $currency) {
            ForEach(Currency.list()){ currency in
              Text(currency.code).tag(currency.code)
            }
          }
          .onChange(of: currency){
            showConversionRateField = currency != currentTeam.defaultCurrency.code
          }
          
          if showConversionRateField == true {
            TextField("Convertion Rate", text: $conversionRate)
              .keyboardType(.decimalPad)
          }
          
        }
        
        Section {
          Picker("Payer", selection: $payer) {
            ForEach(currentTeam.members, id: \.self){ member in
              Text(member.name).tag(member.name)
            }
          }
          
          Picker("Category", selection: $category) {
            ForEach(categories, id: \.self) { category in
              Text(category).tag(category)
            }
          }
        }
        
        Section{
          Picker("Splitting", selection: $splittingRate) {
            let rates = ["50%", "100%", "Custom"]
            ForEach(rates, id: \.self) { rate in
              Text(rate).tag(rate)
            }
          }
          .pickerStyle(.navigationLink)
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
        splittingRate = "\(SplitApp.formatDoubleNumber(100.0 / Double(currentTeam.members.count)))%"
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
    
    let numberFormatter = NumberFormatter()
    
    guard let amountValue = numberFormatter.number(from: amount)?.doubleValue, amountValue > 0,
          let conversionRateValue = numberFormatter.number(from: conversionRate)?.doubleValue, conversionRateValue > 0 else {
      errorMessage = "Please enter a valid amount and conversion rate"
      showError = true
      return
    }
    
    if let expense = expense {
      expense.date = date
      expense.amount = amountValue
      expense.rate = conversionRateValue
      expense.title = title
      expense.payer = currentTeam.members.first(where: { $0.name == payer })!
      expense.currency = Currency.retrieve(fromCode: currency)
      expense.splittingRate = Double(splittingRate)!
      expense.category = category
    }
    else {
      let expense = Expense(
      team: currentTeam,
      date: date,
      amount: amountValue,
      rate: conversionRateValue,
      title: title,
      payer: currentTeam.members.first(where: { $0.name == payer })!,
      currency: Currency.retrieve(fromCode: currency),
      splittingRate: Double(splittingRate)!,
      category: category)
      modelContext.insert(expense)
    }
    dismiss()
  }
}

//#Preview {
//  AddNewExpenseView()
//    .modelContainer(SampleData.shared.modelContainer)
//}

//extension AddNewExpenseView {
//  
//  struct ExpenseFormView: View {
//    
//    var body: some View {
//      
//      Form {
//        Section {
//          TextField("Description", text: $title)
//            .focused($focusedField, equals: .title)
//            .keyboardType(.alphabet)
//            .submitLabel(.next)
//            .onSubmit {
//              goToNextField(offset: 1)
//            }
//        }
//        
//        Section {
//          TextField("Amount", text: $amount)
//            .focused($focusedField, equals: .amount)
//            .keyboardType(.decimalPad)
//            .onSubmit {
//              print("asdasdasdasdsadasdsa")
//            }
//          
//          Picker("Currency", selection: $currency) {
//            ForEach(Currency.list()){ currency in
//              Text(currency.code).tag(currency.code)
//            }
//          }
//          .onChange(of: currency){
//            showConversionRateField = currency != currentTeam.defaultCurrency.code
//          }
//          
//          if showConversionRateField == true {
//            TextField("Convertion Rate", text: $conversionRate)
//              .keyboardType(.decimalPad)
//          }
//          
//        }
//        
//        Section {
//          Picker("Payer", selection: $payer) {
//            ForEach(currentTeam.members, id: \.self){ member in
//              Text(member.name).tag(member.name)
//            }
//          }
//          
//          Picker("Category", selection: $category) {
//            ForEach(categories, id: \.self) { category in
//              Text(category).tag(category)
//            }
//          }
//        }
//        
//        Section{
//          Picker("Splitting", selection: $splittingRate) {
//            let rates = ["50%", "100%", "Custom"]
//            ForEach(rates, id: \.self) { rate in
//              Text(rate).tag(rate)
//            }
//          }
//          .pickerStyle(.navigationLink)
//        }
//        
//        Section {
//          DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
//            .datePickerStyle(.compact)
//        }
//      }
//    }
//    
//  }
//  
//}

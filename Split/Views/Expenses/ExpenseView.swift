//
//  ExpenseView.swift
//  Split
//
//  Created by p on 29/04/2025.
//

import SwiftUI
import SwiftData

struct ExpenseView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  var expense: Expense?
    
  var body: some View {
    
    if expense == nil {
      NavigationView {
        ExpenseFormView(expense: expense, isDisabled: false)
          .navigationTitle("New Expense")
          .navigationBarTitleDisplayMode(.inline)
      }
    }
    else {
      ExpenseFormView(expense: expense, isDisabled: true)
        .navigationTitle("Expense Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct ExpenseFormView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @Query(sort: \Team.name) private var teams: [Team]
  
  var expense: Expense?
  
  var currentTeam: Team {
    if let expense = expense {
      return expense.team!
    }
    else {
      return teams.first(where: { $0.isCurrent })!
    }
  }
  
  @State var isDisabled: Bool
  @State private var defaultSplittingRates = [100.0, 50.0]
  @State private var errorMessage = String()
  @State private var currentIndex = Int(0)
  @State private var amount = String()
  @State private var title = String()
  @State private var payer = String()
  @State private var category = String("Food") // to be changed
  @State private var currency = String()
  @State private var splittingRate = String()
  @State private var conversionRate = String()
  @State private var customCategory = String()
  @State private var date: Date = Date()
  @State private var showError = false
  @State private var formInputChanged = false
  @State private var showConversionRateField = false
  @FocusState private var focusedField: FocusedField?
  
  enum FocusedField: Int, CaseIterable {
    case title, amount
  }
  
  var body: some View {
    
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
          ForEach(defaultSplittingRates, id: \.self) { rate in
            Text("\(rate)%").tag(rate)
          }
        }
        .pickerStyle(.navigationLink)
      }
      
      Section {
        DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
          .datePickerStyle(.compact)
      }
    }
    .onChange(of: focusedField){
      formInputChanged = true
    }
    .disabled(isDisabled)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        if expense == nil {
          Button("Cancel") {
            dismiss()
          }
        }
      }
      
      ToolbarItem(placement: .navigationBarTrailing) {
        if expense == nil {
          Button("Done") {
            saveExpense()
          }
          .font(.headline)
          .disabled(title.isEmpty || amount.isEmpty)
        }
        else if formInputChanged == true {
          Button("Save") {
            saveExpense()
          }
        }
        else {
          Button("Edit") {
            isDisabled = false
            focusedField = .title
          }
        }
      }
    }
    
    .animation(.default, value: showConversionRateField)
    .onAppear {
      prefillForm()
    }
    .alert("Error", isPresented: $showError) {
      Button("OK", role: .cancel) { }
    }
    message: {
      Text(errorMessage)
    }
  }
  
}

extension ExpenseFormView {
  
  private func prefillForm() {
    if let expense = expense {
      title = expense.title
      amount = expense.amount.toString()!
      currency = expense.currency.code
      conversionRate = expense.conversionRate.toString(10)!
      payer = expense.payer.name
      category = expense.category
      splittingRate = expense.splittingRate.toString()!
      date = expense.date
    }
    else {
      focusedField = .title
      payer = currentTeam.lastPayer?.name ?? currentTeam.members.first?.name ?? ""
      conversionRate = currentTeam.defaultConversionRate.toString(10)!
      currency = currentTeam.defaultCurrency.code
      splittingRate = (100/Double(currentTeam.members.count)).toString()!
      //      guard let _ = defaultSplittingRates.first(where: {$0 == splittingRate}) else {
      //        defaultSplittingRates.append(splittingRate)
      //        return
      //      }
    }
  }
  
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
      expense.conversionRate = conversionRateValue
      expense.title = title
      expense.payer = currentTeam.members.first(where: { $0.name == payer })!
      expense.currency = Currency.retrieve(fromCode: currency)
      expense.splittingRate = splittingRate.toDouble()!
      expense.category = category
    }
    else {
      let expense = Expense(
        team: currentTeam,
        date: date,
        amount: amountValue,
        conversionRate: conversionRateValue,
        title: title,
        payer: currentTeam.members.first(where: { $0.name == payer })!,
        currency: Currency.retrieve(fromCode: currency),
        splittingRate: splittingRate.toDouble()!,
        category: category)
      currentTeam.lastPayer = expense.payer
      modelContext.insert(expense)
    }
    dismiss()
  }
}

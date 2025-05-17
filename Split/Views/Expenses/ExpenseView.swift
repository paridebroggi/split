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
  
  let expense: Expense?
  
  var body: some View {
    
    if expense == nil {
      NavigationView {
        ExpenseFormView(expense: nil)
          .navigationTitle("New Expense")
          .navigationBarTitleDisplayMode(.inline)
      }
    }
    else {
      ExpenseFormView(expense: expense)
        .navigationTitle("Expense Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct ExpenseFormView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @Query(sort: \Team.name) private var teams: [Team]
  
  let expense: Expense
  let isNewExpenseCreation: Bool
  @State private var isFormDisabled: Bool
  
  init(expense: Expense?) {
    if let expense = expense {
      self.expense = expense
      isNewExpenseCreation = false
    }
    else {
      self.expense = Expense()
      isNewExpenseCreation = true
    }
    isFormDisabled = !isNewExpenseCreation
  }
  
  var currentTeam: Team {
    if isNewExpenseCreation == false {
      return expense.team!
    }
    else {
      return teams.first(where: { $0.isCurrent })!
    }
  }
  
  @State private var defaultSplittingRates = [Double(100)]
  @State private var currentIndex = Int(0)
  @State private var amount = String()
  @State private var title = String()
  @State private var payer = String()
  @State private var category = String("Food") // to be changed
  @State private var currency = String()
  @State private var splittingRate = String()
  @State private var conversionRate = String()
  @State private var customCategory = String()
  @State private var date = Date()
  @State private var errorMessage = String()
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
            Text("\(rate.toString()!)%").tag(rate.toString()!)
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
    .disabled(isFormDisabled)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        if isNewExpenseCreation == true {
          Button("Cancel") {
            dismiss()
          }
        }
      }
      
      ToolbarItem(placement: .navigationBarTrailing) {
        if isNewExpenseCreation == true {
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
            isFormDisabled = false
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
    if isNewExpenseCreation == true {
      payer = currentTeam.lastPayer?.name ?? currentTeam.members.first!.name
      currency = currentTeam.defaultCurrency.code
      conversionRate = currentTeam.defaultConversionRate.toString(10)!
      let splittingRateValue = Double(100)/Double(currentTeam.members.count)
      if defaultSplittingRates.contains(splittingRateValue) == false {
        defaultSplittingRates.append(splittingRateValue)
      }
      splittingRate = splittingRateValue.toString()!
      focusedField = .title
    }
    else {
      title = expense.title
      amount = expense.amount.toString()!
      currency = expense.currency.code
      conversionRate = expense.conversionRate.toString(10)!
      payer = expense.payer.name
      category = expense.category
      splittingRate = expense.splittingRate.toString()!
      if defaultSplittingRates.contains(expense.splittingRate) == false {
        defaultSplittingRates.append(expense.splittingRate)
      }
      date = expense.date
    }
  }
  
  private func goToNextField(offset: Int) {
    currentIndex = (currentIndex + offset) % FocusedField.allCases.count
    focusedField = FocusedField(rawValue: currentIndex)
  }
  
  private func saveExpense() {
    let numberFormatter = NumberFormatter()
    guard let amountValue = numberFormatter.number(from: amount)?.doubleValue, amountValue > 0 else {
      errorMessage = "Please enter a valid amount"
      showError = true
      return
    }
    guard let conversionRateValue = conversionRate.toDouble(), conversionRateValue > 0 else {
      errorMessage = "Please enter a valid conversion rate"
      showError = true
      return
    }
    expense.team = currentTeam
    expense.date = date
    expense.amount = amountValue
    expense.conversionRate = conversionRateValue
    expense.title = title
    expense.payer = currentTeam.members.first(where: { $0.name == payer })!
    expense.currency = Currency.retrieve(fromCode: currency)
    expense.splittingRate = splittingRate.toDouble()!
    expense.category = category
    currentTeam.lastPayer = expense.payer
    modelContext.insert(expense)
    dismiss()
  }
}

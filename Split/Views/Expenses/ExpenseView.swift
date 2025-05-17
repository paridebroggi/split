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
  @Query(sort: \Team.name) private var teams: [Team]
  
  let expense: Expense?
  
  var body: some View {
    
    if let currentTeam = teams.first(where: { $0.isCurrent }) {
      if expense == nil {
        NavigationView {
          ExpenseFormView(expense: nil, currentTeam: currentTeam)
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
        }
      }
      else {
        ExpenseFormView(expense: expense, currentTeam: currentTeam)
          .navigationTitle("Expense Detail")
          .navigationBarTitleDisplayMode(.inline)
      }
    }
  }
}

struct ExpenseFormView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  let expense: Expense
  let currentTeam: Team
  let isNewExpenseCreation: Bool
  private var defaultSplittingRates: [Double]
  @State private var isFormDisabled: Bool
  
  init(expense: Expense?, currentTeam: Team) {
    self.currentTeam = currentTeam
    self.defaultSplittingRates = [Double(100), Double(100)/Double(currentTeam.members.count)]
    var splittingRateValue: Double
    if let expense = expense {
      self.expense = expense
      isNewExpenseCreation = false
      _title = State(initialValue: expense.title)
      _amount = State(initialValue: expense.amount.toString()!)
      _currency = State(initialValue: expense.currency.code)
      _exchangeRate = State(initialValue: expense.exchangeRate.toString(minFractionDigits: 6, maxFractionDigits: 6)!)
      _payer = State(initialValue: expense.payer.name)
      _category = State(initialValue: expense.category)
      _date = State(initialValue: expense.date)
      splittingRateValue = expense.splittingRate
    }
    else {
      self.expense = Expense()
      isNewExpenseCreation = true
      _payer = State(initialValue: currentTeam.lastPayer?.name ?? currentTeam.members.first!.name)
      _currency = State(initialValue: currentTeam.defaultCurrency.code)
      _exchangeRate = State(initialValue: currentTeam.defaultExchangeRate.toString(minFractionDigits: 6, maxFractionDigits: 6)!)
      splittingRateValue = Double(100)/Double(currentTeam.members.count)
    }
    self._isFormDisabled = State(initialValue: !isNewExpenseCreation)
    self._splittingRate = State(initialValue: splittingRateValue.toString()!)
    self._showExchangeRateField = State(initialValue: currency != currentTeam.defaultCurrency.code)
    if defaultSplittingRates.contains(splittingRateValue) == false {
      defaultSplittingRates.append(splittingRateValue)
    }
  }
  
  @State private var currentIndex = Int(0)
  @State private var amount = String()
  @State private var title = String()
  @State private var payer = String()
  @State private var category = String("Food") // to be changed
  @State private var currency = String()
  @State private var splittingRate = String()
  @State private var exchangeRate = String()
  @State private var customCategory = String()
  @State private var date = Date()
  @State private var errorMessage = String()
  @State private var showError = false
  @State private var formInputChanged = false
  @State private var showExchangeRateField = false
  @FocusState private var focusedField: FocusedField?
  
  enum FocusedField: Int, CaseIterable {
    case title, amount, exchangeRate
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
            Text("\(currency.name) (\(currency.code))").tag(currency.code)
          }
        }
        .onChange(of: currency){
          showExchangeRateField = currency != currentTeam.defaultCurrency.code
          if currency == currentTeam.defaultCurrency.code {
            expense.exchangeRate = Double(1)
            exchangeRate = expense.exchangeRate.toString(minFractionDigits: 6, maxFractionDigits: 6)!
          }
          else {
            expense.exchangeRate = Double(0)
            exchangeRate = String()
            focusedField = .exchangeRate
          }
        }
        
        if showExchangeRateField == true {
          HStack{
            Text("Rate \(Currency.retrieve(fromCode: currentTeam.defaultCurrency.code).code)/\(currency)")
            Spacer()
            TextField(expense.exchangeRate.toString(minFractionDigits: 6, maxFractionDigits: 6)!, text: $exchangeRate)
              .keyboardType(.decimalPad)
              .multilineTextAlignment(.trailing)
              .foregroundStyle(isFormDisabled ? Color.secondary.opacity(0.5) : Color.secondary)
              .focused($focusedField, equals: .exchangeRate)
          }
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
        if isFormDisabled == false {
          Button("Done") {
            saveExpense()
          }
          .font(.headline)
          .disabled(title.isEmpty || amount.isEmpty)
        }
        else {
          Button("Edit") {
            isFormDisabled = false
            focusedField = .title
          }
        }
      }
    }
    
    .animation(.default, value: showExchangeRateField)
    .onAppear {
      focusedField = .title
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
  
  private func goToNextField(offset: Int) {
    currentIndex = (currentIndex + offset) % FocusedField.allCases.count
    focusedField = FocusedField(rawValue: currentIndex)
  }
  
  private func saveExpense() {
    guard let amountValue = amount.toDouble(), amountValue > 0 else {
      errorMessage = "Please enter a valid amount"
      showError = true
      return
    }
    
    guard let exchangeRateValue = exchangeRate.toDouble(), exchangeRateValue > 0 else {
      errorMessage = "Please enter a valid conversion rate"
      showError = true
      return
    }
    expense.title = title
    expense.amount = amountValue
    expense.currency = Currency.retrieve(fromCode: currency)
    expense.exchangeRate = exchangeRateValue
    expense.team = currentTeam
    expense.payer = currentTeam.members.first(where: { $0.name == payer })!
    expense.category = category
    expense.splittingRate = splittingRate.toDouble()!
    expense.date = date
    currentTeam.lastPayer = expense.payer
    modelContext.insert(expense)
    dismiss()
  }
}

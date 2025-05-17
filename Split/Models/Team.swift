//
//  Team.swift
//  Split
//
//  Created by p on 30/04/2025.
//
import Foundation
import SwiftData

@Model
final class Team {
  var id = UUID()
  var name = String("Sample Group")
  var isCurrent = false
  var members = [Member]()
  var lastPayer: Member?
  
  @Relationship(deleteRule: .cascade, inverse: \Expense.team)
  var expenses = [Expense]()
  
  var sharingCode = String("SHA-0123")
  var coverImage = String()
  var defaultCurrency = Currency.retrieve(fromCode: Locale.current.currency?.identifier ?? "EUR")
  var defaultExchangeRate = Double(1)
  var defaultSplittingRate: [Double] = [100]
  
  var count: Int {
    return members.count
  }
  
  init(name: String, isCurrent: Bool, members: [Member], expenses: [Expense], sharingCode: String, coverImage: String, defaultCurrency: Currency) {
    self.name = name
    self.isCurrent = isCurrent
    self.members = members
    self.expenses = expenses
    self.sharingCode = sharingCode
    self.coverImage = coverImage
    self.defaultCurrency = defaultCurrency
  }
  
  init() {
    
  }
  
}

//
//  Expense.swift
//  Split
//
//  Created by p on 27/04/2025.
//

import Foundation
import SwiftData

@Model
final class Expense {
  
  var id = UUID()
  var title = String()
  var amount = Double.zero
  var currency = Currency()
  var conversionRate = Double(1)
  var team: Team?
  var payer = Member()
  var category = String()
  var splittingRate = Double.zero
  var date = Date()
  
  init(team: Team, date: Date, amount: Double, conversionRate: Double, title: String, payer: Member, currency: Currency, splittingRate: Double, category: String) {
    self.team = team
    self.date = date
    self.amount = amount
    self.conversionRate = conversionRate
    self.title = title
    self.payer = payer
    self.currency = currency
    self.splittingRate = splittingRate
    self.category = category
  }
  
  init() {}
  
}

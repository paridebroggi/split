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
  
  var team: Team?
  var id = UUID()
  var date = Date()
  var amount = Double.zero
  var title = String()
  var payer = Member()
  var currency = Currency()
  var conversionRate = Double.zero
  var splittingRate = Double.zero
  var category = String()
  
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

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
    var date: Date
    var amount: Double
    var title: String
    var payer: Person
    var currency: String
    var splittingRate: Double
    var category: String
    
    init(team: Team, date: Date, amount: Double, title: String, person: Person, currency: String, splittingRate: Double, category: String) {
        self.team = team
        self.date = date
        self.amount = amount
        self.title = title
        self.payer = person
        self.currency = currency
        self.splittingRate = splittingRate
        self.category = category
    }
    
}

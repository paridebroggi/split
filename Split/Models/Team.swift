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
    @Relationship(deleteRule: .cascade, inverse: \Expense.team) var expenses = [Expense]()
    var sharingCode = String("SHA-0123")
    var coverImage = String()
    var defaultCurrency = String()
    
    var count: Int {
        return members.count
    }

    init(name: String, isCurrent: Bool, members: [Member], expenses: [Expense], sharingCode: String, coverImage: String, defaultCurrency: String) {
        self.name = name
        self.isCurrent = isCurrent
        self.members = members
        self.expenses = expenses
        self.sharingCode = sharingCode
        self.coverImage = coverImage
        self.defaultCurrency = defaultCurrency
    }
    
    init(){
        
    }
    
}

//
//  SampleData.swift
//  Split
//
//  Created by p on 01/05/2025.
//

import Foundation
import SwiftData

@MainActor
final class SampleData {
  
  static let shared = SampleData()
  
  var teams: [Team]?
  var currentTeam: Team?
  
  let modelContainer: ModelContainer
  
  
  var context: ModelContext {
    modelContainer.mainContext
  }
  
  private init() {
    let schema = Schema([
      Team.self,
      Expense.self,
      Member.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    
    
    do {
      modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
      insertSampleData()
    }
    catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }
  
  private func format(string: String) -> Date {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate] // Added format options
    let date = dateFormatter.date(from: string) ?? Date.now
    return date
  }
  
  
  private func insertSampleData() {
    let mimmo = Member(name: "Mimmo", isUser: true, profileImage: String(), balance: 34.5)
    let jane = Member(name: "Jane", isUser: false, profileImage: String(), balance: -34.5)
    
    
    let teamCuccia = Team(name: "Animals", isCurrent: true, members: [mimmo,jane], expenses: [], sharingCode: "code", coverImage: String( "https://www.purina.it/sites/default/files/styles/ttt_image_original/public/2021-11/cane-e-gatto-una-convivenza-felice.webp?itok=_NoVS8I7"), defaultCurrency: Currency(code: "EUR", name: "Euro", symbol: "€"))
    
    
    let expense1 = Expense(team: teamCuccia, date: format(string:"2024-05-01"), amount: 23.4, rate: Double(1), title: "Lunch", member: jane , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "food")
    let expense2 = Expense(team: teamCuccia, date: format(string:"2024-05-02"), amount: 223.1, rate: Double(1), title: "Dinner", member: mimmo , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "food")
    let expense3 = Expense(team: teamCuccia, date: format(string:"2024-05-03"), amount: 12.00, rate: Double(1), title: "Uber", member: jane , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "Transport")
    let expense4 = Expense(team: teamCuccia, date: format(string:"2024-05-04"), amount: 35.44, rate: Double(1), title: "Cinema", member: mimmo , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "Entertainent")
    let expense5 = Expense(team: teamCuccia, date: format(string:"2024-05-05"), amount: 135.4, rate: Double(1), title: "Dress", member: jane , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "Shopping")
    let expense6 = Expense(team: teamCuccia, date: format(string:"2024-05-06"), amount: 53.44, rate: Double(1), title: "Theatre", member: mimmo , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "Entertainent")
    teamCuccia.expenses = [expense1, expense2, expense3, expense4, expense5, expense6]
    
    let mimmo2 = Member(name: "Mimmo", isUser: true, profileImage: String(), balance: 64.0)
    let giorgio = Member(name: "Giorgio", isUser: false, profileImage: String(), balance: -44.0)
    let laura = Member(name: "Laura", isUser: false, profileImage: String(), balance: -20.0)
    
    let teamMare = Team(name: "Vacations", isCurrent: false, members: [mimmo2, giorgio, laura], expenses: [], sharingCode: "code", coverImage: String("https://www.reisroutes.be/userfiles/fotos/eze-sur-mer-dagje-genieten-op-het-strand_21614_xl.jpg"), defaultCurrency: Currency(code: "EUR", name: "Euro", symbol: "€"))
    let expense1a = Expense(team: teamMare, date: format(string:"2025-04-10"), amount: 23.4, rate: Double(1), title: "Breakfast", member: mimmo2 , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "food")
    let expense2a = Expense(team: teamMare, date: format(string:"2025-04-11"), amount: 223.1, rate: Double(1), title: "Drink", member: laura , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "food")
    let expense3a = Expense(team: teamMare, date: format(string:"2025-04-12"), amount: 12.00, rate: Double(1), title: "Taxi", member: mimmo2 , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "Transport")
    let expense4a = Expense(team: teamMare, date: format(string:"2025-04-13"), amount: 35.44, rate: Double(1), title: "Tennis", member: giorgio , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "Entertainent")
    teamMare.expenses = [expense1a, expense2a, expense3a, expense4a]
    
    
    let mimmo3 = Member(name: "Mimmo", isUser: true, profileImage: String(), balance: 123.0)
    let raffaele = Member(name: "Raffaele", isUser: false, profileImage: String(), balance: -23.0)
    let ludovica = Member(name: "Ludovica", isUser: false, profileImage: String(), balance: -100.0)
    
    let teamMontagna = Team(name: "Mountains", isCurrent: false, members: [mimmo3, raffaele, ludovica], expenses: [], sharingCode: "code", coverImage: String( "https://www.benesserehotels.com/images/guide/montagna%5B1%5D_dwn.JPG"), defaultCurrency: Currency(code: "EUR", name: "Euro", symbol: "€"))
    let expense1b = Expense(team: teamMontagna, date: format(string:"2025-03-10"), amount: 43.4, rate: Double(1), title: "Spaghetti", member: mimmo3 , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "food")
    let expense2b = Expense(team: teamMontagna, date: format(string:"2025-03-09"), amount: 23.1, rate: Double(1), title: "Colazione", member: raffaele , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "food")
    let expense3b = Expense(team: teamMontagna, date: format(string:"2025-03-08"), amount: 132.00, rate: Double(1), title: "Traghetto", member: ludovica , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "Transport")
    let expense4b = Expense(team: teamMontagna, date: format(string:"2025-03-07"), amount: 135.44, rate: Double(1), title: "Circo", member: mimmo3 , currency: teamCuccia.defaultCurrency, splittingRate: 50, category: "Entertainent")
    teamMontagna.expenses = [expense1b, expense2b, expense3b, expense4b]
    
    teams = [teamCuccia, teamMare, teamMontagna]
    currentTeam = teamMontagna
  }
  
}

//
//  SplitApp.swift
//  Split
//
//  Created by p on 06/05/2025.
//

import SwiftUI
import SwiftData

@main
struct SplitApp: App {
  
  var body: some Scene {
    WindowGroup {
      ContentView()      
    }
    .modelContainer(for: [
      Team.self,
      Expense.self,
      Member.self
    ])
  }
}

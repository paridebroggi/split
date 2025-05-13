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
        .onAppear(){
          print(String("33,33").toDouble()!)
          print(Double(3.03).toString()!)
        }
    }
    .modelContainer(for: [
      Team.self,
      Expense.self,
      Member.self
    ])
  }
}

//
//  TeamDetailView.swift
//  Split
//
//  Created by p on 04/05/2025.
//

import SwiftUI

struct TeamDetailView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  let team: Team
  
  @State private var name = ""
  @State private var defaultCurrency = "€"
  @State private var showError = false
  @State private var errorMessage = ""
  
  private let currencies = ["$", "€", "£", "¥"]
  
  var body: some View {
    
    Form {
      
      HeaderView(team: team)
      
      Section(){
        TextField("Name", text: $name)
      }
      
      Section("Members"){
        ForEach(team.members) { person in
          Text(person.name)
        }
        Button {
          print("add memebrs")
        } label: {
          HStack{
            Image(systemName: "plus.circle.fill")
            Text("Add Member")
          }
        }
      }
      
      Section(header: Text("Settings")) {
        HStack {
          TextField("Currency", text: $defaultCurrency)
          Menu() {
            ForEach(currencies, id: \.self) { currency in
              Button(currency) { defaultCurrency = currency }
            }
          }
          label: {
            Label("", systemImage: "chevron.up.chevron.down")
              .font(.caption)
          }
        }
      }
      Section(header: Text("Sharing Code"), footer: Text("Share this code with other members to join your group.")){
        Text("XEVJ2093")
      }
    }
    .navigationTitle("Details")
    .navigationBarTitleDisplayMode(.inline)
  }
}

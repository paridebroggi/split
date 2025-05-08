//
//  AddNewTeamView.swift
//  Split
//
//  Created by p on 04/05/2025.
//

import SwiftUI
import SwiftData

struct AddNewTeamView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  @State private var teamName = String()
  @State private var defaultCurrency = "€"
  @State private var showError = false
  @State private var errorMessage = ""
  @State private var currency = "€"
  @State private var presentNewPersonView = false
  @State private var presentImagePicker = false
  @State private var isShareEnabled = false
  @FocusState private var focusedField: FocusedField?
  
  enum FocusedField: Int, CaseIterable {
    case teamName
  }
  
  private let currencies = ["$", "€", "£", "¥"]
  
  let teams: [Team]
  let team = Team()
  
  var body: some View {
    
    NavigationView(){
      Form {
        Section(header: Text("Name")){
          TextField("Family, Holidays, Friends...", text: $teamName)
            .focused($focusedField, equals: .teamName)
        }
        Section(header: Text("Image"), footer: Text("Add an image to make the group easier to recognize.")) {
          ImageViewWithPicker(team: team)
            .listRowInsets(EdgeInsets())
        }
        
        Section("Members"){
          ForEach(team.members) { person in
            Text(person.name)
          }
          Button {
            presentNewPersonView = true
          } label: {
            HStack{
              Image(systemName: "plus.circle.fill")
              Text("Add Member")
            }
          }
        }
        
        Section(header: Text("Defaults")) {
          Section {
            Picker("Default Currency", selection: $currency) {
              ForEach(currencies, id: \.self){ currency in
                Text(currency).tag(currency)
              }
            }
          }
        }
        
        Section(header: Text("Sharing"), footer: Text("Share this code with other members to join your group.")){
          Toggle("Share with other memebrs", isOn: $isShareEnabled)
          Text("XEVJ2093").foregroundStyle(.secondary)
        }
      }
      .onAppear() {
        focusedField = .teamName
      }
      .navigationTitle("Group Details")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(
        leading: Button("Cancel") {
          dismiss()
        },
        trailing: Button("Done") {
          saveTeam()
          dismiss()
        }
          .font(.headline)
          .disabled(teamName.isEmpty || team.members.isEmpty)
      )
      .sheet(isPresented: $presentNewPersonView) {
        AddNewPersonView(team: team)
      }
    }
  }
}

extension AddNewTeamView {
   
  private func saveTeam() {
    team.name = teamName
    team.defaultCurrency = currency
    team.isCurrent = teams.isEmpty
    modelContext.insert(team)
  }
  
}

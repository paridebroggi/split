//
//  TeamView.swift
//  Split
//
//  Created by p on 04/05/2025.
//

import SwiftUI
import SwiftData

struct TeamView: View {
  
  let team: Team?
  
  var body: some View {
    
    if let team = team {
        TeamFormView(team: team)
        .navigationTitle("Group Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    else {
      NavigationView(){
        TeamFormView(team: nil)
          .navigationTitle("New Group")
          .navigationBarTitleDisplayMode(.inline)
      }
    }
  }
}

struct TeamFormView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @Query(sort: \Team.name) private var teams: [Team]
  
  @State private var teamName: String
  @State private var currency: String
  @State private var isBudgetingEnabled: Bool
  @State private var presentNewMemberView = false
  @State private var presentImagePicker = false
  @State private var isSharingEnabled = false
  @State private var showError = false
  @State private var errorMessage = String()
  @State private var isFormDisabled = true
  @State private var formInputChanged = false
  @FocusState private var focusedField: FocusedField?
  
  enum FocusedField: Int, CaseIterable {
    case teamName
  }
  
  let team: Team
  let isNewTeamCreation: Bool
  
  init(team: Team?) {
    if let team = team {
      isNewTeamCreation = false
      self.team = team
      self._teamName = State(initialValue: team.name)
      self._currency = State(initialValue: team.defaultCurrency.code)
      self._isBudgetingEnabled = State(initialValue: team.isBudgetingEnabled)
    }
    else {
      isNewTeamCreation = true
      self.team = Team()
      self._teamName = State(initialValue: self.team.name)
      self._currency = State(initialValue: self.team.defaultCurrency.code)
      self._isBudgetingEnabled = State(initialValue: self.team.isBudgetingEnabled)
    }
    self._isFormDisabled = State(initialValue: !isNewTeamCreation)
  }

  var body: some View {
    
      Form {
        Section(header: Text("Name")){
          TextField("Family, Holidays, Friends...", text: $teamName)
            .focused($focusedField, equals: .teamName)
        }
        Section(header: Text("Image"), footer: Text("Add a picture that represents the expense group.")) {
          ImageViewWithPicker(team: team)
            .listRowInsets(EdgeInsets())
        }
        
        Section("Members"){
          ForEach(team.members) { member in
            Text(member.name)
          }
          Button {
            presentNewMemberView = true
          } label: {
            HStack{
              Image(systemName: "plus.circle.fill")
              Text("Add Member")
            }
          }
        }
        
        Section(header: Text("Settings")) {
          Picker("Currency", selection: $currency) {
            ForEach(Currency.list()){ currency in
              Text("\(currency.name) (\(currency.code))").tag(currency.code)
            }
          }
          Toggle("Budgeting", isOn: $isBudgetingEnabled)
        }
        
        Section(header: Text("Sharing"), footer: isSharingEnabled == true ? Text("Share this code to let other people join the group.") : nil){
          Toggle("Share expense group", isOn: $isSharingEnabled)
          if isSharingEnabled == true {
            HStack {
              Spacer()
              Button("XEVJ2093") {
                print("share button tapped")
              }
              Spacer()
            }
          }
        }
      }
      .animation(.default, value: isSharingEnabled)
      .onAppear() {
        focusedField = .teamName
      }
      .disabled(isFormDisabled)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          if isNewTeamCreation == true {
            Button("Cancel") {
              dismiss()
            }
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          if isFormDisabled == false {
            Button("Done") {
              saveTeam()
            }
            .font(.headline)
            .disabled(teamName.isEmpty)
          }
          else {
            Button("Edit") {
              isFormDisabled = false
              focusedField = .teamName
            }
          }
        }
      }
      .sheet(isPresented: $presentNewMemberView) {
        AddNewMemberView(team: team)
      }
      .alert("Error", isPresented: $showError) {
        Button("OK", role: .cancel) { }
      }
      message: {
        Text(errorMessage)
      }
    
    
    
  }
}

extension TeamFormView {
   
  private func saveTeam() {
    
    guard teamName.isEmpty == false else {
      errorMessage = "Please enter a valid name"
      showError = true
      return
    }
    guard team.count > 0 else {
      errorMessage = "Please add at least one member"
      showError = true
      return
    }
    team.name = teamName
    team.defaultCurrency = Currency.retrieve(fromCode: currency)
    team.isCurrent = teams.isEmpty
    team.isBudgetingEnabled = isBudgetingEnabled
    modelContext.insert(team)
    dismiss()
  }
  
}




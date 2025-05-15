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
  @State private var currency = Locale.current.currency?.identifier ?? "EUR"
  @State private var conversionRate = String(1)
  @State private var showConversionRateField = false
  @State private var presentNewMemberView = false
  @State private var presentImagePicker = false
  @State private var isSharingEnabled = false
  @State private var showError = false
  @State private var errorMessage = ""
  @State private var isBudgetingEnabled = false
  @FocusState private var focusedField: FocusedField?
  
  enum FocusedField: Int, CaseIterable {
    case teamName
  }
  
  let teams: [Team]
  let team = Team()
  
  var body: some View {
    
    NavigationView(){
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
                Text(currency.code).tag(currency.code)
              }
            }
            .onChange(of: currency){
              showConversionRateField = currency != team.defaultCurrency.code
            }
            
            if showConversionRateField == true {
              TextField("Convertion Rate", text: $conversionRate)
                .keyboardType(.decimalPad)
            }
          
            Toggle("Enable budgeting", isOn: $isBudgetingEnabled)
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
      .navigationTitle("Expense Group Details")
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
      .sheet(isPresented: $presentNewMemberView) {
        AddNewMemberView(team: team)
      }
    }
  }
}

extension AddNewTeamView {
   
  private func saveTeam() {
    team.name = teamName
    team.defaultCurrency = Currency.retrieve(fromCode: currency)
    team.defaultConversionRate = conversionRate.toDouble()!
    team.isCurrent = teams.isEmpty
    modelContext.insert(team)
  }
  
}

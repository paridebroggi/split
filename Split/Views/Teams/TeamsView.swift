//
//  TeamsView.swift
//  Split
//
//  Created by p on 03/05/2025.
//

import SwiftUI
import SwiftData

struct TeamsView: View {
  
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  
  @State private var presentNewTeamView = false
  @State private var selectedTeam = String()
  
  let teams: [Team]
  
  var body: some View {
    if teams.isEmpty {
      TeamView(team: nil)
    }
    else {
      NavigationView {
        List {
          Section("Current"){
            ForEach(teams) { team in
              if team.isCurrent == true {
                NavigationLink(destination: TeamView(team: team)) {
                  TeamRowView(team: team)
                }
              }
            }
          }
          if teams.count > 1 {
            Section("Other groups"){
              ForEach(teams) { team in
                if team.isCurrent == false {
                  NavigationLink(destination: TeamView(team: team)) {
                    TeamRowView(team: team)
                  }
                }
              }
            }
          }
        }
        .navigationTitle("Expense Groups")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .confirmationAction) {
            Button("Done") {
              dismiss()
            }
          }
          ToolbarItem(placement: .bottomBar) {
            Button {
              presentNewTeamView = true
            } label: {
              HStack{
                Image(systemName: "plus.circle.fill").foregroundStyle(.blue)
                Text("Create new group")
                  .foregroundStyle(.blue)
              }
            }
          }
        }
      }
      .sheet(isPresented: $presentNewTeamView) {
        TeamView(team: nil)
      }
    }
  }
}

//#Preview {
//    TeamsView()
//        .modelContainer(SampleData.shared.modelContainer)
//}

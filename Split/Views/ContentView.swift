//
//  ContentView.swift
//  Split
//
//  Created by p on 27/04/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  
  @Environment(\.modelContext) private var modelContext
  @State private var presentAddNewExpenseView = false
  @State private var presentAddNewTeamView = false
  @State private var presentTeamsView = false
  @State private var presentProfileView = false
  
  var user: Member?
  
  @Query(sort: \Team.name) private var teams: [Team]
  
  var currentTeam: Team? {
    return teams.first(where: { $0.isCurrent })
  }
  
  var body: some View {
    NavigationView {
      ZStack{
        Text("Pleasse add an expense group first")
          .padding(24)
        List() {
          if let currentTeam = currentTeam {
            HeaderView(team: currentTeam)
            TeamView(team: currentTeam)
            RecentView(expenses: currentTeam.expenses.sorted(by: { $0.date > $1.date }))
          }
        }
        .listStyle(.sidebar)
        .navigationTitle(currentTeam?.name ?? "Split")
        .navigationBarTitleDisplayMode(.inline)
      }
      .toolbar {
        if teams.count > 1 {
          ToolbarTitleMenu {
            ForEach(teams){ team in
              Button(team.name) {
                currentTeam!.isCurrent.toggle()
                teams.first(where: { $0.name == team.name })!.isCurrent.toggle()
              }
            }
          }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          Menu() {
            Button {
              print("Analytics")
              modelContext.insert(SampleData.shared.teams![0])
              modelContext.insert(SampleData.shared.teams![1])
              modelContext.insert(SampleData.shared.teams![2])
            } label: {
              Label("Analytics", systemImage: "chart.bar.xaxis")
            }
            Button {
              print("Tapped Export")
            } label: {
              Label("Export", systemImage: "square.and.arrow.up.on.square")
            }
          }
          label: {
            Image(systemName: "ellipsis.circle")
          }
        }
        
        ToolbarItem(placement: .topBarLeading) {
            Button {
              print("Tapped Profil")
            } label: {
              Label("Profile", systemImage: "person.crop.circle")
            }
        }
        
        ToolbarItem(placement: .bottomBar) {
          Button {
            presentTeamsView = true
          } label: {
            Image(systemName: "person.2")
          }
        }
        
        ToolbarItem(placement: .bottomBar) {
          Button {
            presentAddNewExpenseView = true
          } label: {
            Image(systemName: "square.and.pencil")
          }
        }
      }
    }
    .onAppear {
      if user == nil {
        presentProfileView = true
      }
      if teams.isEmpty == true {
        presentAddNewTeamView = true
      }
    }
    .sheet(isPresented: $presentProfileView){
      Text("Profile View")
    }
    .sheet(isPresented: $presentTeamsView){
      TeamsView(teams: teams)
    }
    .sheet(isPresented: $presentAddNewExpenseView) {
      if let currentTeam = currentTeam {
        AddNewExpenseView(currentTeam: currentTeam)
      }
    }
    .sheet(isPresented: $presentAddNewTeamView){
      AddNewTeamView(teams: teams)
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(SampleData.shared.modelContainer)
}

//
//  HomeView.swift
//  Split
//
//  Created by p on 27/04/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
  
  @Environment(\.modelContext) private var modelContext
  @State private var presentExpenseView = false
  @State private var presentTeamView = false
  @State private var presentTeamsView = false
  
  var user: Member?
  
  @Query(sort: \Team.name) private var teams: [Team]
  
  var currentTeam: Team? {
    return teams.first(where: { $0.isCurrent })
  }
  
  var body: some View {
    NavigationView {
      ZStack{
        Text("Please add an expense group first")
          .padding(24)
        List() {
          if let currentTeam = currentTeam {
            CurrentTeamView(team: currentTeam)
//            CurrentBudgetView(team: currentTeam)
            CurrentRecentsView(expenses: currentTeam.expenses.sorted(by: { $0.date > $1.date }))
          }
        }
        .navigationTitle(currentTeam?.name ?? "Split")
        .navigationBarTitleDisplayMode(.inline)
      }
      .toolbar {
        if teams.count > 1 {
          ToolbarTitleMenu {
            ForEach(teams){ team in
              Button {
                currentTeam!.isCurrent.toggle()
                teams.first(where: { $0.name == team.name })!.isCurrent.toggle()
              } label: {
                Label(team.name, systemImage: team.isCurrent ? "checkmark" : "")
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
        
        ToolbarItem(placement: .bottomBar) {
          Button {
            presentTeamsView = true
          } label: {
            Image(systemName: "person.2")
          }
        }
        
        ToolbarItem(placement: .bottomBar) {
          Button {
            presentExpenseView = true
          } label: {
            Image(systemName: "square.and.pencil")
          }
          .disabled(teams.isEmpty)
        }
      }
    }
    .onAppear {
      if teams.isEmpty == true {
        presentTeamView = true
      }
    }
    .sheet(isPresented: $presentTeamsView){
      TeamsView(teams: teams)
    }
    .sheet(isPresented: $presentExpenseView) {
        ExpenseView()
    }
    .sheet(isPresented: $presentTeamView){
      TeamView(teams: teams, team: nil)
    }
  }
}

#Preview {
  HomeView()
    .modelContainer(SampleData.shared.modelContainer)
}

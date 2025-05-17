//
//  TeamView.swift
//  Split
//
//  Created by p on 04/05/2025.
//

import SwiftUI
import SwiftData

struct TeamView: View {
  
  let teams: [Team]
  let team: Team?
  
  var body: some View {
    
    if let team = team {
        TeamFormView(teams: teams, team: team)
        .navigationTitle("Group Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    else {
      NavigationView(){
        TeamFormView(teams: teams, team: nil)
          .navigationTitle("New Group")
          .navigationBarTitleDisplayMode(.inline)
      }
    }
  }
}


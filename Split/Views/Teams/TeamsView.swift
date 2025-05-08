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
        NavigationView {
            
            List {
                Section(){
                    ForEach(teams) { team in
                        NavigationLink(destination:TeamDetailView(team: team)) {
                            TeamRowView(team: team)
                        }
                    }
                }
            }
            .navigationTitle("Groups")
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
                            Text("Create group")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $presentNewTeamView) {
          AddNewTeamView(teams: teams)
        }
    }
}


//#Preview {
//    TeamsView()
//        .modelContainer(SampleData.shared.modelContainer)
//}

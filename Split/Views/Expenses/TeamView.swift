//
//  TeamView.swift
//  Split
//
//  Created by p on 01/05/2025.
//

import SwiftUI
import SwiftData


struct TeamView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    let team: Team
    
    var body: some View {
        
            let members = team.members.sorted(by: { $0.name < $1.name})
            
            Section() {
                ForEach(members){ person in
                    HStack() {
                        Circle()
                            .fill(.fill)
                            .frame(width: 25, height: 25)
                        Spacer().frame(width: 8)
                        Text(person.name)
                        Spacer()
                        Text(person.balance.description)
                            .foregroundStyle(person.balance >= 0 ? Color.primary : .red)
                            .font(.headline)
                    }
                }
            }
        }
    }

#Preview {
    TeamView(team: SampleData.shared.currentTeam!)
}

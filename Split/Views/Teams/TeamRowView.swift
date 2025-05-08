//
//  TeamRowView.swift
//  Split
//
//  Created by p on 04/05/2025.
//

import SwiftUI

struct TeamRowView: View {
    let team: Team
    @State private var isCurrentTeam = false
    
    var body: some View {
        HStack {
            if team.isCurrent {
                Image(systemName: "checkmark")
                    .font(.headline)
            }
            else {
                Spacer().frame(width: 20)
            }
            Spacer().frame(width: 16)
            VStack(alignment: .leading, spacing: 4) {
                Text(team.name)
                    .font(.headline)
                Text("\(team.count) members")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    TeamRowView(team: Team())
}

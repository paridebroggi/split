//
//  TeamRowView.swift
//  Split
//
//  Created by p on 04/05/2025.
//

import SwiftUI

struct TeamRowView: View {
  
    
  let team: Team

  var body: some View {
        HStack {
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

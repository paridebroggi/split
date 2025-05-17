//
//  CurrentTeamView.swift
//  Split
//
//  Created by p on 01/05/2025.
//

import SwiftUI
import SwiftData


struct CurrentTeamView: View {
  
  @Environment(\.modelContext) private var modelContext
  
  let team: Team
  
  var body: some View {
    
    let members = team.members.sorted(by: { $0.name < $1.name})
    
    Section() {
        if let imageURL = URL(string: team.coverImage) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                    
                case .success(let image):
                    image.resizable()
                    
                case .failure:
                    HStack(){
                        Spacer()
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .frame(alignment: .center)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    
                default:
                    HStack(){
                        Spacer()
                        ProgressView().frame(alignment: .center)
                        Spacer()
                    }
                }
            }
            .aspectRatio(contentMode: .fill)
            .frame(height: 120)
            .listRowInsets(EdgeInsets())
        }
    }

    Section() {
      ForEach(members){ member in
        HStack() {
          if let uiImage = UIImage(contentsOfFile: member.profileImage) {
            Image(uiImage: uiImage)
              .resizable()
              .frame(width: 25, height: 25)
              .clipShape(Circle())
          }
          else {
          Circle().fill(Color.gray).frame(width: 25, height: 25)
          }
          
          Spacer().frame(width: 8)
          Text(member.name)
          Spacer()
          Text(member.balance.description)
            .foregroundStyle(member.balance >= 0 ? Color.primary : .red)
            .font(.headline)
        }
      }
    }
  }
}

#Preview {
  CurrentTeamView(team: SampleData.shared.currentTeam!)
}

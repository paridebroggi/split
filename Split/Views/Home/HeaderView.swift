//
//  HeaderView.swift
//  Split
//
//  Created by p on 30/04/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct HeaderView: View {
    
    let team: Team
    
    var body: some View {
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
    }
}

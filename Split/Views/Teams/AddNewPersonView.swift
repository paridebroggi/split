//
//  AddNewMemberView.swift
//  Split
//
//  Created by p on 07/05/2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddNewMemberView: View {
  
  @Environment(\.modelContext) var context
  @Environment(\.dismiss) var dismiss
  
  let team: Team
  let member = Member(name: "gennaro", isUser: false, profileImage: "genny", balance: 0)
  
  @State private var name: String = String()
  @State private var pickedImage: PhotosPickerItem?
  @State private var profileImage: UIImage?
  @State private var profileImageString = String()
  @State private var presentImagePicker = false
  @State private var selectedEmoji: String?
  
  // Memoji options - 4 per row
  let memojiOptions = [
    ["😀", "😎", "🤖", "🎮"],
    ["🎨", "🎭", "🎪", "🎯"],
    ["🎲", "🎸", "🚀", "⭐️"],
    ["🌈", "🌟", "💫", "✨"]
  ]
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        // Profile Image Section
        ZStack(alignment: .bottomTrailing) {
          if let image = profileImage {
            Image(uiImage: image)
              .resizable()
              .scaledToFill()
              .frame(width: 120, height: 120)
              .clipShape(Circle())
              .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 2))
          } else if let emoji = selectedEmoji {
            Text(emoji)
              .font(.system(size: 60))
              .frame(width: 120, height: 120)
              .background(Color.gray.opacity(0.1))
              .clipShape(Circle())
          } else {
            Image(systemName: "person.circle.fill")
              .resizable()
              .frame(width: 120, height: 120)
              .foregroundColor(.gray)
          }
          
          // Delete button
          if profileImage != nil || selectedEmoji != nil {
            Button(action: {
              profileImage = nil
              selectedEmoji = nil
            }) {
              Image(systemName: "xmark.circle.fill")
                .foregroundColor(.secondary)
                .background(Color.white)
                .clipShape(Circle())
            }
            .offset(x: 5, y: 5)
          }
        }
        .onTapGesture {
          presentImagePicker = true
        }
        
        // Name TextField
        TextField("Name", text: $name)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(maxWidth: 200)
          .multilineTextAlignment(.center)
        
        // Memoji Grid
        VStack(spacing: 15) {
          ForEach(memojiOptions, id: \.self) { row in
            HStack(spacing: 20) {
              ForEach(row, id: \.self) { emoji in
                Button(action: {
                  selectedEmoji = emoji
                  profileImage = nil
                }) {
                  Text(emoji)
                    .font(.system(size: 30))
                    .frame(width: 50, height: 50)
                    .background(
                      Circle()
                        .fill(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                    )
                }
              }
            }
          }
        }
        
        Spacer()
      }
      .padding()
      .navigationBarItems(
        leading: Button("Cancel") {
          dismiss()
        },
        trailing: Button("Done") {
          saveMember()
        }
          .disabled(name.isEmpty && selectedEmoji == nil && profileImage == nil)
      )
    }
    .photosPicker(isPresented: $presentImagePicker, selection: $pickedImage, matching: .images)
    
    .onChange(of: pickedImage) {
      Task {
        if let data = try? await pickedImage?.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
          profileImage = uiImage
          profileImageString = SplitApp.saveImageToDocuments(image: uiImage)?.absoluteString ?? "sooka"
        }
      }
    }
  }
}

extension AddNewMemberView {

  
  private func saveMember() {
    member.name = name
    member.profileImage = profileImageString
    team.members.append(member)
    dismiss()
  }
}


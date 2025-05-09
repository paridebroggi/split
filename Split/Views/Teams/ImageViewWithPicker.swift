//
//  ImageViewWithPicker.swift
//  Split
//
//  Created by p on 07/05/2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ImageViewWithPicker: View {
  
  @State private var presentImagePicker = false
  @State private var pickedImage: PhotosPickerItem?
  @State private var teamImage: UIImage?
  
  let team: Team
  
  var body: some View {
    
    ZStack(){
      HStack {
        Spacer()
        Button {
          presentImagePicker = true
        }
        label: {
          Image(systemName: "photo.badge.plus")
            .font(.title)
            .frame(height: 120)
          }
        Spacer()
      }
      
      if let image = teamImage {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(height: 120)
      }
    }
    .photosPicker(isPresented: $presentImagePicker, selection: $pickedImage, matching: .images)
    
    .onChange(of: pickedImage) {
      Task {
        if let data = try? await pickedImage?.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
          teamImage = uiImage
          team.coverImage = SplitApp.saveImageToDocuments(image: uiImage)?.absoluteString ?? ""
        }
      }
    }
  }
}

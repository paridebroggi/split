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
  
  @State private var isPickerPresented = false
  @State private var pickedImage: PhotosPickerItem?
  @State private var teamImage: UIImage?
  
  let team: Team
  
  var body: some View {
    
    ZStack(){
      HStack {
        Spacer()
        Button {
          isPickerPresented = true
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
    .photosPicker(isPresented: $isPickerPresented, selection: $pickedImage, matching: .images)
    
    .onChange(of: pickedImage) {
      Task {
        if let data = try? await pickedImage?.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
          teamImage = uiImage
          team.coverImage = saveImageToDocuments(image: uiImage)?.absoluteString ?? ""
        }
      }
    }
  }
}

extension ImageViewWithPicker {
  func saveImageToDocuments(image: UIImage) -> URL? {
    guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
    
    let filename = UUID().uuidString + ".jpg"
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
    
    do {
      try data.write(to: url)
      return url
    } catch {
      print("Failed to save image:", error)
      return nil
    }
  }
}

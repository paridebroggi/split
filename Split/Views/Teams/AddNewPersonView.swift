//
//  AddNewPersonView.swift
//  Split
//
//  Created by p on 07/05/2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddNewPersonView: View {
  
  let team: Team
  
  var body: some View {
    
    Text("New person added")
      .onAppear {
        let Person = Person(name: "Pippo", isUser: false, profileImage: "", balance: 0.0)
        team.members.append(Person)
      }
  }
  
}

//    @Environment(\.modelContext) var context
//    @Environment(\.dismiss) var dismiss
//
//    let team: Team
//
//    @State private var name: String = String()
//    @State private var selectedImage: UIImage?
//    @State private var showImagePicker = false
//    @State private var selectedEmoji: String?
//
//    // Memoji options - 4 per row
//    let memojiOptions = [
//        ["😀", "😎", "🤖", "🎮"],
//        ["🎨", "🎭", "🎪", "🎯"],
//        ["🎲", "🎸", "🚀", "⭐️"],
//        ["🌈", "🌟", "💫", "✨"]
//    ]
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                // Profile Image Section
//                ZStack(alignment: .bottomTrailing) {
//                    if let image = selectedImage {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 120, height: 120)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 2))
//                    } else if let emoji = selectedEmoji {
//                        Text(emoji)
//                            .font(.system(size: 60))
//                            .frame(width: 120, height: 120)
//                            .background(Color.gray.opacity(0.1))
//                            .clipShape(Circle())
//                    } else {
//                        Image(systemName: "person.circle.fill")
//                            .resizable()
//                            .frame(width: 120, height: 120)
//                            .foregroundColor(.gray)
//                    }
//
//                    // Delete button
//                    if selectedImage != nil || selectedEmoji != nil {
//                        Button(action: {
//                            selectedImage = nil
//                            selectedEmoji = nil
//                        }) {
//                            Image(systemName: "xmark.circle.fill")
//                                .foregroundColor(.red)
//                                .background(Color.white)
//                                .clipShape(Circle())
//                        }
//                        .offset(x: 5, y: 5)
//                    }
//                }
//                .onTapGesture {
//                    showImagePicker = true
//                }
//
//                // Name TextField
//                TextField("Name", text: $name)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .frame(maxWidth: 200)
//                    .multilineTextAlignment(.center)
//
//                // Memoji Grid
//                VStack(spacing: 15) {
//                    ForEach(memojiOptions, id: \.self) { row in
//                        HStack(spacing: 20) {
//                            ForEach(row, id: \.self) { emoji in
//                                Button(action: {
//                                    selectedEmoji = emoji
//                                    selectedImage = nil
//                                }) {
//                                    Text(emoji)
//                                        .font(.system(size: 30))
//                                        .frame(width: 50, height: 50)
//                                        .background(
//                                            Circle()
//                                                .fill(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
//                                        )
//                                }
//                            }
//                        }
//                    }
//                }
//
//                Spacer()
//            }
//            .padding()
//            .navigationBarItems(
//                leading: Button("Cancel") {
//                    dismiss()
//                },
//                trailing: Button("Done") {
//                    savePerson()
//                }
//                .disabled(name.isEmpty && selectedEmoji == nil && selectedImage == nil)
//            )
//        }
//        .sheet(isPresented: $showImagePicker) {
//            ImagePicker(selectedImage: $selectedImage)
//        }
//    }
//
//    private func savePerson() {
//      let person = Person(name: name, isUser: false, profileImage: "", balance: 0)
//        // Here you would handle saving the image/emoji to your data model
//        // This is a placeholder for the actual implementation
//        team.members = [person]
//        context.insert(person)
//        dismiss()
//    }
//}
//
//// Image Picker using PHPickerViewController
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.selectionLimit = 1
//        config.filter = .images
//
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            parent.presentationMode.wrappedValue.dismiss()
//
//            guard let provider = results.first?.itemProvider else { return }
//
//            if provider.canLoadObject(ofClass: UIImage.self) {
//                provider.loadObject(ofClass: UIImage.self) { image, _ in
//                    DispatchQueue.main.async {
//                        self.parent.selectedImage = image as? UIImage
//                    }
//                }
//            }
//        }
//    }
//}

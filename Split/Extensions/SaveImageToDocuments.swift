//
//  SaveImageToDocuments.swift
//  Split
//
//  Created by p on 08/05/2025.
//

import Foundation
import SwiftUI

extension SplitApp {
  
  static func saveImageToDocuments(image: UIImage) -> URL? {
    guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
    
    let filename = UUID().uuidString + ".jpg"
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
    
    do {
      try data.write(to: url)
      return url
    }
    catch {
      print("Failed to save image:", error)
      return nil
    }
  }
}

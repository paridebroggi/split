//
//  Person.swift
//  Split
//
//  Created by p on 29/04/2025.
//

import Foundation
import SwiftData

@Model
final class Person {
  var id = UUID()
  var name = String()
  var isUser: Bool = false
  var profileImage = String()
  var balance = Double.zero
  
  init(name: String, isUser: Bool, profileImage: String, balance: Double) {
    self.name = name
    self.isUser = isUser
    self.profileImage = profileImage
    self.balance = balance
    self.profileImage = profileImage
  }
}


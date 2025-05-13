//
//  Member.swift
//  Split
//
//  Created by p on 29/04/2025.
//

import Foundation
import SwiftData

@Model
final class Member {
  var id = UUID()
  var name = String()
  var profileImage = String()
  var balance = Double.zero
  
  init(name: String, profileImage: String, balance: Double) {
    self.name = name
    self.profileImage = profileImage
    self.balance = balance
    self.profileImage = profileImage
  }
}


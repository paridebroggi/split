//
//  Currency.swift
//  Split
//
//  Created by p on 09/05/2025.
//

import Foundation
import SwiftData


struct Money: Codable, Identifiable {
  
  var id = UUID()
  var code: String
  var name: String
  var symbol: String
  
  init(code: String, name: String, symbol: String) {
    self.code = code
    self.name = name
    self.symbol = symbol
  }
  
  init() {
    self.code = "EUR"
    self.name = "Euro"
    self.symbol = "E"
  }
  
  static func getAllCurrencies() -> [Money] {
    
    let locale = Locale.current
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = locale
    var currencies = [Money]()
    
    Locale.commonISOCurrencyCodes.forEach { code in
      
      formatter.currencyCode = code
      
      if let name = locale.localizedString(forCurrencyCode: code),
         let symbol = formatter.currencySymbol {
        currencies.append(Money(code: code, name: name, symbol: symbol))
      }
    }
    return currencies
  }
  
  static func retrieveCurrency(code: String) -> Money {
    return getAllCurrencies().first(where: { $0.code == code })!
  }
}

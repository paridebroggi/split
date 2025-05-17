//
//  Currency.swift
//  Split
//
//  Created by p on 09/05/2025.
//

import Foundation
import SwiftData


struct Currency: Codable, Identifiable {
  
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
    self.symbol = "€"
  }
  
  static func list() -> [Currency] {
    
    let locale = Locale.current
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = locale
    var currencies = [Currency]()
    
    Locale.commonISOCurrencyCodes.forEach { code in
      
      formatter.currencyCode = code
      
      if let name = locale.localizedString(forCurrencyCode: code),
         let symbol = formatter.currencySymbol {
        currencies.append(Currency(code: code, name: name, symbol: symbol))
      }
    }
    return currencies.sorted(by: {$0.name < $1.name})
  }
  
  static func retrieve(fromCode: String) -> Currency {
    return list().first(where: { $0.code == fromCode }) ?? Currency(code: "EUR", name: "EUR", symbol: "€")
  }
}

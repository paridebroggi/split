//
//  Currency.swift
//  Split
//
//  Created by p on 09/05/2025.
//

import Foundation

struct Currency: Identifiable {
  
  var id: String { code }
  let code: String
  let name: String
  let symbol: String
  
  static func getAllCurrencies() -> [Currency] {
    
    let formatter = NumberFormatter()
    let locale = Locale.current
    var currencies = [Currency]()
    
    Locale.commonISOCurrencyCodes.forEach { code in
      
      formatter.numberStyle = .currency
      formatter.currencyCode = code
      formatter.locale = locale
      
      if let name = locale.localizedString(forCurrencyCode: code),
         let symbol = formatter.currencySymbol {
        currencies.append(Currency(code: code, name: name, symbol: symbol))
      }
    }
    return currencies
  }
}

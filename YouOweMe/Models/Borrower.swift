//
//  Borrower.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/13/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import Foundation

struct Borrower: Hashable {
    static func == (lhs: Borrower, rhs: Borrower) -> Bool {
      guard lhs.name == rhs.name,
        lhs.activity == rhs.activity,
        lhs.amount == lhs.amount else { return false }
      return true
    }

  var name: String
  var activity: String
  var amount: String

  init(name: String, activity: String, amount: String) {
    self.name = name
    self.activity = activity
    self.amount = amount
  }
}

extension Borrower: Codable {
  enum CodingKeys: String, CodingKey {
    case name
    case activity
    case amount
  }
}

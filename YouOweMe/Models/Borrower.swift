//
//  Borrower.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/13/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import Foundation

class Borrower {
  var name: String
  var activity: String
  var amount: String

  init(name: String, activity: String, amount: String) {
    self.name = name
    self.activity = activity
    self.amount = amount
  }
}

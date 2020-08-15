//
//  ImageRequest.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/14/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import Foundation

struct ImageRequest: Codable {
  var items: [Items]
}

struct Items: Codable {
  var link: String
}

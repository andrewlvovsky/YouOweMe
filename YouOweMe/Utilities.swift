//
//  Utilities.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/14/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import UIKit

extension UIImageView {
  func load(url: URL) {
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self?.image = image
          }
        }
      }
    }
  }
}

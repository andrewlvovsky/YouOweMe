//
//  ViewController.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/13/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    addNavBarImage()
  }

  func addNavBarImage() {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "yom_banner"))
    imageView.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
    imageView.contentMode = .scaleAspectFit

    let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 30))

    titleView.addSubview(imageView)
    titleView.backgroundColor = .clear
    self.navigationItem.titleView = titleView
  }

  
}


//
//  ViewController.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/13/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

  var borrowerArray = [Borrower]()

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

  // MARK: - Table View Functions
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return borrowerArray.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BorrowerCell", for: indexPath) as! BorrowerTableViewCell
    cell.nameLabel.text = borrowerArray[indexPath.row].name
    cell.amountLabel.text = borrowerArray[indexPath.row].amount
    return cell

  }

}

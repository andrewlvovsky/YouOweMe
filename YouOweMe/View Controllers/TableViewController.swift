//
//  ViewController.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/13/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

  var borrowers = [Borrower]()

  @IBOutlet weak var editButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    addNavBarImage()
    navigationItem.leftBarButtonItem?.title = "Edit"
  }

  func addNavBarImage() {
    let imageView: UIImageView
    if traitCollection.userInterfaceStyle == .light {
      imageView = UIImageView(image: #imageLiteral(resourceName: "yom_light"))
    } else {
      imageView = UIImageView(image: #imageLiteral(resourceName: "yom_dark"))
    }
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
    return borrowers.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BorrowerCell", for: indexPath) as! BorrowerTableViewCell
    cell.nameLabel.text = borrowers[indexPath.row].name + " owes you"
    cell.activityLabel.text = borrowers[indexPath.row].activity
    cell.amountLabel.text = borrowers[indexPath.row].amount + " for"
    if let imageURL = borrowers[indexPath.row].activityImage {
      cell.activityImage.load(url: imageURL) { _ in
        cell.spinner.stopAnimating()
      }
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }

  override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    true
  }

  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let borrowerAtSource = borrowers[sourceIndexPath.row]
    let borrowerAtDestination = borrowers[destinationIndexPath.row]

    let destinationIndex = borrowers.firstIndex(of: borrowerAtDestination)
    borrowers.removeAll(where: { $0 == borrowerAtSource})
    borrowers.insert(borrowerAtSource, at: destinationIndex!)
  }

  @IBAction func editPressed(_ sender: Any) {
    isEditing = !isEditing
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: true)
    self.editButton.title = editing ? "Done" : "Edit"
  }


}

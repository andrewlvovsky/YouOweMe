//
//  ViewController.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/13/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

  var borrowers = [BorrowerEntity]()
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var fetchedRC: NSFetchedResultsController<BorrowerEntity>!

  @IBOutlet weak var editButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    addNavBarImage()
    refresh()
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

  func refresh() {
    let request = BorrowerEntity.fetchRequest() as NSFetchRequest<BorrowerEntity>
    let sort = NSSortDescriptor(key: #keyPath(BorrowerEntity.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
    request.sortDescriptors = [sort]
    do {
      fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(BorrowerEntity.name), cacheName: nil)
      try fetchedRC.performFetch()
      if let objs = fetchedRC.fetchedObjects {
        borrowers = objs
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  @IBAction func editPressed(_ sender: Any) {
    isEditing = !isEditing
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: true)
    self.editButton.title = editing ? "Done" : "Edit"
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
    cell.nameLabel.text = borrowers[indexPath.row].name! + " owes you"
    cell.activityLabel.text = borrowers[indexPath.row].activity
    cell.amountLabel.text = borrowers[indexPath.row].amount! + " for"
    if let imageURL = URL(dataRepresentation: borrowers[indexPath.row].image!, relativeTo: nil)  {
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

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      borrowers.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade
      )
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let destination = storyboard?.instantiateViewController(identifier: "NewBorrower") as! NewBorrowerViewController
    navigationController?.pushViewController(destination, animated: true)
    destination.becomeFirstResponder()
    destination.name = borrowers[indexPath.row].name!
    destination.activity = borrowers[indexPath.row].activity!
    destination.amount = borrowers[indexPath.row].amount!
  }

}

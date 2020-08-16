//
//  NewBorrowerViewController.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/13/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import UIKit
import CoreData

class NewBorrowerViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var activityTextField: UITextField!
  @IBOutlet weak var amountTextField: CurrencyField!
  @IBOutlet weak var spinner: UIActivityIndicatorView!

  var name = String()
  var activity = String()
  var amount = String()

  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var fetchedRC: NSFetchedResultsController<BorrowerEntity>!

  var activityImageURL: URL?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    if name.isEmpty || activity.isEmpty || amount.isEmpty {
      navigationItem.title = "Add Borrower"
    } else {
      navigationItem.title = "Edit Borrower"
    }


    nameTextField.text = name
    activityTextField.text = activity
    amountTextField.text = amount

    // TODO: Give user ability to change currency region
    amountTextField.locale = Locale(identifier: "en_US")

    amountTextField.keyboardType = .numberPad

    nameTextField.autocapitalizationType = .words
    activityTextField.autocapitalizationType = .sentences

    nameTextField.returnKeyType = UIReturnKeyType.next
    activityTextField.returnKeyType = UIReturnKeyType.next

    self.nameTextField.delegate = self
    self.amountTextField.delegate = self
    self.activityTextField.delegate = self

    self.nameTextField.becomeFirstResponder()
  }

  func queryForActivityImage(completion: @escaping (Bool) -> ()) {
    let decoder = JSONDecoder()
    let editedActivityString = activityTextField.text!.replacingOccurrences(of: " ", with: "+")
    let apiCallURL = URL(string: "https://customsearch.googleapis.com/customsearch/v1?cx=014035877497483723493%3Avpcwnljllha&num=1&searchType=image&key=\(googleAPIKey)&q=\(editedActivityString)")

    URLSession.shared.dataTask(with: apiCallURL!) { (data, response, error) in

      guard let httpResponse = response as? HTTPURLResponse,
        (200..<300).contains(httpResponse.statusCode),
        let data = data else {
          completion(false)
          return
      }

      do {
        let imageRequest: ImageRequest
        imageRequest = try decoder.decode(ImageRequest.self, from: data)
        if let url = URL(string: imageRequest.items.first!.link) {
          self.activityImageURL = url
          completion(true)
        }
      } catch {
        print("Unable to decode: \(error)")
        return
      }

    }.resume()
  }

  func presentAlert(withTitle title: String, andMessage message: String) {
    let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK",
                                 style: .default) { _ in
                                  // Do nothing -- simply dismiss alert.
    }
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }

  func convertToBorrowerEntity(borrower: Borrower) -> BorrowerEntity {
    let borrowerData = BorrowerEntity(entity: BorrowerEntity.entity(), insertInto: context)
    borrowerData.name = borrower.name
    borrowerData.activity = borrower.activity
    borrowerData.amount = borrower.amount
    borrowerData.image = borrower.activityImage?.dataRepresentation

    return borrowerData
  }

  @IBAction func donePressed(_ sender: Any) {
    spinner.startAnimating()

    let sender = sender as! UIBarButtonItem
    sender.isEnabled = false

    let previousVC = self.navigationController?.viewControllers.first as! TableViewController

    let borrowerExists = !previousVC.borrowers.contains(where: {
      $0.name == self.nameTextField.text! &&
        $0.amount == self.amountTextField.text! &&
        $0.activity == self.activityTextField.text!
    })

    if borrowerExists {
      queryForActivityImage() { noIssues in

        DispatchQueue.main.async {
          self.spinner.stopAnimating()
          sender.isEnabled = true
          if noIssues {
            let newBorrower = Borrower(
              name: self.nameTextField.text!,
              activity: self.activityTextField.text!,
              activityImage: self.activityImageURL,
              amount: self.amountTextField.text!)
            let borrowerEntity = self.convertToBorrowerEntity(borrower: newBorrower)

            self.appDelegate.saveContext()
            previousVC.borrowers.append(borrowerEntity)
            previousVC.tableView.reloadData()
          }
          else {
            self.presentAlert(withTitle: "Error", andMessage: "The borrower cannot be created.")
          }
          self.navigationController?.popViewController(animated: true)
        }

      }
    } else {
      self.spinner.stopAnimating()
      self.navigationController?.popViewController(animated: true)
    }
  }
}

extension NewBorrowerViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextTag = textField.tag + 1

    if let nextResponder = textField.superview?.superview?.viewWithTag(nextTag) {
      nextResponder.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }

    return true
  }

}

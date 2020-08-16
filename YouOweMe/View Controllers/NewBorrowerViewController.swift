//
//  NewBorrowerViewController.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/13/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import UIKit

class NewBorrowerViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var activityTextField: UITextField!
  @IBOutlet weak var amountTextField: CurrencyField!

  var activityImageURL: URL?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

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

  @IBAction func donePressed(_ sender: Any) {
    queryForActivityImage() { isDone in
      print(isDone)
      DispatchQueue.main.async {
        let newBorrower = Borrower(
          name: self.nameTextField.text!,
          activity: self.activityTextField.text!,
          activityImage: self.activityImageURL,
          amount: self.amountTextField.text!)
        let previousVC = self.navigationController?.viewControllers.first as! TableViewController
        previousVC.borrowers.append(newBorrower)
        previousVC.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
      }
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

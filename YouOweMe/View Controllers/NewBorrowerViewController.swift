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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    // TODO: Give user ability to change currency region
    amountTextField.locale = Locale(identifier: "en_US")

    amountTextField.keyboardType = .numberPad

    nameTextField.returnKeyType = UIReturnKeyType.next
    activityTextField.returnKeyType = UIReturnKeyType.next

    self.nameTextField.delegate = self
    self.amountTextField.delegate = self
    self.activityTextField.delegate = self

    self.nameTextField.becomeFirstResponder()
  }

  @IBAction func donePressed(_ sender: Any) {
    let newBorrower = Borrower(name: nameTextField.text!, activity: activityTextField.text!, amount: amountTextField.text!)
    let previousVC = navigationController?.viewControllers.first as! TableViewController
    previousVC.borrowerArray.append(newBorrower)
    previousVC.tableView.reloadData()
    navigationController?.popViewController(animated: true)
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

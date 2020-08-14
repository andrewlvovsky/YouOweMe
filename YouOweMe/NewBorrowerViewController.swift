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
  @IBOutlet weak var amountTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    nameTextField.returnKeyType = UIReturnKeyType.next
    amountTextField.returnKeyType = UIReturnKeyType.done
    self.nameTextField.delegate = self
    self.amountTextField.delegate = self
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  //    let vc = segue.destination as! TableViewController
  //  }

}

extension NewBorrowerViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextTag = textField.tag + 1

    if let nextResponder = textField.superview?.superview?.viewWithTag(nextTag) {
      nextResponder.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
      let newBorrower = Borrower(name: nameTextField.text!, amount: amountTextField.text!)
      // push data back to previous VC
      let vc = navigationController?.viewControllers[0] as! TableViewController
      vc.borrowerArray.append(newBorrower)
      vc.tableView.reloadData()
      navigationController?.popViewController(animated: true)
    }

    return true
  }
}

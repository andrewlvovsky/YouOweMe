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
  @IBOutlet weak var activityImage: UIImageView!

  let json = """
  {
    "kind": "customsearch#search",
    "url": {
      "type": "application/json",
      "template": "https://www.googleapis.com/customsearch/v1?q={searchTerms}&num={count?}&start={startIndex?}&lr={language?}&safe={safe?}&cx={cx?}&sort={sort?}&filter={filter?}&gl={gl?}&cr={cr?}&googlehost={googleHost?}&c2coff={disableCnTwTranslation?}&hq={hq?}&hl={hl?}&siteSearch={siteSearch?}&siteSearchFilter={siteSearchFilter?}&exactTerms={exactTerms?}&excludeTerms={excludeTerms?}&linkSite={linkSite?}&orTerms={orTerms?}&relatedSite={relatedSite?}&dateRestrict={dateRestrict?}&lowRange={lowRange?}&highRange={highRange?}&searchType={searchType}&fileType={fileType?}&rights={rights?}&imgSize={imgSize?}&imgType={imgType?}&imgColorType={imgColorType?}&imgDominantColor={imgDominantColor?}&alt=json"
    },
    "queries": {
      "request": [
        {
          "title": "Google Custom Search - swimming",
          "totalResults": "3660000000",
          "searchTerms": "swimming",
          "count": 1,
          "startIndex": 1,
          "inputEncoding": "utf8",
          "outputEncoding": "utf8",
          "safe": "off",
          "cx": "014035877497483723493:vpcwnljllha",
          "searchType": "image"
        }
      ],
      "nextPage": [
        {
          "title": "Google Custom Search - swimming",
          "totalResults": "3660000000",
          "searchTerms": "swimming",
          "count": 1,
          "startIndex": 2,
          "inputEncoding": "utf8",
          "outputEncoding": "utf8",
          "safe": "off",
          "cx": "014035877497483723493:vpcwnljllha",
          "searchType": "image"
        }
      ]
    },
    "context": {
      "title": "Google"
    },
    "searchInformation": {
      "searchTime": 0.348573,
      "formattedSearchTime": "0.35",
      "totalResults": "3660000000",
      "formattedTotalResults": "3,660,000,000"
    },
    "items": [
      {
        "kind": "customsearch#result",
        "title": "Simplify your workout with lap swimming - Harvard Health Blog ...",
        "htmlTitle": "Simplify your workout with lap <b>swimming</b> - Harvard Health Blog ...",
        "link": "https://hhp-blog.s3.amazonaws.com/2019/06/GettyImages-526245433.jpg",
        "displayLink": "www.health.harvard.edu",
        "snippet": "GettyImages-526245433.jpg",
        "htmlSnippet": "GettyImages-526245433.jpg",
        "mime": "image/jpeg",
        "fileFormat": "image/jpeg",
        "image": {
          "contextLink": "https://www.health.harvard.edu/blog/simplify-your-workout-with-lap-swimming-2019070117254",
          "height": 4032,
          "width": 6273,
          "byteSize": 9516179,
          "thumbnailLink": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReOgQyoD3i-z-NQiWnDmrhrNbsiFn4tla65CzC47pY1TOYVbhXmMwQRQ&s",
          "thumbnailHeight": 96,
          "thumbnailWidth": 150
        }
      }
    ]
  }
""".data(using: .utf8)!

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

  func decodeImage() {
    let decoder = JSONDecoder()
    let trimmedActivityString = activityTextField.text!.replacingOccurrences(of: " ", with: "+")
    let apiCallURL = URL(string: "https://customsearch.googleapis.com/customsearch/v1?cx=014035877497483723493%3Avpcwnljllha&num=1&searchType=image&key=AIzaSyDcH_V7ZvoYiN7kzCTHOS1BjG7g-xpd1dw&q=\(trimmedActivityString)")

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
          self.activityImage.load(url: url)
        }
      } catch {
        print("Unable to decode: \(error)")
      }

    }.resume()
  }

  @IBAction func donePressed(_ sender: Any) {
    let newBorrower = Borrower(name: nameTextField.text!, activity: activityTextField.text!, amount: amountTextField.text!)
    let previousVC = navigationController?.viewControllers.first as! TableViewController
    previousVC.borrowers.append(newBorrower)
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

  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.tag == 1 {
      decodeImage()
    }
  }
}

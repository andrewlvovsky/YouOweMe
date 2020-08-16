//
//  BorrowerTableViewCell.swift
//  YouOweMe
//
//  Created by Andrew Lvovsky on 8/14/20.
//  Copyright © 2020 Andrew Lvovsky. All rights reserved.
//

import UIKit

class BorrowerTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var activityLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var activityImage: UIImageView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    spinner.startAnimating()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}

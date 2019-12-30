//
//  ShowTableViewCell.swift
//  ExpanseManager
//
//  Created by Yasin Shamrat on 12/29/19.
//  Copyright © 2019 Yasin Shamrat. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {

    @IBOutlet weak var expenseTitle: UILabel!
    @IBOutlet weak var expenseAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

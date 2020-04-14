//
//  DetailTableViewCell.swift
//  RestaurantSercher
//
//  Created by cmStudent on 2020/04/13.
//  Copyright © 2020 19cm0133. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var actionSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

//
//  ShopTableViewCell.swift
//  RestaurantSercher
//
//  Created by cmStudent on 2020/04/13.
//  Copyright © 2020 19cm0133. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

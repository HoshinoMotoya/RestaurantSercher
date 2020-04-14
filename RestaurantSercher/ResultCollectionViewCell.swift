//
//  ResultCollectionViewCell.swift
//  RestaurantSercher
//
//  Created by cmStudent on 2020/04/05.
//  Copyright © 2020 19cm0133. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ShopImage: UIImageView!
    @IBOutlet weak var ShopName: UILabel!
    @IBOutlet weak var ShopAddress: UILabel!
    @IBOutlet weak var shopAccess: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}


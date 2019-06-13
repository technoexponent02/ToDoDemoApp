//
//  informationCell.swift
//  CRUDApp
//
//  Created by Techno-MAC on 13/06/19.
//  Copyright © 2019 Techno-MAC. All rights reserved.
//

import UIKit

class informationCell: UITableViewCell {
    @IBOutlet weak var id : UILabel!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var workDescription : UILabel!
    @IBOutlet weak var containerView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

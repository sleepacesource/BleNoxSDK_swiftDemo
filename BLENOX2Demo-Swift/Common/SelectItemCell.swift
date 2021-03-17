//
//  SelectItemCell.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/16.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class SelectItemCell: BaseTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectIcon.image = UIImage(named: "list_icon_select")
        self.selectIcon.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

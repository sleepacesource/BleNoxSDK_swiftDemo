//
//  NormalTableViewCell.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/16.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class NormalTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
   
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var arrowIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.arrowIcon.image = UIImage(named: "common_list_icon_leftarrow")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

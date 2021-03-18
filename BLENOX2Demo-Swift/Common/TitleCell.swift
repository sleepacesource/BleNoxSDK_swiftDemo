//
//  TitleCell.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/18.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class TitleCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

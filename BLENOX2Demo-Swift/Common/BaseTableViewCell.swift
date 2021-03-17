//
//  BaseTableViewCell.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/16.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lineDown: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUI()
    }
    
    func setUI() -> Void {
        self.lineDown.backgroundColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

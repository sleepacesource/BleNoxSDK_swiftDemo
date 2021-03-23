//
//  TitleValueSwitchCellTableViewCell.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/23.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class TitleValueSwitchCellTableViewCell: BaseTableViewCell {
    
    
    @IBOutlet weak var titleLbel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    var switcherBlock: SwitcherBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        self.switcherBlock!(sender)
    }
}

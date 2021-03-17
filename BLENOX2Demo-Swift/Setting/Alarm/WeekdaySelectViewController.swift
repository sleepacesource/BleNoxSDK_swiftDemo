//
//  WeekdaySelectViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/16.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

typealias SelectWeekdayBlock = (UInt8)->()

class WeekdaySelectViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var weekdayList: NSArray?
    
    var selectWeekDay: UInt8?
    
    var weekDayNew: UInt8?
    
    var selectWeekDayList: NSArray?
    
    var selectWeekdayBlock:SelectWeekdayBlock?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()

        // Do any additional setup after loading the view.
        self.weekdayList = NSArray.init(objects: "周一","周二","周三","周四","周五","周六","周日")
        self.weekDayNew = self.selectWeekDay
        
        let list = SLPWeekDay.getRepeatDays(self.weekDayNew!)
        self.selectWeekDayList = list as! NSArray
    }
    
    func setUI() -> Void {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        // 自定义
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        rightButton.setTitle("保存", for: UIControl.State.normal)
        rightButton.addTarget(self, action: #selector(rightClick), for: UIControl.Event.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc func rightClick() -> Void {
        self.selectWeekdayBlock!(self.weekDayNew!)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weekdayList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "SelectItemCell", bundle: nil), forCellReuseIdentifier: "SelectItemCell")
        let selectCell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell") as! SelectItemCell
        let title = self.weekdayList![indexPath.row]
        selectCell.titleLabel?.text = title as! String
        
        let selected = self.selectWeekDayList![indexPath.row]
        selectCell.selectIcon?.isHidden = !(selected as! Bool)
        
        return selectCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let repeatDays = self.weekDayNew;
        let offset:UInt8 = 0x01 << indexPath.row;
        self.weekDayNew = repeatDays! ^ offset;
        
        let list = SLPWeekDay.getRepeatDays(self.weekDayNew!)
        self.selectWeekDayList = list as! NSArray
        tableView.reloadData()
    }

}

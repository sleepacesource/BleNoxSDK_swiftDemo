//
//  TimeMissionListViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/16.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class TimeMissionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emptyLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var timeMissionList: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        
        self.initData()
    }
    
    func initData() -> Void {
        self.timeMissionList = DataManager.shared()?.timeMissionList
        self.emptyLbl.text = NSLocalizedString("sa_no_timer", comment: "")
        
        let hasData = self.timeMissionList!.count > 0
        
        if hasData {
            self.emptyLbl.isHidden = true
            self.tableView.isHidden = false
        } else {
            self.emptyLbl.isHidden = false
            self.tableView.isHidden = true
        }
    }
    
    func setUI() -> Void {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // 自定义
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        rightButton.setTitle(NSLocalizedString("add", comment: ""), for: UIControl.State.normal)
        rightButton.addTarget(self, action: #selector(rightClick), for: UIControl.Event.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc func rightClick() -> Void {
        let vc = TimeMissionViewController()
        vc.mode = 0
        vc.title = NSLocalizedString("addTimeMission", comment: "")
        vc.addAlarmID = UInt64(NSDate().timeIntervalSince1970)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeMissionList!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "TitleValueSwitchCellTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleValueSwitchCellTableViewCell")
        let switcherCell = tableView.dequeueReusableCell(withIdentifier: "TitleValueSwitchCellTableViewCell") as! TitleValueSwitchCellTableViewCell
        switcherCell.switcherBlock = {(switcher) -> () in
            
        }
        return switcherCell
    }
}

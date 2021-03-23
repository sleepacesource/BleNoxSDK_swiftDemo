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
    
    var timeMissionList: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        
        self.initData()
    }
    
    func initData() -> Void {
        self.timeMissionList = NSMutableArray.init()
        
        let timeMissionList = DataManager.shared().timeMissionList!
        for timeMission in timeMissionList {
            if timeMission.valid == 1 {
                self.timeMissionList?.add(timeMission)
            }
        }
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
        
        let info = self.timeMissionList![indexPath.row] as! BleNoxTimeMission
        let mode = info.mode
        if mode == 1 {
            switcherCell.titleLbel.text = NSLocalizedString("lightMode", comment: "")
        } else {
            switcherCell.titleLbel.text = NSLocalizedString("aidMode", comment: "")
        }
        
        switcherCell.switcher.isOn = info.isOpen
        
        switcherCell.switcherBlock = {(switcher) -> () in

        }
        return switcherCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let timeMission = self.timeMissionList![indexPath.row] as! BleNoxTimeMission
        self.goEditTimeMission(timeMission)
    }
    
    func goEditTimeMission(_ timeMission: BleNoxTimeMission) -> Void {
        let vc = TimeMissionViewController()
        vc.mode = 1
        vc.originTimeMission = timeMission
        vc.title = NSLocalizedString("编辑定时任务", comment: "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

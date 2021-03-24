//
//  AlarmListViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/16.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class AlarmListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var emptyLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var alarmList: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        
        self.initData()
    }
    
    func initData() -> Void {
        self.alarmList = NSMutableArray.init()
        
        let alarmList = DataManager.shared().alarmList!
        for alarm in alarmList {
            self.alarmList?.add(alarm)
        }
        
        self.emptyLbl.text = NSLocalizedString("sa_no_timer", comment: "")
        
        let hasData = self.alarmList!.count > 0
        
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
        if (self.alarmList!.count >= 5) {
            Utils.showMessage(NSLocalizedString("more_5", comment: ""), controller: self)
            return;
        }
        var alarmID: UInt64 = 0
        let list = self.alarmList!
        if list.count > 0 {
            for i in 0...4 {
                var exist = false
                for item in list {
                    let alarm = item as? BleNoxAlarmInfo
                    if i == alarm!.alarmID {
                        exist = true
                    }
                }
                
                if !exist {
                    alarmID = UInt64(i)
                    break
                }
            }
        }
        let vc = AlarmViewController()
        vc.addAlarmID = alarmID
        vc.mode = 0
        vc.reloadDataBlock = {()->() in
            self.getDataAndReload()
        }
        vc.title = NSLocalizedString("add_alarm", comment: "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getDataAndReload() -> Void {
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, getAlarmListTimeout: 0, completion: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed {
                DataManager.shared()?.alarmList = data as? [BleNoxAlarmInfo]
                
                self.alarmList?.removeAllObjects()
                let alarmList = DataManager.shared().alarmList!
                for alarm in alarmList {
                    self.alarmList?.add(alarm)
                }
                
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alarmList!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "TitleValueSwitchCellTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleValueSwitchCellTableViewCell")
        let switcherCell = tableView.dequeueReusableCell(withIdentifier: "TitleValueSwitchCellTableViewCell") as! TitleValueSwitchCellTableViewCell
        
        let info = self.alarmList![indexPath.row] as! BleNoxAlarmInfo
        let startStr = String(format: "%.2d:%.2d", info.hour, info.minute)
        switcherCell.titleLbel.text = startStr
        
        let repeatStr = SLPWeekDay.getAlarmRepeatDayString(withWeekDay: info.repeat)
        switcherCell.subTitleLabel.text = String(format: "%@",repeatStr!)
        
        switcherCell.switcher.isOn = info.isOpen
        
        switcherCell.switcherBlock = {(switcher) -> () in
            let isOn = switcher.isOn
            info.isOpen = isOn
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, alarmConfig: info, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
                if status != SLPDataTransferStatus.succeed {
                    Utils.showDeviceOperationFailed(-1, at: self)
                    return
                }
            })
        }
        return switcherCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alarm = self.alarmList![indexPath.row] as! BleNoxAlarmInfo
        self.goEditTAlarm(alarm)
    }
    
    func goEditTAlarm(_ alarm: BleNoxAlarmInfo) -> Void {
        let vc = AlarmViewController()
        vc.mode = 1
        vc.originAlarm = alarm
        vc.title = NSLocalizedString("edit_alarm", comment: "")
        vc.reloadDataBlock = {()->() in
            self.getDataAndReload()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

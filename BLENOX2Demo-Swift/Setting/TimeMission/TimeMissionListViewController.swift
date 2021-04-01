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
    
    func getMusicList() -> Array<MusicInfo> {
        var musicList = [MusicInfo]()
        
        var musicInfo = MusicInfo()
        musicInfo.musicID = 30001
        musicInfo.musicName = NSLocalizedString("music_list_sea", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30002
        musicInfo.musicName = NSLocalizedString("music_list_sun", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30003
        musicInfo.musicName = NSLocalizedString("music_list_dance", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30004
        musicInfo.musicName = NSLocalizedString("music_list_star", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30005
        musicInfo.musicName = NSLocalizedString("music_list_solo", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30006
        musicInfo.musicName = NSLocalizedString("music_list_rain", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30007
        musicInfo.musicName = NSLocalizedString("music_list_wind", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30008
        musicInfo.musicName = NSLocalizedString("music_list_summer", comment: "")
        musicList.append(musicInfo)
        
        return musicList
    }
    
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
    
    func getMusicName(_ musicID: UInt16) -> String {
        let musicList = self.getMusicList()
        
        var musicName = ""
        for music in musicList {
            if music.musicID == musicID {
                musicName = music.musicName!
                break
            }
        }
        
        return musicName
    }
    
    @objc func rightClick() -> Void {
        if (self.timeMissionList!.count >= 10) {
            Utils.showMessage(NSLocalizedString("设置已达上限", comment: ""), controller: self)
            return;
        }
        var timeID: UInt8 = 0
        let list = self.timeMissionList!
        if list.count > 0 {
            for i in 0...9 {
                var exist = false
                for timeMission in list {
                    let mission = timeMission as? BleNoxTimeMission
                    if i == mission!.timeID {
                        exist = true
                    }
                }
                
                if !exist {
                    timeID = UInt8(i)
                    break
                }
            }
        }
        let vc = TimeMissionViewController()
        vc.timeID = timeID
        vc.mode = 0
        vc.reloadDataBlock = {()->() in
            self.getDataAndReload()
        }
        vc.title = NSLocalizedString("add_timer", comment: "")
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
            switcherCell.titleLbel.text = NSLocalizedString("timer_mode_light", comment: "")
        } else {
            switcherCell.titleLbel.text = NSLocalizedString("timer_mode_aid", comment: "")
        }
        
        let repeatStr = SLPWeekDay.getAlarmRepeatDayString(withWeekDay: info.repeat)
        let startStr = String(format: "%.2d:%.2d", info.startHour, info.startMinute)
        let endStr = String(format: "%.2d:%.2d", info.endHour, info.endMinute)
        let musicName = self.getMusicName(info.musicID)
        if mode == 0 {
            switcherCell.subTitleLabel.text = String(format: "%@-%@ %@ %@", startStr, endStr, repeatStr!, musicName)
        } else {
            switcherCell.subTitleLabel.text = String(format: "%@-%@ %@", startStr, endStr, repeatStr!)
        }
        
        switcherCell.switcher.isOn = info.isOpen
        
        switcherCell.switcherBlock = {(switcher) -> () in
            let isOn = switcher.isOn
            info.isOpen = isOn
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, timeMissionConfig: info, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
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
        
        let timeMission = self.timeMissionList![indexPath.row] as! BleNoxTimeMission
        self.goEditTimeMission(timeMission)
    }
    
    func getDataAndReload() -> Void {
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, getTimeMissionListTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed {
                DataManager.shared()?.timeMissionList = data as? [BleNoxTimeMission]
                
                self.timeMissionList?.removeAllObjects()
                let timeMissionList = DataManager.shared().timeMissionList!
                for timeMission in timeMissionList {
                    if timeMission.valid == 1 {
                        self.timeMissionList?.add(timeMission)
                    }
                }
                
                let hasData = self.timeMissionList!.count > 0
                
                if hasData {
                    self.emptyLbl.isHidden = true
                    self.tableView.isHidden = false
                } else {
                    self.emptyLbl.isHidden = false
                    self.tableView.isHidden = true
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func goEditTimeMission(_ timeMission: BleNoxTimeMission) -> Void {
        let vc = TimeMissionViewController()
        vc.mode = 1
        vc.originTimeMission = timeMission
        vc.title = NSLocalizedString("编辑定时任务", comment: "")
        vc.reloadDataBlock = {()->() in
            self.getDataAndReload()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

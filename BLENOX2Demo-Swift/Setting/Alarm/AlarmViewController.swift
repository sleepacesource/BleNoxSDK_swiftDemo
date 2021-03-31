//
//  AlarmViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/16.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var originAlarm: BleNoxAlarmInfo?
    var alarmDataNew:BleNoxAlarmInfo?
    var addAlarmID: UInt64 = 0
    
    var isPreviewing: Bool = false
    
    var mode: Int?  // 0： 添加  1：编辑
    
    var reloadDataBlock: ReloadDataBlock?
    
    var preSnoozeTime:UInt8 = 5
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func getMusicList() -> Array<MusicInfo> {
        var musicList = [MusicInfo]()
        
        var musicInfo = MusicInfo()
        musicInfo.musicID = 31001
        musicInfo.musicName = NSLocalizedString("alarm_list_1", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 31002
        musicInfo.musicName = NSLocalizedString("alarm_list_2", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 31003
        musicInfo.musicName = NSLocalizedString("alarm_list_3", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 31004
        musicInfo.musicName = NSLocalizedString("alarm_list_4", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 31005
        musicInfo.musicName = NSLocalizedString("alarm_list_5", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 31006
        musicInfo.musicName = NSLocalizedString("alarm_list_6", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 31007
        musicInfo.musicName = NSLocalizedString("alarm_list_7", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 31008
        musicInfo.musicName = NSLocalizedString("alarm_list_8", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 31009
        musicInfo.musicName = NSLocalizedString("alarm_list_9", comment: "")
        musicList.append(musicInfo)
        
        return musicList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        
        self.initData()
    }
    
    func initData() -> Void {
        if self.mode == 0 {
            self.alarmDataNew = BleNoxAlarmInfo()
            self.alarmDataNew!.alarmID = self.addAlarmID;
            self.alarmDataNew!.isOpen = true;
            self.alarmDataNew!.hour = 8;
            self.alarmDataNew!.minute = 0;
            self.alarmDataNew!.repeat = 0;
            self.alarmDataNew!.snoozeTime = 5;
            self.preSnoozeTime = 5
            self.alarmDataNew!.snoozeLength = 9;
            self.alarmDataNew!.volume = 16;
            self.alarmDataNew!.brightness = 100;
            self.alarmDataNew!.shake = false;
            self.alarmDataNew!.musicID = 31001;
            self.alarmDataNew!.timestamp = UInt32(NSDate().timeIntervalSince1970)
            self.alarmDataNew!.alarmMaxTime = 8;
        } else {
            let alarmDataNew = BleNoxAlarmInfo()
            alarmDataNew.alarmID = self.originAlarm!.alarmID
            alarmDataNew.isOpen = self.originAlarm!.isOpen
            alarmDataNew.hour = self.originAlarm!.hour
            alarmDataNew.minute = self.originAlarm!.minute
            alarmDataNew.repeat = self.originAlarm!.repeat
            alarmDataNew.snoozeTime = self.originAlarm!.snoozeTime
            self.preSnoozeTime = self.originAlarm!.snoozeTime
            if self.originAlarm!.snoozeTime == 0 {
                self.preSnoozeTime = 5
                alarmDataNew.snoozeTime = 5
            }
            alarmDataNew.snoozeLength = self.originAlarm!.snoozeLength
            alarmDataNew.volume = self.originAlarm!.volume
            alarmDataNew.brightness = self.originAlarm!.brightness
            alarmDataNew.musicID = self.originAlarm!.musicID
            alarmDataNew.volume = self.originAlarm!.volume
            alarmDataNew.shake = self.originAlarm!.shake
            alarmDataNew.musicID = self.originAlarm!.musicID
            alarmDataNew.timestamp = self.originAlarm!.timestamp
            alarmDataNew.alarmMaxTime = self.originAlarm!.alarmMaxTime;
            self.alarmDataNew = alarmDataNew
        }
    }
    
    func setUI() -> Void {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        rightButton.setTitle(NSLocalizedString("save", comment: ""), for: UIControl.State.normal)
        rightButton.addTarget(self, action: #selector(rightClick), for: UIControl.Event.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
    }
    
    @objc func rightClick() -> Void {
        self.alarmDataNew!.isOpen = true
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, alarmConfig: self.alarmDataNew!, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed {
                self.reloadDataBlock!()
                Utils.showMessage(NSLocalizedString("save_succeed", comment: ""), controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                Utils.showDeviceOperationFailed(-1, at: self)
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = self.alarmDataNew! as BleNoxAlarmInfo
        if info.snoozeTime != 0 {
            return 9
        }
        return 7
    }
    
    func getAlarmTimeString(_ dataModel: BleNoxAlarmInfo) -> String {
        let timeStr = String(format: "%.2d:%.2d", dataModel.hour, dataModel.minute)
        return timeStr
    }
    
    func getAlarmMaxTimeString(_ dataModel: BleNoxAlarmInfo) -> String {
        let time = dataModel.alarmMaxTime
        return String(format: "%d %@", time, NSLocalizedString("min", comment: ""))
    }
    
    func getSnoozeTimeString(_ dataModel: BleNoxAlarmInfo) -> String {
        let time = dataModel.snoozeTime
        return String(format: "%d %@", time, NSLocalizedString("totalTime", comment: ""))
    }

    func getSnoozeLengthString(_ dataModel: BleNoxAlarmInfo) -> String {
        let time = dataModel.snoozeLength
        return String(format: "%d %@", time, NSLocalizedString("min", comment: ""))
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if indexPath.row == 0 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("time", comment: "")
            normalCell.subTitleLabel?.text = self.getAlarmTimeString(self.alarmDataNew!)
            return normalCell
        } else if indexPath.row == 1 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("alarmMaxTime", comment: "")
            normalCell.subTitleLabel?.text = self.getAlarmMaxTimeString(self.alarmDataNew!)
            return normalCell
        } else if indexPath.row == 2 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("reply", comment: "")
            normalCell.subTitleLabel?.text = SLPWeekDay.getAlarmRepeatDayString(withWeekDay: self.alarmDataNew!.repeat)
            return normalCell
        } else if indexPath.row == 3 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.subTitleLabel?.text = self.getMusicName(self.alarmDataNew!.musicID)
            normalCell.titleLabel?.text = NSLocalizedString("music", comment: "")
            return normalCell
        } else if indexPath.row == 4 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.subTitleLabel?.text = String(format: "%d", self.alarmDataNew!.volume)
            normalCell.titleLabel?.text = NSLocalizedString("volume", comment: "")
            return normalCell
        } else if indexPath.row == 5 {
            tableView.register(UINib(nibName: "SwtichTableViewCell", bundle: nil), forCellReuseIdentifier: "SwtichTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "SwtichTableViewCell") as! SwtichTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("light_wake", comment: "")
            normalCell.switcherBlock = {(switcher) ->() in
                if switcher.isOn {
                    self.alarmDataNew!.brightness = 100
                } else {
                    self.alarmDataNew!.brightness = 0
                }
            }
            return normalCell
        }  else if indexPath.row == 6 {
            tableView.register(UINib(nibName: "SwtichTableViewCell", bundle: nil), forCellReuseIdentifier: "SwtichTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "SwtichTableViewCell") as! SwtichTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("snoozeTime", comment: "")
            normalCell.switcherBlock = {(switcher) ->() in
                if switcher.isOn {
                    self.alarmDataNew!.snoozeTime = self.preSnoozeTime
                } else {
                    self.alarmDataNew!.snoozeTime = 0
                }
                self.tableView.reloadData()
            }
            return normalCell
        } else if indexPath.row == 7 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("snooze_duration", comment: "")
            normalCell.subTitleLabel?.text = self.getSnoozeLengthString(self.alarmDataNew!)
            return normalCell
        } else if indexPath.row == 8 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("snoozeTime", comment: "")
            normalCell.subTitleLabel?.text = self.getSnoozeTimeString(self.alarmDataNew!)
            return normalCell
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.goSelectTime()
        } else if indexPath.row == 1 {
            self.selectMaxTime()
        } else if indexPath.row == 2 {
            self.goSelectWeekdayPage()
        } else if indexPath.row == 3 {
            self.goSelectMusic()
        } else if indexPath.row == 4 {
            self.goSelectVolume()
        } else if indexPath.row == 7 {
            self.selectSnoothLength()
        } else if indexPath.row == 8 {
            self.selectSnoothLTime()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.mode == 1 {
            return 214
        }
        return 154
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel.init()
        label.text = NSLocalizedString("tips_snooze", comment: "")
        label.numberOfLines = 0
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true  //顶部约束
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true  //左端约束
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true  //右端约束
        
        let btn = UIButton()
        btn.addTarget(self, action: #selector(previewAndStopAlarm), for: UIControl.Event.touchUpInside)
        if self.isPreviewing {
            btn.setTitle(NSLocalizedString("preview_stop", comment: ""), for: UIControl.State.normal)
        } else {
            btn.setTitle(NSLocalizedString("preview_alarm", comment: ""), for: UIControl.State.normal)
        }
        view.addSubview(btn)
        btn.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        btn.layer.cornerRadius = 2.0;
        btn.layer.masksToBounds = true;
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true  //顶部约束
        btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true  //左端约束
        btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true  //右端约束
//        btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true  //底部约束
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        if self.mode == 1 {
            let btn1 = UIButton()
            btn1.addTarget(self, action: #selector(deleteAlarm), for: UIControl.Event.touchUpInside)
            btn1.setTitle(NSLocalizedString("delete_alram", comment: ""), for: UIControl.State.normal)
            view.addSubview(btn1)
            btn1.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
            btn1.layer.cornerRadius = 2.0;
            btn1.layer.masksToBounds = true;
            btn1.translatesAutoresizingMaskIntoConstraints = false
            btn1.topAnchor.constraint(equalTo: btn.bottomAnchor, constant: 15).isActive = true  //顶部约束
            btn1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true  //左端约束
            btn1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true  //右端约束
            btn1.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
//        btn1.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        return view
    }
    
    @objc func deleteAlarm() -> Void {
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, delAlarm: self.alarmDataNew!.alarmID, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed {
                self.reloadDataBlock!()
                Utils.showMessage(NSLocalizedString("已删除", comment: ""), controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                Utils.showDeviceOperationFailed(-1, at: self)
            }
        })
    }
    
    @objc func previewAndStopAlarm() {
        if self.isPreviewing {
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, stopAlarmRreviewTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
                if status == SLPDataTransferStatus.succeed {
                    self.isPreviewing = false
                    self.tableView.reloadData()
                } else {
                    print("stop preview failed")
                    Utils.showDeviceOperationFailed(-1, at: self)
                }
            })
        } else {
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, startAlarmRreviewvolume: self.alarmDataNew!.volume, brightness: self.alarmDataNew!.brightness, musicID: self.alarmDataNew!.musicID, timeout: 0, callback: { (status:SLPDataTransferStatus, data: Any?) in
                if status == SLPDataTransferStatus.succeed {
                    self.isPreviewing = true
                    self.tableView.reloadData()
                } else {
                    print("preview failed")
                    Utils.showDeviceOperationFailed(-1, at: self)
                }
            })
        }
    }
    
    func goSelectVolume() -> Void {
        let minuteSelectView = Bundle.main.loadNibNamed("SLPMinuteSelectView", owner: nil, options: nil)?.first as! SLPMinuteSelectView
        var values = [Int]()
        for i in 1...16 {
            values.append(i)
        }
        minuteSelectView.iValues = values
        minuteSelectView.show(in: UIApplication.shared.keyWindow!, mode: SLPMinutePickerMode.second, time: Int(self.alarmDataNew!.volume)) { (volume) in
            self.alarmDataNew!.volume = UInt8(volume)
            self.tableView.reloadData()
        } cancelHandle: {
            
        }

    }
    
    func goSelectMusic() -> Void {
        let vc = MusicListViewController()
        vc.title = NSLocalizedString("music_list", comment: "")
        let musicList = self.getMusicList()
        vc.musicList = musicList
        vc.musicID = self.alarmDataNew!.musicID
        vc.selectMusicBlock = {(musicID) ->() in
            self.alarmDataNew!.musicID = musicID
            self.tableView!.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goSelectTime() -> Void {
        let time = SLPTime24.init()
        time.hour = Int(self.alarmDataNew!.hour)
        time.minute = Int(self.alarmDataNew!.minute)
        
        let timePicker = Bundle.main.loadNibNamed("TimePickerSelectView", owner: nil, options: nil)?.first as! TimePickerSelectView
        timePicker.show(in: UIApplication.shared.keyWindow!, mode: SLPTimePickerMode._24Hour, time: time) { (time24) in
            self.alarmDataNew!.hour = UInt8(time24.hour)
            self.alarmDataNew!.minute = UInt8(time24.minute)
            self.tableView.reloadData()
        } cancelHandle: {
            
        }

    }
    
    func goSelectWeekdayPage() -> Void {
        let vc = WeekdaySelectViewController()
        vc.title = NSLocalizedString("reply", comment: "")
        vc.selectWeekDay = self.alarmDataNew!.repeat
        vc.selectWeekdayBlock = {(weekday) ->() in
            self.alarmDataNew!.repeat = weekday
            self.tableView!.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectMaxTime() -> Void {
        let minuteSelectView = Bundle.main.loadNibNamed("SLPMinuteSelectView", owner: nil, options: nil)?.first as! SLPMinuteSelectView
        var values = [Int]()
        for i in 1...10 {
            values.append(i)
        }
        minuteSelectView.iValues = values
        minuteSelectView.show(in: UIApplication.shared.keyWindow!, mode: SLPMinutePickerMode.second, time: Int(self.alarmDataNew!.alarmMaxTime)) { (timeValue) in
            self.alarmDataNew!.alarmMaxTime = UInt8(timeValue)
            self.tableView.reloadData()
        } cancelHandle: {
            
        }
    }
    
    func selectSnoothLength() -> Void {
        let minuteSelectView = Bundle.main.loadNibNamed("SLPMinuteSelectView", owner: nil, options: nil)?.first as! SLPMinuteSelectView
        var values = [Int]()
        for i in 1...60 {
            values.append(i)
        }
        minuteSelectView.iValues = values
        minuteSelectView.show(in: UIApplication.shared.keyWindow!, mode: SLPMinutePickerMode.second, time: Int(self.alarmDataNew!.snoozeLength)) { (timeValue) in
            self.alarmDataNew!.snoozeLength = UInt8(timeValue)
            self.tableView.reloadData()
        } cancelHandle: {
            
        }
    }
    
    func selectSnoothLTime() -> Void {
        let minuteSelectView = Bundle.main.loadNibNamed("SLPMinuteSelectView", owner: nil, options: nil)?.first as! SLPMinuteSelectView
        var values = [Int]()
        for i in 1...5 {
            values.append(i)
        }
        minuteSelectView.iValues = values
        minuteSelectView.show(in: UIApplication.shared.keyWindow!, mode: SLPMinutePickerMode.second, time: Int(self.alarmDataNew!.snoozeTime)) { (timeValue) in
            self.preSnoozeTime = UInt8(timeValue)
            self.alarmDataNew!.snoozeTime = UInt8(timeValue)
            self.tableView.reloadData()
        } cancelHandle: {
            
        }
    }
}

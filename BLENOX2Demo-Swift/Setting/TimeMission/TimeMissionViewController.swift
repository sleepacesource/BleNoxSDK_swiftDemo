//
//  AlarmViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/16.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

typealias ReloadDataBlock = () -> ()

class TimeMissionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var timeID:UInt8 = 0
    
    var timeMissionNew: BleNoxTimeMission?
    
    var originTimeMission: BleNoxTimeMission?
    
    var mode: Int?  // 0： 添加  1：编辑
    
    var reloadDataBlock: ReloadDataBlock?

    @IBOutlet weak var tableView: UITableView!
    
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
        
        if self.mode == 0 {
            let timeMissionNew = BleNoxTimeMission()
            timeMissionNew.timeID = self.timeID
            timeMissionNew.isOpen = true;
            timeMissionNew.startHour = 20;
            timeMissionNew.startMinute = 0;
            timeMissionNew.endHour = 21;
            timeMissionNew.startMinute = 0;
            timeMissionNew.repeat = 0;
            timeMissionNew.mode = 1;
            
            let light = SLPLight()
            light.r = 155;
            light.g = 32;
            light.b = 93;
            light.w = 255;
            timeMissionNew.light = light;
            
            timeMissionNew.brightness = 100;
            timeMissionNew.musicID = 30001;
            timeMissionNew.volume = 6;
            timeMissionNew.playMode = 0
            timeMissionNew.valid = 1
            
            self.timeMissionNew = timeMissionNew
        } else {
            let timeMissionNew = BleNoxTimeMission()
            timeMissionNew.timeID = self.originTimeMission!.timeID
            timeMissionNew.isOpen = self.originTimeMission!.isOpen
            timeMissionNew.startHour = self.originTimeMission!.startHour
            timeMissionNew.startMinute = self.originTimeMission!.startMinute
            timeMissionNew.endHour = self.originTimeMission!.endHour
            timeMissionNew.endMinute = self.originTimeMission!.endMinute
            timeMissionNew.repeat = self.originTimeMission!.repeat
            timeMissionNew.mode = self.originTimeMission!.mode
            
            let light = SLPLight()
            light.r = self.originTimeMission!.light.r
            light.g = self.originTimeMission!.light.g
            light.b = self.originTimeMission!.light.b
            light.w = self.originTimeMission!.light.w
            timeMissionNew.light = self.originTimeMission!.light
            
            timeMissionNew.brightness = self.originTimeMission!.brightness
            timeMissionNew.musicID = self.originTimeMission!.musicID
            timeMissionNew.volume = self.originTimeMission!.volume
            timeMissionNew.valid = self.originTimeMission!.valid
            timeMissionNew.playMode = self.originTimeMission!.playMode
            timeMissionNew.timeStamp = self.originTimeMission!.timeStamp
            self.timeMissionNew = timeMissionNew
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
        self.timeMissionNew!.valid = 1
        self.timeMissionNew!.isOpen = true
        self.timeMissionNew!.timeStamp = UInt32(NSDate.init().timeIntervalSince1970)
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, timeMissionConfig: self.timeMissionNew, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status != SLPDataTransferStatus.succeed {
                Utils.showDeviceOperationFailed(-1, at: self)
                return
            }
            
            self.reloadDataBlock!()
            Utils.showMessage(NSLocalizedString("save_succeed", comment: ""), controller: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.timeMissionNew!.mode == 1 {
            return 5
        }
        return 6
    }
    
    func getAlarmTimeString(_ hour: UInt8, _ minute: UInt8) -> String {
        let timeStr = String(format: "%.2d:%.2d", hour, minute)
        return timeStr
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
            normalCell.titleLabel?.text = NSLocalizedString("start_time", comment: "")
            normalCell.subTitleLabel?.text = self.getAlarmTimeString(self.timeMissionNew!.startHour, self.timeMissionNew!.startMinute)
            return normalCell
        } else if indexPath.row == 1 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("closeTime", comment: "")
            normalCell.subTitleLabel?.text = self.getAlarmTimeString(self.timeMissionNew!.endHour, self.timeMissionNew!.endMinute)
            return normalCell
        }
        else if indexPath.row == 2 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("reply", comment: "")
            normalCell.subTitleLabel?.text = SLPWeekDay.getAlarmRepeatDayString(withWeekDay: self.timeMissionNew!.repeat)
            return normalCell
        } else if indexPath.row == 3 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            if self.timeMissionNew!.mode == 1 {
                normalCell.subTitleLabel?.text = NSLocalizedString("lightMode", comment: "")
            } else {
                normalCell.subTitleLabel?.text = NSLocalizedString("aidMode", comment: "")
            }
            normalCell.titleLabel?.text = NSLocalizedString("openMode", comment: "")
            return normalCell
        } else if indexPath.row == 4 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("setLight", comment: "")
            return normalCell
        } else if indexPath.row == 5 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
//            normalCell.subTitleLabel?.text = self.getMusicName(self.timeMissionNew!.musicID)
            normalCell.titleLabel?.text = NSLocalizedString("setMusic", comment: "")
            return normalCell
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.goSelectTime()
        }else if indexPath.row == 1 {
            self.goSelectEndTime()
        }
        else if indexPath.row == 2 {
            self.goSelectWeekdayPage()
        } else if indexPath.row == 3 {
            self.goSelectMode()
        } else if indexPath.row == 4 {
            self.goSetLight()
        } else if indexPath.row == 5 {
            self.goSelectMusic()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.mode == 1 {
            return 104
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        if self.mode == 1 {
            let btn = UIButton()
            btn.addTarget(self, action: #selector(deleteMission), for: UIControl.Event.touchUpInside)
            btn.setTitle(NSLocalizedString("sa_delete", comment: ""), for: UIControl.State.normal)
            view.addSubview(btn)
            btn.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
            btn.layer.cornerRadius = 2.0;
            btn.layer.masksToBounds = true;
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true  //顶部约束
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true  //左端约束
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true  //右端约束
            btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true  //底部约束
        }
        
        return view
    }
    
    @objc func deleteMission() {
        
        
        let alertVc = UIAlertController(title: "删除定时任务", message: "确认是否删除此定时任务？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                    action in
                    self.timeMissionNew!.valid = 0
                    self.timeMissionNew!.timeStamp = UInt32(NSDate.init().timeIntervalSince1970)
                    SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, timeMissionConfig: self.timeMissionNew, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
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
                })
        alertVc.addAction(cancelAction)
        alertVc.addAction(okAction)
        self.present(alertVc, animated: true, completion: nil)
    }
    
    func goSelectVolume() -> Void {
        let minuteSelectView = Bundle.main.loadNibNamed("SLPMinuteSelectView", owner: nil, options: nil)?.first as! SLPMinuteSelectView
        var values = [Int]()
        for i in 1...16 {
            values.append(i)
        }
        minuteSelectView.iValues = values
        minuteSelectView.show(in: UIApplication.shared.keyWindow!, mode: SLPMinutePickerMode.second, time: Int(self.timeMissionNew!.volume)) { (volume) in
            self.timeMissionNew!.volume = UInt8(volume)
            self.tableView.reloadData()
        } cancelHandle: { 
            
        }

    }
    
    func goSelectMode() -> Void {
        let picker = Bundle.main.loadNibNamed("DataPicker", owner: nil, options: nil)?.first as! DataPicker
        picker.dataList = [NSLocalizedString("aidMode", comment: ""), NSLocalizedString("lightMode", comment: "")]
        picker.selectedRow = Int(self.timeMissionNew!.mode)
        picker.reload()
        picker.backgroundColor = UIColor.clear
        picker.cancelBlock = {() ->() in
            picker.removeFromSuperview()
        }
        picker.confirmBlock = {(row) ->() in
            self.timeMissionNew!.mode = UInt8(row)
            if self.mode == 0 {
                if row == 1 {
                    self.timeMissionNew!.light.r = 155
                    self.timeMissionNew!.light.g = 32
                    self.timeMissionNew!.light.b = 93
                    self.timeMissionNew!.light.w = 255
                    self.timeMissionNew!.brightness = 100
                } else {
                    self.timeMissionNew!.light.r = 255
                    self.timeMissionNew!.light.g = 35
                    self.timeMissionNew!.light.b = 0
                    self.timeMissionNew!.light.w = 0
                    self.timeMissionNew!.brightness = 30
                }
            }
            self.tableView.reloadData()
            picker.removeFromSuperview()
        }
        Utils.addSubView(picker, suitableTo: UIApplication.shared.keyWindow)
    }
    
    func goSetLight() -> Void {
        let vc = SetLightViewController()
        vc.title = NSLocalizedString("setLight", comment: "")
        vc.r = self.timeMissionNew!.light.r
        vc.g = self.timeMissionNew!.light.g
        vc.b = self.timeMissionNew!.light.b
        vc.w = self.timeMissionNew!.light.w
        vc.brightness = self.timeMissionNew!.brightness
        vc.setLightBlock = {(r,g,b,w,brightness) ->() in
            self.timeMissionNew!.light.r = r
            self.timeMissionNew!.light.g = g
            self.timeMissionNew!.light.b = b
            self.timeMissionNew!.light.w = w
            self.timeMissionNew!.brightness = brightness
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goSelectMusic() -> Void {
        let vc = MusicInfoSettingViewController()
        vc.title = NSLocalizedString("setMusic", comment: "")
        vc.musicID = self.timeMissionNew!.musicID
        vc.volume = self.timeMissionNew!.volume
        vc.playMode = self.timeMissionNew!.playMode
        vc.musicInfoSettingBlock = {(playMode, musicID, volume) ->() in
            self.timeMissionNew!.musicID = musicID
            self.timeMissionNew!.volume = volume
            self.timeMissionNew!.playMode = playMode
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goSelectEndTime() -> Void {
        let time = SLPTime24.init()
        time.hour = Int(self.timeMissionNew!.endHour)
        time.minute = Int(self.timeMissionNew!.endMinute)
        
        let timePicker = Bundle.main.loadNibNamed("TimePickerSelectView", owner: nil, options: nil)?.first as! TimePickerSelectView
        timePicker.show(in: UIApplication.shared.keyWindow!, mode: SLPTimePickerMode._24Hour, time: time) { (time24) in
            self.timeMissionNew!.endHour = UInt8(time24.hour)
            self.timeMissionNew!.endMinute = UInt8(time24.minute)
            self.tableView.reloadData()
        } cancelHandle: {
            
        }
    }
    
    func goSelectTime() -> Void {
        let time = SLPTime24.init()
        time.hour = Int(self.timeMissionNew!.startHour)
        time.minute = Int(self.timeMissionNew!.startMinute)
        
        let timePicker = Bundle.main.loadNibNamed("TimePickerSelectView", owner: nil, options: nil)?.first as! TimePickerSelectView
        timePicker.show(in: UIApplication.shared.keyWindow!, mode: SLPTimePickerMode._24Hour, time: time) { (time24) in
            self.timeMissionNew!.startHour = UInt8(time24.hour)
            self.timeMissionNew!.startMinute = UInt8(time24.minute)
            self.tableView.reloadData()
        } cancelHandle: {
            
        }

    }
    
    func goSelectWeekdayPage() -> Void {
        let vc = WeekdaySelectViewController()
        vc.title = NSLocalizedString("reply", comment: "")
        vc.selectWeekDay = self.timeMissionNew!.repeat
        vc.selectWeekdayBlock = {(weekday) ->() in
            self.timeMissionNew!.repeat = weekday
            self.tableView!.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

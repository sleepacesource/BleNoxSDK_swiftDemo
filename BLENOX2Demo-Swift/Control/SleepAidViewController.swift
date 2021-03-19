//
//  SleepAidViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by San on 12/9/2019.
//  Copyright © 2019 medica. All rights reserved.
//

import UIKit

class SleepAidViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var arrowIcon1: UIImageView!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var volLabel: UILabel!
    @IBOutlet weak var volTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var stopMusicBtn: UIButton!
    @IBOutlet weak var line3: UIView!

    // 第二段
    @IBOutlet weak var colorRTextField: UITextField!
    @IBOutlet weak var colorGTextfFiled: UITextField!
    @IBOutlet weak var colorBTextFiled: UITextField!
    @IBOutlet weak var colorWTextFiled: UITextField!
    @IBOutlet weak var brightnessTextFiled: UITextField!
    @IBOutlet weak var sendColorBtn: UIButton!
    @IBOutlet weak var sendBrightnessBtn: UIButton!
    @IBOutlet weak var openLightBtn: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var line4: UIView!

    // 第三段
    @IBOutlet weak var line5: UIView!
    @IBOutlet weak var line6: UIView!
    @IBOutlet weak var aromeTimeLabel: UILabel!
    @IBOutlet weak var arrowIcon2: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    

    var musicList: NSMutableArray?

    var isPlayingMusic = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.colorGTextfFiled.text = "";
        self.brightnessTextFiled.text = "";
        self.volTextField.text = "";
        self.setUI();
    }
    
    func getSleepAidMusicList() -> Array<MusicInfo> {
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
    
    func setUI() -> Void {
        self.line1.backgroundColor = Theme.normalLineColor()!
        self.line2.backgroundColor = Theme.normalLineColor()!
        self.line3.backgroundColor = Theme.normalLineColor()!
        self.line4.backgroundColor = Theme.normalLineColor()!
        self.line5.backgroundColor = Theme.normalLineColor()!
        self.line6.backgroundColor = Theme.normalLineColor()!
        
        self.arrowIcon1.image = UIImage.init(named: "common_list_icon_leftarrow")
        self.arrowIcon2.image = UIImage.init(named: "common_list_icon_leftarrow")
        
        self.setMusicUI()
        
        self.setLightUI()
        
        self.setAromaUI()
    }
    
    func setMusicUI() -> Void {
        self.musicLabel.text = NSLocalizedString("music", comment: "")
        self.volLabel.text = NSLocalizedString("volume", comment: "")
        self.musicLabel.textColor = Theme.c4()
        self.volLabel.textColor = Theme.c4()
        
        self.sendBtn.layer.masksToBounds = true
        self.sendBtn.layer.cornerRadius = 5;
        self.sendBtn.setTitle(NSLocalizedString("send", comment: ""), for: UIControl.State.normal)
        self.stopMusicBtn.layer.masksToBounds = true;
        self.stopMusicBtn.layer.cornerRadius = 5;
        
        if (DataManager.shared().aidInfo.volume > 0) {
            self.volTextField.text = String(format: "%d", DataManager.shared().aidInfo.volume)
        }
    }
    
    func setLightUI() -> Void {
        self.colorRTextField.text = String(format: "%d", 255)
        self.colorBTextFiled.text = String(format: "%d", 0)
        self.colorWTextFiled.text = String(format: "%d", 0)
        
        self.colorLabel.text = NSLocalizedString("color", comment: "")
        self.brightnessLabel.text = NSLocalizedString("luminance", comment: "")
        self.colorLabel.textColor = Theme.c4()
        self.brightnessLabel.textColor = Theme.c4()
        
        self.sendColorBtn.setTitle(NSLocalizedString("send", comment: ""), for: UIControl.State.normal)
        self.sendBrightnessBtn.setTitle(NSLocalizedString("send", comment: ""), for: UIControl.State.normal)
        self.openLightBtn.setTitle(NSLocalizedString("turn_off", comment: ""), for: UIControl.State.normal)
        
        self.sendColorBtn.backgroundColor = Theme.c2()
        self.sendBrightnessBtn.backgroundColor = Theme.c2()
        self.openLightBtn.backgroundColor = Theme.c2()
        
        self.sendColorBtn.layer.masksToBounds = true;
        self.sendColorBtn.layer.cornerRadius = 5;
        self.sendBrightnessBtn.layer.masksToBounds = true;
        self.sendBrightnessBtn.layer.cornerRadius = 5;
        self.openLightBtn.layer.masksToBounds = true;
        self.openLightBtn.layer.cornerRadius = 5;
        
        self.musicNameLabel.text = self.getMusicNameWithMusicID(musicId: DataManager.shared().assistMusicID)
        
        self.stopMusicBtn.setTitle(NSLocalizedString("play", comment: ""), for: UIControl.State.normal)
        
        if (DataManager.shared().aidInfo.g > 0) {
            self.colorGTextfFiled.text = String(format: "%d", DataManager.shared().aidInfo.g)
        }
        
        if (DataManager.shared().aidInfo.brightness > 0) {
            self.brightnessTextFiled.text = String(format: "%d", DataManager.shared().aidInfo.brightness)
        }
    }
    
    func getMusicNameWithMusicID(musicId: Int) -> String {
        let musicList = self.getSleepAidMusicList()
        for music in musicList {
            if musicId == music.musicID! {
                return music.musicName!
            }
        }
        
        return ""
    }
    
    func setAromaUI() -> Void {
        
//        self.timeLabel.text = [NSString stringWithFormat:@"%d%@", SharedDataManager.aidInfo.aidStopDuration, LocalizedString(@"min")];
        self.timeLabel.text = String(format: "%d%@", DataManager.shared().aidInfo.aidStopDuration, NSLocalizedString("min", comment: ""))
        let duration = String(format: "%d", DataManager.shared().aidInfo.aidStopDuration)
        self.descLabel.text = String(format: NSLocalizedString("music_aroma_light_close2", comment: ""), duration)
        self.descLabel.textColor = Theme.c4()
        self.timeLabel.textColor = Theme.c4()
        
        self.aromeTimeLabel.text = NSLocalizedString("time_out", comment: "")
        
        self.saveBtn.setTitle(NSLocalizedString("save", comment: ""), for: UIControl.State.normal)
        self.saveBtn.layer.masksToBounds = true
        self.saveBtn.layer.cornerRadius = 5;
    }
    
    func initData() -> Void {
    }
    
    @IBAction func goMusicList(_ sender: Any) {
        let vc = MusicListViewController()
        vc.musicList = self.getSleepAidMusicList()
        vc.musicID = UInt16(DataManager.shared().assistMusicID)
        vc.mode = 1
        vc.selectMusicBlock = {(musicId) ->() in
            DataManager.shared()?.assistMusicID = Int(musicId)
            self.musicNameLabel.text = self.getMusicNameWithMusicID(musicId: Int(musicId))
            
            if self.isPlayingMusic {
                self._playMusic()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sendVolAction(_ sender: Any) {
        let len = self.volTextField.text!.count > 0
        if !len {
            Utils.showMessage(NSLocalizedString("input_0_16", comment: ""), controller: self)
            return
        }
        
        let volume = UInt8(self.volTextField.text!)
        let isValid = (volume! >= 0) && (volume! <= 16);
        if !isValid {
            Utils.showMessage(NSLocalizedString("input_0_16", comment: ""), controller: self)
            return
        }
        
        let isOpen = SLPBLEManager.shared()?.blueToothIsOpen()
        if !(isOpen!) {
            Utils.showMessage(NSLocalizedString("phone_bluetooth_not_open", comment: ""), controller: self);
            return
        }
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, setSleepAidMusicVolume: volume!, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status != SLPDataTransferStatus.succeed  {
                Utils.showDeviceOperationFailed(-1, at: self)
            } else {
                DataManager.shared()?.volumn = Int(volume!)
            }
        })
    }
    
    func _playMusic() -> Void {
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOnsleepAidMusic: UInt16(DataManager.shared().assistMusicID), volume: UInt8(DataManager.shared().volumn), playMode: 2, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            
        })
    }
    
    @IBAction func playMusic(_ sender: UIButton) {
        let len = self.volTextField.text!.count > 0
        if !len {
            Utils.showMessage(NSLocalizedString("input_0_16", comment: ""), controller: self)
            return
        }
        
        let volume = UInt8(self.volTextField.text!)
        let isValid = (volume! >= 0) && (volume! <= 16);
        if !isValid {
            Utils.showMessage(NSLocalizedString("input_0_16", comment: ""), controller: self)
            return
        }
        
        let isOpen = SLPBLEManager.shared()?.blueToothIsOpen()
        if !(isOpen!) {
            Utils.showMessage(NSLocalizedString("phone_bluetooth_not_open", comment: ""), controller: self);
            return
        }
        
        if sender.isSelected {
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOffSleepAidMusic: 0, callback: {(status: SLPDataTransferStatus, data: Any?) in
                if status != SLPDataTransferStatus.succeed  {
                    Utils.showDeviceOperationFailed(-1, at: self)
                } else {
                    sender.isSelected = false
                    self.stopMusicBtn.setTitle(NSLocalizedString("play", comment: ""), for: UIControl.State.normal)
                    self.isPlayingMusic = false
                }
            })
        } else {
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOnsleepAidMusic: UInt16(DataManager.shared().assistMusicID), volume: UInt8(DataManager.shared().volumn), playMode: 2, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
                if status != SLPDataTransferStatus.succeed  {
                    Utils.showDeviceOperationFailed(-1, at: self)
                } else {
                    sender.isSelected = true
                    self.stopMusicBtn.setTitle(NSLocalizedString("pause", comment: ""), for: UIControl.State.normal)
                    self.isPlayingMusic = true
                }
            })
        }
    }
    
    @IBAction func sendColorAction(_ sender: Any) {
        let len = self.colorGTextfFiled.text!.count > 0
        if !len {
            Utils.showMessage(NSLocalizedString("input_0_120", comment: ""), controller: self)
            return
        }
        
        let g = UInt8(self.colorGTextfFiled.text!)
        let isValid = (g! >= 0) && (g! <= 120);
        if !isValid {
            Utils.showMessage(NSLocalizedString("input_0_120", comment: ""), controller: self)
            return
        }
        
        self.turnOnLight()
    }
    
    func turnOnLight() -> Void {
        let r = Int(self.colorRTextField.text!)
        let g = Int(self.colorGTextfFiled.text!)
        let b = Int(self.colorBTextFiled.text!)
        let w = Int(self.colorWTextFiled.text!)
        
        var brightness:UInt8 = 50
        
        let valueBrightness = self.brightnessTextFiled.text!.count > 0
        if valueBrightness {
            let brightnessTextValue = Int(self.brightnessTextFiled.text!)
            if (brightnessTextValue! >= 0) && (brightnessTextValue! <= 100) {
                brightness = UInt8(brightnessTextValue!)
            }
        }
        
        let light = SLPLight()
        light.r = UInt8(r!)
        light.g = UInt8(g!)
        light.b = UInt8(b!)
        light.w = UInt8(w!)
        
        let isOpen = SLPBLEManager.shared()?.blueToothIsOpen()
        if !(isOpen!) {
            Utils.showMessage(NSLocalizedString("phone_bluetooth_not_open", comment: ""), controller: self);
            return
        }
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOnSleepAidLight: light, brightness: brightness, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status != SLPDataTransferStatus.succeed {
                Utils.showDeviceOperationFailed(-1, at: self)
            }
        })
    }
    
    @IBAction func sendBrightnessAction(_ sender: UIButton) {
        let len = self.brightnessTextFiled.text!.count > 0
        if !len {
            Utils.showMessage(NSLocalizedString("input_0_100", comment: ""), controller: self)
            return
        }
        
        let g = UInt8(self.colorGTextfFiled.text!)
        let isValid = (g! >= 0) && (g! <= 100);
        if !isValid {
            Utils.showMessage(NSLocalizedString("input_0_100", comment: ""), controller: self)
            return
        }
        
        self.turnOnLight()
    }
    
    @IBAction func openLight(_ sender: Any) {
        let isOpen = SLPBLEManager.shared()?.blueToothIsOpen()
        if !(isOpen!) {
            Utils.showMessage(NSLocalizedString("phone_bluetooth_not_open", comment: ""), controller: self);
            return
        }
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOffLightTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status != SLPDataTransferStatus.succeed  {
                Utils.showDeviceOperationFailed(-1, at: self)
            }
        })
    }
    
    @IBAction func selectTime(_ sender: UIButton) {
        let minuteSelectView = Bundle.main.loadNibNamed("SLPMinuteSelectView", owner: nil, options: nil)?.first as! SLPMinuteSelectView
        var values = [Int]()
        for i in 1...45 {
            values.append(i)
        }
        minuteSelectView.iValues = values
        minuteSelectView.show(in: UIApplication.shared.keyWindow!, mode: SLPMinutePickerMode.second, time: Int(DataManager.shared().aidInfo.aidStopDuration)) { (timeValue) in
            DataManager.shared().aidInfo.aidStopDuration = UInt8(timeValue);
            self.timeLabel.text = String(format: "%d%@", timeValue, NSLocalizedString("min", comment: ""))
            
            let duration = String(format: "%d", DataManager.shared().aidInfo.aidStopDuration)
            self.descLabel.text = String(format: NSLocalizedString("music_aroma_light_close2", comment: ""), duration)
        } cancelHandle: {
            
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        let r = UInt8(self.colorRTextField.text!)
        let g = UInt8(self.colorGTextfFiled.text!)
        let b = UInt8(self.colorBTextFiled.text!)
        let w = UInt8(self.colorWTextFiled.text!)

        
        let gValid = (g! >= 0) && (g! <= 120);
        
        if (!gValid) {
            Utils.showMessage(NSLocalizedString("input_0_120", comment: ""), controller: self)
            return;
        }
        
        let brightness = UInt8(self.brightnessTextFiled.text!)
        let brightValid = (brightness! >= 0) && (brightness! <= 100);
        if (!brightValid) {
            Utils.showMessage(NSLocalizedString("input_0_100", comment: ""), controller: self)
            return;
        }
        
        let volumn = UInt8(self.volTextField.text!)
        if (volumn! < 1 || volumn! > 16) {
            Utils.showMessage(NSLocalizedString("input_0_16", comment: ""), controller: self)
            return;
        }
        
        let aidInfo = BleNoxAidInfo.init()
        aidInfo.r = r!;
        aidInfo.g = g!;
        aidInfo.b = b!;
        aidInfo.w = w!;
        aidInfo.brightness = brightness!;
    //    aidInfo.aromaRate = SharedDataManager.aidInfo.aromaRate;
        aidInfo.aidStopDuration = DataManager.shared().aidInfo.aidStopDuration;
        aidInfo.volume = volumn!
        
        let isOpen = SLPBLEManager.shared()?.blueToothIsOpen()
        if !(isOpen!) {
            Utils.showMessage(NSLocalizedString("phone_bluetooth_not_open", comment: ""), controller: self);
            return
        }
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, sleepAidConfig: aidInfo, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status != SLPDataTransferStatus.succeed  {
                Utils.showDeviceOperationFailed(-1, at: self)
            } else {
                Utils.showMessage(NSLocalizedString("save_succeed", comment: ""), controller: self)
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view?.endEditing(true)
    }
}

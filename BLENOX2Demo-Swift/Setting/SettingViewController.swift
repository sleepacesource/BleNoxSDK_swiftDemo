//
//  SettingViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by San on 12/9/2019.
//  Copyright © 2019 medica. All rights reserved.
//

import UIKit

/*手势大全
 */
enum GestureMode: Int {
    case wave = 0 //挥手
    case hover    //悬停
    case keypad   //按键
}

class SettingViewController: UIViewController {
    
    @IBOutlet weak var alarmMinTextField: UITextField!
    @IBOutlet weak var alarmHourTextField: UITextField!
    @IBOutlet weak var alrmRepeatTextField: UITextField!
    @IBOutlet weak var musicIDTextField: UITextField!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var rTextField: UITextField!
    @IBOutlet weak var gTextField: UITextField!
    @IBOutlet weak var bTextField: UITextField!
    @IBOutlet weak var wTextField: UITextField!
    @IBOutlet weak var brightnessTextField: UITextField!
    @IBOutlet weak var startMinTextField: UITextField!
    @IBOutlet weak var startHourTextField: UITextField!
    @IBOutlet weak var endHourTextField: UITextField!
    @IBOutlet weak var endMinTextField: UITextField!
    @IBOutlet weak var gestureTextField: UITextField!
    @IBOutlet weak var centerSettingTextField: UITextField!
    
    @IBOutlet weak var previewAlarm: UIButton!
    @IBOutlet weak var saveAlarm: UIButton!
    @IBOutlet weak var saveNightLight: UIButton!
    @IBOutlet weak var saveGesture: UIButton!
    @IBOutlet weak var saveCenterSetting: UIButton!
    @IBOutlet weak var resetBT: UIButton!
    
    @IBOutlet weak var alarmLightSwitch: UISwitch!
    @IBOutlet weak var nightLightSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUI()
        self.initData()
    }
    
    func setUI() -> Void {
        self.previewAlarm.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.previewAlarm.layer.cornerRadius = 2.0;
        self.previewAlarm.layer.masksToBounds = true;
        self.saveAlarm.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.saveAlarm.layer.cornerRadius = 2.0;
        self.saveAlarm.layer.masksToBounds = true;
        self.saveNightLight.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.saveNightLight.layer.cornerRadius = 2.0;
        self.saveNightLight.layer.masksToBounds = true;
        self.saveGesture.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.saveGesture.layer.cornerRadius = 2.0;
        self.saveGesture.layer.masksToBounds = true;
        self.saveCenterSetting.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.saveCenterSetting.layer.cornerRadius = 2.0;
        self.saveCenterSetting.layer.masksToBounds = true;
        self.resetBT.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.resetBT.layer.cornerRadius = 2.0;
        self.resetBT.layer.masksToBounds = true;
        
        self.previewAlarm.setTitle("预览闹钟", for: UIControl.State.normal)
        self.previewAlarm.setTitle("停止预览", for: UIControl.State.selected)
    }
    
    func initData() -> Void {
        
        //a闹钟
        /*闹钟音乐编号
         *31001，10002，31003，31004，31005，31006，31007，31008，31009
         */
        self.musicIDTextField.text = "31001"
        self.alarmHourTextField.text = "5"
        self.alarmMinTextField.text = "5"
        self.alrmRepeatTextField.text = "0"
        self.volumeTextField.text = "100"
        self.alarmLightSwitch.isSelected = true
        
        //小夜灯
        self.rTextField.text = "208"
        self.gTextField.text = "66"
        self.bTextField.text = "92"
        self.wTextField.text = "50"
        self.brightnessTextField.text = "50"
        self.nightLightSwitch.isSelected = true
        self.startHourTextField.text = "4"
        self.startMinTextField.text = "0"
        self.endHourTextField.text = "8"
        self.endMinTextField.text = "0"
        //        挥手
        self.gestureTextField.text = "1"
        //        悬停
        self.centerSettingTextField.text = "1"
    }
    
    
    @IBAction func previewAlarmAction(_ sender: Any) {
        
        ((sender) as! UIButton).isSelected = !(sender as! UIButton).isSelected
        
        let musicID = UInt16(self.musicIDTextField.text!)!
        let vol  = UInt8(self.volumeTextField.text!)!
        let br = UInt8(self.brightnessTextField.text!)!
        
        if (sender as! UIButton).isSelected
        {
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, startAlarmRreviewvolume: vol, brightness: br, musicID: musicID, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
                if status == SLPDataTransferStatus.succeed
                {
                    print("start preview succeed !")
                }
                else
                {
                    print("start preview failed !")
                }
            })
        }
        else
        {
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, stopAlarmRreviewTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
                if status == SLPDataTransferStatus.succeed
                {
                    print("stop preview succeed !")
                }
                else
                {
                    print("stop preview failed !")
                }
            })
            
        }
    }
    
    @IBAction func saveAlarmAction(_ sender: Any) {
        
        ///闹钟结构
        let alarmInfo:BleNoxAlarmInfo = BleNoxAlarmInfo()
        alarmInfo.alarmID = 0///闹钟编号
        alarmInfo.isOpen = self.alarmLightSwitch.isOn
        alarmInfo.hour = UInt8(self.alarmHourTextField.text!)!
        alarmInfo.minute = UInt8(self.alarmMinTextField.text!)!
        alarmInfo.repeat = UInt8(self.alrmRepeatTextField.text!)!
        alarmInfo.snoozeTime = 6
        alarmInfo.snoozeLength = 9
        alarmInfo.volume = UInt8(self.volumeTextField.text!)!
        alarmInfo.brightness =  UInt8(self.brightnessTextField.text!)!
        alarmInfo.shake = false
        alarmInfo.musicID = UInt16(self.musicIDTextField.text!)!
        alarmInfo.timestamp = UInt32(NSDate().timeIntervalSince1970)
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, alarmConfig: alarmInfo, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                print("save alarm succeed !")
            }
            else
            {
                print("save alarm failed !")
            }
        })
        
    }
    

    @IBAction func saveNightLight(_ sender: Any) {
        
        let r  = UInt8(self.rTextField.text!)
        let g  = UInt8(self.gTextField.text!)
        let b  = UInt8(self.bTextField.text!)
        let w  = UInt8(self.wTextField.text!)
        let br = UInt8(self.brightnessTextField.text!)!
        
        let enable = self.nightLightSwitch.isOn
        let start_hour = Int(self.startHourTextField.text!)!
        let start_min =  Int(self.startMinTextField.text!)!
        let end_hour = Int(self.endHourTextField.text!)!
        let end_min =  Int(self.endMinTextField.text!)!
        
        var duration = (end_hour - start_hour)*60 + end_min - start_min
        if (duration < 0){
            duration += 24*60
        }
        
        let light: SLPLight = SLPLight()
        light.r = r ?? 0
        light.g = g ?? 0
        light.b = b ?? 0
        light.w = w ?? 0
        
        let nightLightInfo:BleNoxNightLightInfo = BleNoxNightLightInfo()
        nightLightInfo.light = light
        nightLightInfo.enable = enable
        nightLightInfo.brightness = br
        nightLightInfo.startHour = UInt8(start_hour)
        nightLightInfo.startMinute = UInt8(start_min)
        nightLightInfo.duration = UInt16(duration)
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, nigthLightConfigSet: nightLightInfo, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                print("save night light succeed !")
            }
            else
            {
                print("save night light failed !")
            }
        })
    }
    
    @IBAction func saveGesture(_ sender: Any) {
        
        //挥手
        let mode = UInt8(GestureMode.wave.rawValue)
        //     0x00: 默认操作 0x01: 播放/暂停 0x02: 切歌(左上右下) 0xFF: 无操作(停用)
        let operation = UInt8(self.gestureTextField.text!)!
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, gestureConfigSet:mode, opt: operation, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?)in
            if status == SLPDataTransferStatus.succeed
            {
                print("save wave gesture succeed!")
            }
            else
            {
                print("save wave gesture failed!")
            }
        })
    }
    
    
    @IBAction func saveCenterSetting(_ sender: Any) {
        
        //悬停
        let mode = UInt8(GestureMode.hover.rawValue)
        //        操作 0x00: 默认操作 0x01: 播放/暂停  0xFF: 无操作(停用)
        let operation = UInt8(self.centerSettingTextField.text!)!
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, gestureConfigSet:mode, opt: operation, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?)in
            if status == SLPDataTransferStatus.succeed
            {
                print("save hove gesture succeed!")
            }
            else
            {
                print("save hove gesture failed!")
            }
        })
    }
    
    @IBAction func getGesture(_ sender: Any) {
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, getGestureConfigTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            let gestureList = data as! [BleNoxGestureInfo];
            if status == SLPDataTransferStatus.succeed
            {
                print("get gesture succeed!")
                for item: BleNoxGestureInfo in gestureList {
                    print("gestur-->\(item.gesture)--option--->\(item.opt)")
                }
            }
            else
            {
                print("get gesture failed!")
            }
        });
    }
    
    @IBAction func resetAction(_ sender: Any) {
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, deviceInitTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                print("reset device succeed !")
            }
            else
            {
                print("reset device failed !")
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alarmMinTextField.resignFirstResponder()
        self.alarmHourTextField.resignFirstResponder()
        self.alrmRepeatTextField.resignFirstResponder()
        self.musicIDTextField.resignFirstResponder()
        self.volumeTextField.resignFirstResponder()
        self.rTextField.resignFirstResponder()
        self.gTextField.resignFirstResponder()
        self.bTextField.resignFirstResponder()
        self.wTextField.resignFirstResponder()
        self.brightnessTextField.resignFirstResponder()
        self.startHourTextField.resignFirstResponder()
        self.startMinTextField.resignFirstResponder()
        self.endHourTextField.resignFirstResponder()
        self.endMinTextField.resignFirstResponder()
        self.centerSettingTextField.resignFirstResponder()
        self.gestureTextField.resignFirstResponder()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

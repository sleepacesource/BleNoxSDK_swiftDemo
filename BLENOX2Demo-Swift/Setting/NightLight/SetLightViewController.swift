//
//  SetLightViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/17.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class SetLightViewController: UIViewController {
    var r: UInt8?
    var g: UInt8?
    var b: UInt8?
    var w: UInt8?
    var brightness: UInt8?
    
    @IBOutlet weak var colorRTextField: UITextField!
    @IBOutlet weak var colorGTextField: UITextField!
    @IBOutlet weak var colorBTextField: UITextField!
    @IBOutlet weak var colorWTextField: UITextField!
    @IBOutlet weak var brightnessTextFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func sendColorAction(_ sender: UIButton) {
        let valueR = self.colorRTextField.text!.count > 0
        let valueG = self.colorGTextField.text!.count > 0
        let valueB = self.colorBTextField.text!.count > 0
        let valueW = self.colorWTextField.text!.count > 0
        if valueR && valueG && valueB && valueW {
            let r = Int(self.colorRTextField.text!)
            let g = Int(self.colorGTextField.text!)
            let b = Int(self.colorBTextField.text!)
            let w = Int(self.colorWTextField.text!)
            
            let rValid = (r! >= 0) && (r! <= 255);
            let gValid = (g! >= 0) && (g! <= 255);
            let bValid = (b! >= 0) && (b! <= 255);
            let wValid = (w! >= 0) && (w! <= 255);
            if !(rValid && gValid && bValid && wValid)  {
                Utils.showMessage("请输入0-255之间的整数", controller: self)
                return
            }
            
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
                Utils.showMessage("手机蓝牙未打开", controller: self);
                return
            }
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOnColorLight: light, brightness: brightness, timeout: 0, callback: { (status: SLPDataTransferStatus, data:Any?) in
                if status != SLPDataTransferStatus.succeed {
                    Utils.showDeviceOperationFailed(-1, at: self)
                    return
                }
            })
        } else {
            Utils.showMessage("请输入0-255之间的整数", controller: self)
        }
    }
    
    @IBAction func sendBrightnessAction(_ sender: UIButton) {
        let valueBrightness = self.brightnessTextFiled.text!.count > 0
        if valueBrightness {
            let brightness = UInt8(self.brightnessTextFiled.text!)
            if (!(brightness! >= 0) && (brightness! <= 100)) {
                Utils.showMessage("请输入0-100之间的整数", controller: self)
                return
            }
            
            let isOpen = SLPBLEManager.shared()?.blueToothIsOpen()
            if !(isOpen!) {
                Utils.showMessage("手机蓝牙未打开", controller: self);
                return
            }
            
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, lightBrightness: brightness!, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
                if status != SLPDataTransferStatus.succeed {
                    Utils.showDeviceOperationFailed(-1, at: self)
                    return
                }
            })
        } else {
            Utils.showMessage("请输入0-100之间的整数", controller: self)
        }
    }
}

//
//  SetLightViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/17.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

typealias SetLightBlock = (UInt8, UInt8, UInt8, UInt8, UInt8)->()

class SetLightViewController: UIViewController {
    var r: UInt8?
    var g: UInt8?
    var b: UInt8?
    var w: UInt8?
    var brightness: UInt8?
    
    var setLightBlock: SetLightBlock?
    
    var fromMode = 0    // 0： from小夜灯   1: from定时任务,且模式为助眠模式
    
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var colorRTextField: UITextField!
    @IBOutlet weak var colorGTextField: UITextField!
    @IBOutlet weak var colorBTextField: UITextField!
    @IBOutlet weak var colorWTextField: UITextField!
    @IBOutlet weak var brightnessTextFiled: UITextField!
    @IBOutlet weak var sendBtn1: UIButton!
    
    @IBOutlet weak var sendBtn2: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()

        self.colorLabel.text = NSLocalizedString("color", comment: "")
        self.brightnessLabel.text = NSLocalizedString("luminance", comment: "")
        self.sendBtn1.setTitle(NSLocalizedString("send", comment: ""), for: UIControl.State.normal)
        self.sendBtn2.setTitle(NSLocalizedString("send", comment: ""), for: UIControl.State.normal)
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        rightButton.setTitle(NSLocalizedString("save", comment: ""), for: UIControl.State.normal)
        rightButton.addTarget(self, action: #selector(rightClick), for: UIControl.Event.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    func setUI() -> Void {
        if self.fromMode == 1 {
            self.colorRTextField.isEnabled = false
            self.colorBTextField.isEnabled = false
            self.colorWTextField.isEnabled = false
            
            self.colorRTextField.backgroundColor = UIColor.lightGray
            self.colorBTextField.backgroundColor = UIColor.lightGray
            self.colorWTextField.backgroundColor = UIColor.lightGray
            
            self.colorGTextField.placeholder = NSLocalizedString("0~255", comment: "")
        }
        
        if self.r != nil {
            self.colorRTextField.text = String(format: "%d", self.r!)
        }
        
        if self.g != nil {
            self.colorGTextField.text = String(format: "%d", self.g!)
        }
        
        if self.b != nil {
            self.colorBTextField.text = String(format: "%d", self.b!)
        }
        
        if self.w != nil {
            self.colorWTextField.text = String(format: "%d", self.w!)
        }
        
        if self.brightness != nil {
            self.brightnessTextFiled.text = String(format: "%d", self.brightness!)
        }
    }
    
    @objc func rightClick() ->Void {
        let r = Int(self.colorRTextField.text!)
        let g = Int(self.colorGTextField.text!)
        let b = Int(self.colorBTextField.text!)
        let w = Int(self.colorWTextField.text!)
        let brightness = UInt8(self.brightnessTextFiled.text!)
        if r != nil && g != nil && b != nil && w != nil && brightness != nil {
            
            let rValid = (r! >= 0) && (r! <= 255);
            var gValid = (g! >= 0) && (g! <= 255);
            if self.fromMode == 1 {
                gValid = (g! >= 0) && (g! <= 120);
            }
            let bValid = (b! >= 0) && (b! <= 255);
            let wValid = (w! >= 0) && (w! <= 255);
            if !(rValid && gValid && bValid && wValid)  {
                Utils.showMessage(NSLocalizedString("input_0_255", comment: ""), controller: self)
                return
            }
            
            if (!(brightness! >= 0) && (brightness! <= 100)) {
                Utils.showMessage(NSLocalizedString("input_0_100", comment: ""), controller: self)
                return
            }
            
            self.r = UInt8(r!)
            self.g = UInt8(g!)
            self.b = UInt8(b!)
            self.w = UInt8(w!)
            self.brightness = UInt8(brightness!)
        } else {
            Utils.showMessage(NSLocalizedString("input_0_255", comment: ""), controller: self)
        }
        self.setLightBlock!(self.r!, self.g!, self.b!, self.w!, self.brightness!)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func sendColorAction(_ sender: UIButton) {
        let r = Int(self.colorRTextField.text!)
        let g = Int(self.colorGTextField.text!)
        let b = Int(self.colorBTextField.text!)
        let w = Int(self.colorWTextField.text!)
        if r != nil && g != nil && b != nil && w != nil {
            
            let rValid = (r! >= 0) && (r! <= 255);
            var gValid = (g! >= 0) && (g! <= 255);
            if self.fromMode == 1 {
                gValid = (g! >= 0) && (g! <= 120);
                
                if !gValid {
                    Utils.showMessage(NSLocalizedString("input_0_120", comment: ""), controller: self)
                    return
                }
            }
            let bValid = (b! >= 0) && (b! <= 255);
            let wValid = (w! >= 0) && (w! <= 255);
            if !(rValid && gValid && bValid && wValid)  {
                Utils.showMessage(NSLocalizedString("input_0_255", comment: ""), controller: self)
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
                Utils.showMessage(NSLocalizedString("phone_bluetooth_not_open", comment: ""), controller: self);
                return
            }
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOnColorLight: light, brightness: brightness, timeout: 0, callback: { (status: SLPDataTransferStatus, data:Any?) in
                if status != SLPDataTransferStatus.succeed {
                    Utils.showDeviceOperationFailed(-1, at: self)
                    return
                }
                
                self.r = UInt8(r!)
                self.g = UInt8(g!)
                self.b = UInt8(b!)
                self.w = UInt8(w!)
                self.brightness = UInt8(brightness)
//                self.setLightBlock!(self.r!, self.g!, self.b!, self.w!, self.brightness!)
            })
        } else {
            Utils.showMessage(NSLocalizedString("input_0_255", comment: ""), controller: self)
        }
    }
    
    @IBAction func sendBrightnessAction(_ sender: UIButton) {
        let valueBrightness = self.brightnessTextFiled.text!.count > 0
        if valueBrightness {
            let brightness = Int(self.brightnessTextFiled.text!)
            if (brightness! <= 0 || brightness! >= 100) {
                Utils.showMessage(NSLocalizedString("input_0_100", comment: ""), controller: self)
                return
            }
            
//            brightness = UInt8(brightness!)
            
            let isOpen = SLPBLEManager.shared()?.blueToothIsOpen()
            if !(isOpen!) {
                Utils.showMessage(NSLocalizedString("phone_bluetooth_not_open", comment: ""), controller: self);
                return
            }
            
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, lightBrightness: UInt8(brightness!), timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
                if status != SLPDataTransferStatus.succeed {
                    Utils.showDeviceOperationFailed(-1, at: self)
                    return
                }
                
                self.brightness = UInt8(brightness!)
//                self.setLightBlock!(self.r!, self.g!, self.b!, self.w!, self.brightness!)
            })
        } else {
            Utils.showMessage(NSLocalizedString("input_0_100", comment: ""), controller: self)
        }
    }
}

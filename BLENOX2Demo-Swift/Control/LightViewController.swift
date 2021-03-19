//
//  LightViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by San on 12/9/2019.
//  Copyright © 2019 medica. All rights reserved.
//

import UIKit
class LightViewController: UIViewController {
    @IBOutlet weak var colorTitleLabel: UILabel!
    
    @IBOutlet weak var rText: UITextField!
    @IBOutlet weak var gText: UITextField!
    @IBOutlet weak var bText: UITextField!
    @IBOutlet weak var wText: UITextField!
    @IBOutlet weak var brightnessText: UITextField!
    
    @IBOutlet weak var brightnessLabel: UILabel!
    @IBOutlet weak var sendBT1: UIButton!
    @IBOutlet weak var sendBT2: UIButton!
    @IBOutlet weak var closeBT: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUI();
        
    }

    func setUI() -> Void {
        
        self.sendBT1.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.sendBT1.layer.cornerRadius = 2.0;
        self.sendBT1.layer.masksToBounds = true;
        self.sendBT1.setTitle(NSLocalizedString("send", comment: ""), for: UIControl.State.normal)
        
        self.sendBT2.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.sendBT2.layer.cornerRadius = 2.0;
        self.sendBT2.layer.masksToBounds = true;
        self.sendBT2.setTitle(NSLocalizedString("send", comment: ""), for: UIControl.State.normal)
        
        self.closeBT.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.closeBT.layer.cornerRadius = 2.0;
        self.closeBT.layer.masksToBounds = true;
        self.closeBT.setTitle(NSLocalizedString("turn_off", comment: ""), for: UIControl.State.normal)
        
        self.colorTitleLabel.text = NSLocalizedString("color", comment: "")
        self.brightnessLabel.text = NSLocalizedString("luminance", comment: "")
        
        ///default value(example)
        self.rText.text = "50"
        self.gText.text = "50"
        self.bText.text = "50"
        self.wText.text = "1"
        self.brightnessText.text = "50"

    }
    
    
    @IBAction func changeColor(_ sender: Any) {
        let r  = UInt8(self.rText.text!)
        let g  = UInt8(self.gText.text!)
        let b  = UInt8(self.bText.text!)
        let w  = UInt8(self.wText.text!)
        let br = UInt8(self.brightnessText.text!)!

        let light: SLPLight = SLPLight()
        light.r = r ?? 0
        light.g = g ?? 0
        light.b = b ?? 0
        light.w = w ?? 0
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOnColorLight: light, brightness: br, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                print("change color succeed !")
            }
            else
            {
                print("change color failed !")
            }
        })
    }
    
    @IBAction func changeBrightness(_ sender: Any) {
        
        let r  = UInt8(self.rText.text!)
        let g  = UInt8(self.gText.text!)
        let b  = UInt8(self.gText.text!)
        let w  = UInt8(self.wText.text!)
        let br = UInt8(self.brightnessText.text!)!
        
        let light: SLPLight = SLPLight()
        light.r = r ?? 0
        light.g = g ?? 0
        light.b = b ?? 0
        light.w = w ?? 0
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOnColorLight: light, brightness: br, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                print("change brightness succeed !")
            }
            else
            {
                print("change brightness failed !")
            }
        })
    }
    
    
    @IBAction func closeLight(_ sender: Any) {
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOffLightTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                print("close succeed !")
            }
            else
            {
               print("close failed !")
            }
        })
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.endEditing(true)
    }
}

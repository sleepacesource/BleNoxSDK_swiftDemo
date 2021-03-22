//
//  CustomColorViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/18.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class CustomColorViewController: UIViewController {
    
    // 颜色1
    @IBOutlet weak var color1Label: UILabel!
    @IBOutlet weak var color1R: UITextField!
    @IBOutlet weak var color1G: UITextField!
    @IBOutlet weak var color1B: UITextField!
    @IBOutlet weak var color1W: UITextField!
    @IBOutlet weak var color1Send: UIButton!
    @IBOutlet weak var color1Clean: UIButton!
    
    // 颜色2
    @IBOutlet weak var color2Label: UILabel!
    @IBOutlet weak var color2R: UITextField!
    @IBOutlet weak var color2G: UITextField!
    @IBOutlet weak var color2B: UITextField!
    @IBOutlet weak var color2W: UITextField!
    @IBOutlet weak var color2Send: UIButton!
    @IBOutlet weak var color2Clean: UIButton!
    
    // 颜色3
    @IBOutlet weak var color3Label: UILabel!
    @IBOutlet weak var color3R: UITextField!
    @IBOutlet weak var color3G: UITextField!
    @IBOutlet weak var color3B: UITextField!
    @IBOutlet weak var color3W: UITextField!
    @IBOutlet weak var color3Send: UIButton!
    @IBOutlet weak var color3Clean: UIButton!
    
    // 颜色4
    @IBOutlet weak var color4Label: UILabel!
    @IBOutlet weak var color4R: UITextField!
    @IBOutlet weak var color4G: UITextField!
    @IBOutlet weak var color4B: UITextField!
    @IBOutlet weak var color4W: UITextField!
    @IBOutlet weak var color4Send: UIButton!
    @IBOutlet weak var color4Clean: UIButton!
    
    // 颜色5
    @IBOutlet weak var color5Label: UILabel!
    @IBOutlet weak var color5R: UITextField!
    @IBOutlet weak var color5G: UITextField!
    @IBOutlet weak var color5B: UITextField!
    @IBOutlet weak var color5W: UITextField!
    @IBOutlet weak var color5Send: UIButton!
    @IBOutlet weak var color5Clean: UIButton!
    
    // 颜色6
    @IBOutlet weak var color6Label: UILabel!
    @IBOutlet weak var color6R: UITextField!
    @IBOutlet weak var color6G: UITextField!
    @IBOutlet weak var color6B: UITextField!
    @IBOutlet weak var color6W: UITextField!
    @IBOutlet weak var color6Send: UIButton!
    @IBOutlet weak var color6Clean: UIButton!
    
    // 颜色7
    @IBOutlet weak var color7Label: UILabel!
    @IBOutlet weak var color7Lum: UILabel!
    
    var cleaned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
    }
    
    func setUI() -> Void {
        self.color1Label.text = String(format: "%@ 1", NSLocalizedString("color", comment: ""))
        self.color2Label.text = String(format: "%@ 2", NSLocalizedString("color", comment: ""))
        self.color3Label.text = String(format: "%@ 3", NSLocalizedString("color", comment: ""))
        self.color4Label.text = String(format: "%@ 4", NSLocalizedString("color", comment: ""))
        self.color5Label.text = String(format: "%@ 5", NSLocalizedString("color", comment: ""))
        self.color6Label.text = String(format: "%@ 6", NSLocalizedString("color", comment: ""))
        self.color7Label.text = String(format: "%@ 7(%@)", NSLocalizedString("color", comment: ""), NSLocalizedString("noCustom", comment: ""))
        
        self.color7Lum.text = NSLocalizedString("liuguang", comment: "")
        
        self.color1Send.setTitle(NSLocalizedString("预览", comment: ""), for: UIControl.State.normal)
        self.color2Send.setTitle(NSLocalizedString("预览", comment: ""), for: UIControl.State.normal)
        self.color3Send.setTitle(NSLocalizedString("预览", comment: ""), for: UIControl.State.normal)
        self.color4Send.setTitle(NSLocalizedString("预览", comment: ""), for: UIControl.State.normal)
        self.color5Send.setTitle(NSLocalizedString("预览", comment: ""), for: UIControl.State.normal)
        self.color6Send.setTitle(NSLocalizedString("预览", comment: ""), for: UIControl.State.normal)
        
        self.color1Clean.setTitle(NSLocalizedString("cleanColor", comment: ""), for: UIControl.State.normal)
        self.color2Clean.setTitle(NSLocalizedString("cleanColor", comment: ""), for: UIControl.State.normal)
        self.color3Clean.setTitle(NSLocalizedString("cleanColor", comment: ""), for: UIControl.State.normal)
        self.color4Clean.setTitle(NSLocalizedString("cleanColor", comment: ""), for: UIControl.State.normal)
        self.color5Clean.setTitle(NSLocalizedString("cleanColor", comment: ""), for: UIControl.State.normal)
        self.color6Clean.setTitle(NSLocalizedString("cleanColor", comment: ""), for: UIControl.State.normal)
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        rightButton.setTitle(NSLocalizedString("save", comment: ""), for: UIControl.State.normal)
        rightButton.addTarget(self, action: #selector(rightClick), for: UIControl.Event.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc func rightClick() -> Void {
        
    }
    
    func cleanColor(_ colorId: Int) -> Void {
        
    }
    
    func sendColor(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ w: UInt8, _ colorId: Int) -> Void {
        
    }
    
    @IBAction func sendColor1(_ sender: Any) {
        self.sendColor(0, 0, 0, 0, 0)
    }
    
    @IBAction func cleanColor1(_ sender: Any) {
        if !self.cleaned {
            self.cleaned = true
            return
        }
        
        self.cleanColor(0)
    }
    
    
    @IBAction func sendColor2(_ sender: Any) {
        self.sendColor(0, 0, 0, 0, 1)
    }
    
    @IBAction func cleanColor2(_ sender: Any) {
        if !self.cleaned {
            self.cleaned = true
            return
        }
        
        self.cleanColor(1)
    }
    
    @IBAction func sendColor3(_ sender: Any) {
        self.sendColor(0, 0, 0, 0, 2)
    }
    
    @IBAction func cleanColor3(_ sender: Any) {
        if !self.cleaned {
            self.cleaned = true
            return
        }
        
        self.cleanColor(2)
    }
    
    @IBAction func sendColor4(_ sender: Any) {
        self.sendColor(0, 0, 0, 0, 3)
    }
    
    @IBAction func cleanColor4(_ sender: Any) {
        if !self.cleaned {
            self.cleaned = true
            return
        }
        
        self.cleanColor(3)
    }
    
    @IBAction func sendColor5(_ sender: Any) {
        self.sendColor(0, 0, 0, 0, 4)
    }
    
    @IBAction func cleanColor5(_ sender: Any) {
        if !self.cleaned {
            self.cleaned = true
            return
        }
        
        self.cleanColor(4)
    }
    
    @IBAction func sendColor6(_ sender: Any) {
        self.sendColor(0, 0, 0, 0, 5)
    }
    
    @IBAction func cleanColor6(_ sender: Any) {
        if !self.cleaned {
            self.cleaned = true
            return
        }
        
        self.cleanColor(5)
    }
}

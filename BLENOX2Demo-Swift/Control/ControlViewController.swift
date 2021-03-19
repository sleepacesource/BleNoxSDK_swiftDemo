//
//  ControlViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by San on 12/9/2019.
//  Copyright © 2019 medica. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController {

    @IBOutlet weak var light: CustomStyleButton!
    @IBOutlet weak var aid: CustomStyleButton!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var topBGView: UIView!
    
    var currentButton: CustomStyleButton!
    var selectedController: UIViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUI();
    }
    
    func setUI() -> Void {
        self.topBGView.layer.masksToBounds = true;
        self.topBGView.layer.borderColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0).cgColor;
        self.topBGView.layer.borderWidth = 1.0;
        self.topBGView.layer.cornerRadius = 5.0;
        
        self.light.setTitleColor(UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0), for:UIControl.State.normal)
        self.aid.setTitleColor(UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0), for: UIControl.State.normal)

        self.light.selectedColor = UIColor.white
        self.light.normalColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.aid.selectedColor = UIColor.white
        self.aid.normalColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        
        self.light.isSelected = true
        self.currentButton = self.light
        self.showLightPage()
        
        self.light.setTitle(NSLocalizedString("light", comment: ""), for: UIControl.State.normal)
        self.aid.setTitle(NSLocalizedString("sleep_aid", comment: ""), for: UIControl.State.normal)
    }
    
    @IBAction func showLight(_ sender: Any) {
        if (sender as! CustomStyleButton) != self.currentButton {
            self.currentButton.isSelected = false
            (sender as! CustomStyleButton).isSelected = true
            self.currentButton = (sender as! CustomStyleButton)
            self.showLightPage()
        }
    }
    
    @IBAction func showAid(_ sender: Any) {
        if (sender as! CustomStyleButton) != self.currentButton {
            self.currentButton.isSelected = false
            (sender as! CustomStyleButton).isSelected = true
            self.currentButton = (sender as! CustomStyleButton)
            self.showAidPage()
        }
    }
    
    
    func showLightPage() -> Void {
        let sectionVC = LightViewController()

        if (self.selectedController != nil) {
            self.selectedController.willMove(toParent: nil);
            self.selectedController.view.removeFromSuperview()
            self.selectedController.removeFromParent()
            self.selectedController = nil
        }
        
        sectionVC.willMove(toParent: self)
        self.addChild(sectionVC)
        self.content.addSubview(sectionVC.view)
        sectionVC.didMove(toParent: self)
        self.selectedController = sectionVC
        
        let testView = sectionVC.view
        testView?.translatesAutoresizingMaskIntoConstraints = false
        testView?.topAnchor.constraint(equalTo: self.content.topAnchor, constant: 0).isActive = true  //顶部约束
        testView?.leadingAnchor.constraint(equalTo: self.content.leadingAnchor, constant: 0).isActive = true  //左端约束
        testView?.trailingAnchor.constraint(equalTo: self.content.trailingAnchor, constant: 0).isActive = true  //右端约束
        testView?.bottomAnchor.constraint(equalTo: self.content.bottomAnchor, constant: 0).isActive = true  //底部约束
    }
    
    
    func showAidPage() -> Void {
        let sectionVC = SleepAidViewController()
        
        if (self.selectedController != nil) {
            self.selectedController.willMove(toParent: nil);
            self.selectedController.view.removeFromSuperview()
            self.selectedController.removeFromParent()
            self.selectedController = nil
        }
        
        sectionVC.willMove(toParent: self)
        self.addChild(sectionVC)
        self.content.addSubview(sectionVC.view)
        sectionVC.didMove(toParent: self)
        self.selectedController = sectionVC
        
        let testView = sectionVC.view
        testView?.translatesAutoresizingMaskIntoConstraints = false
        testView?.topAnchor.constraint(equalTo: self.content.topAnchor, constant: 0).isActive = true  //顶部约束
        testView?.leadingAnchor.constraint(equalTo: self.content.leadingAnchor, constant: 0).isActive = true  //左端约束
        testView?.trailingAnchor.constraint(equalTo: self.content.trailingAnchor, constant: 0).isActive = true  //右端约束
        testView?.bottomAnchor.constraint(equalTo: self.content.bottomAnchor, constant: 0).isActive = true  //底部约束
    }
}

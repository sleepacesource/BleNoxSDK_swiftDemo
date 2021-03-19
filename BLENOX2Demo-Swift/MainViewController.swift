//
//  MainViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by San on 12/9/2019.
//  Copyright © 2019 medica. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addChildVC(childVC: DeviceViewController(), title: NSLocalizedString("device", comment: ""), index: 0)
        self.addChildVC(childVC: ControlViewController(), title: NSLocalizedString("control", comment: ""), index: 1)
        self.addChildVC(childVC: SettingViewController(), title: NSLocalizedString("setting", comment: ""), index: 2)
        
    }

    func addChildVC(childVC:UIViewController,title:String,index:Int) {
        let navigation = UINavigationController(rootViewController: childVC)
        childVC.title = title
        childVC.tabBarItem.tag = index
        self.addChild(navigation)
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

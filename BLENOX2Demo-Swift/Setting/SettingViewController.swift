//
//  SettingViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by San on 12/9/2019.
//  Copyright © 2019 medica. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceConnected), name: NSNotification.Name(rawValue: kNotificationNameBLEDeviceConnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDisConnected), name: NSNotification.Name(rawValue: kNotificationNameBLEDeviceDisconnect), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showConnected(connected: DataManager.shared().connected)
    }
    
    @objc func deviceConnected() {
        DataManager.shared()?.connected = true
        self.showConnected(connected: true)
    }
    
    @objc func deviceDisConnected() {
        DataManager.shared()?.connected = false
        self.showConnected(connected: false)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showConnected(connected: Bool) -> Void {
        let alpha = connected ? 1: 0.3
        self.view.alpha = CGFloat(alpha)
        self.view.isUserInteractionEnabled = connected
    }
    
    func setUI() -> Void {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "testCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell==nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell?.textLabel?.text = NSLocalizedString("alarm", comment: "")
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = NSLocalizedString("nightLight", comment: "")
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = NSLocalizedString("timeMission", comment: "")
            } else if indexPath.row == 3 {
                cell?.textLabel?.text = NSLocalizedString("delayClose", comment: "")
            }
        } else if (indexPath.section == 1) {
            if indexPath.row == 0 {
                cell?.textLabel?.text = NSLocalizedString("Wave", comment: "")
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = NSLocalizedString("Hover", comment: "")
            }
        }
        
        cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return NSLocalizedString("setGesture", comment: "")
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.goAlarmPage()
            } else if indexPath.row == 1 {
                self.goNightLightPage()
            } else if indexPath.row == 2 {
                self.goTimeMissionPage()
            } else if indexPath.row == 3 {
                self.goCountDownPage()
            }
        } else {
            if indexPath.row == 0 {
                self.goWavePage()
            } else if indexPath.row == 1 {
                self.goHoverPage()
            }
        }
    }
    
    // 闹钟页面
    func goAlarmPage() -> Void {
        let searchVC = AlarmViewController ()
        searchVC.title = NSLocalizedString("alarm", comment: "")
        searchVC.addAlarmID = UInt64(NSDate().timeIntervalSince1970)
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 小夜灯页面
    func goNightLightPage() -> Void {
        let searchVC = NightLightViewController ()
        searchVC.title = NSLocalizedString("nightLight", comment: "")
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 定时任务页面
    func goTimeMissionPage() -> Void {
        let searchVC = TimeMissionListViewController ()
        searchVC.title = NSLocalizedString("timeMission", comment: "")
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 倒计时页面
    func goCountDownPage() -> Void {
        let picker = Bundle.main.loadNibNamed("HourMinutePicker", owner: nil, options: nil)?.first as! HourMinutePicker
        picker.show(in: UIApplication.shared.keyWindow!, hour: 3) { (hour) in
            
        } cancelHandle: {
            
        }

    }
    
    // 挥手页面
    func goWavePage() -> Void {
        let vc = GestureViewController ()
        vc.title = NSLocalizedString("Wave", comment: "")
        vc.mode = GestureMode.wave
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 悬停页面
    func goHoverPage() -> Void {
        let vc = GestureViewController ()
        vc.title = NSLocalizedString("Hover", comment: "")
        vc.mode = GestureMode.hover
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

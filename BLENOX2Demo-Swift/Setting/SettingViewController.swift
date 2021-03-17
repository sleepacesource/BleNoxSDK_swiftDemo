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
                cell?.textLabel?.text = "闹钟"
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "小夜灯"
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = "定时任务"
            } else if indexPath.row == 3 {
                cell?.textLabel?.text = "倒计时"
            }
        } else if (indexPath.section == 1) {
            if indexPath.row == 0 {
                cell?.textLabel?.text = "挥手"
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "悬停"
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
            return "手势设置"
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
        searchVC.title = "闹钟"
        searchVC.addAlarmID = UInt64(NSDate().timeIntervalSince1970)
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 小夜灯页面
    func goNightLightPage() -> Void {
        let searchVC = NightLightViewController ()
        searchVC.title = "小夜灯"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 定时任务页面
    func goTimeMissionPage() -> Void {
        let searchVC = TimeMissionListViewController ()
        searchVC.title = "定时任务"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 倒计时页面
    func goCountDownPage() -> Void {
        let searchVC = CountDownViewController ()
        searchVC.title = "倒计时"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 挥手页面
    func goWavePage() -> Void {
        let searchVC = GestureViewController ()
        searchVC.title = "挥手"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    // 悬停页面
    func goHoverPage() -> Void {
        let searchVC = GestureViewController ()
        searchVC.title = "悬停"
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

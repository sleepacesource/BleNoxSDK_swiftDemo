//
//  SettingViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by San on 12/9/2019.
//  Copyright © 2019 medica. All rights reserved.
//

import UIKit

let kRESETDEVICENOTIFICATION = "kRESETDEVICENOTIFICATION"

class SettingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceConnected), name: NSNotification.Name(rawValue: kNotificationNameBLEDeviceConnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDisConnected), name: NSNotification.Name(rawValue: kNotificationNameBLEDeviceDisconnect), object: nil)
    }
    
    func initData() -> Void {
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, getTimeMissionListTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed {
                DataManager.shared()?.timeMissionList = data as? [BleNoxTimeMission]
            }
        })
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, getAlarmListTimeout: 0, completion: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed {
                DataManager.shared()?.alarmList = data as? [BleNoxAlarmInfo]
            }
        })
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, getDelayCloseInfoTimeout: 0, completion: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed {
                let delayTime = data as! NSNumber
                DataManager.shared()?.delayTime = delayTime.uint16Value
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showConnected(connected: DataManager.shared().connected)
        
        self.initData()
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 104
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        if section == 1 {
            let btn = UIButton()
            btn.addTarget(self, action: #selector(resetDevice), for: UIControl.Event.touchUpInside)
            btn.setTitle(NSLocalizedString("factory_reset", comment: ""), for: UIControl.State.normal)
            view.addSubview(btn)
            btn.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
            btn.layer.cornerRadius = 2.0;
            btn.layer.masksToBounds = true;
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true  //顶部约束
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true  //左端约束
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true  //右端约束
            btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true  //底部约束
        }
        
        return view
    }
    
    @objc func resetDevice() -> Void {
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, deviceInitTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if (status != SLPDataTransferStatus.succeed) {
                Utils.showDeviceOperationFailed(-1, at: self)
            }else{
                DataManager.shared()?.reset()
                
                Utils.showMessage(NSLocalizedString("factory_reset_send", comment: ""), controller: self)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kRESETDEVICENOTIFICATION), object: nil)
            }
        })
    }
    
    // 闹钟页面
    func goAlarmPage() -> Void {
        let vc = AlarmListViewController()
        vc.title = NSLocalizedString("alarm", comment: "")
        self.navigationController?.pushViewController(vc, animated: true)
//        let searchVC = AlarmViewController ()
//        searchVC.title = NSLocalizedString("alarm", comment: "")
//        searchVC.addAlarmID = UInt64(NSDate().timeIntervalSince1970)
//        self.navigationController?.pushViewController(searchVC, animated: true)
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
        let dataList = ["关闭", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6"];
        
        let delayTime = DataManager.shared().delayTime
        let minuteList: Array<UInt16> = [0, 30, 60, 90, 120, 150,180, 210, 240, 270, 300, 330, 360]
        
        var selectedRow = 0
        for i in 0..<minuteList.count {
            let minute = minuteList[i]
            if minute == delayTime {
                selectedRow = i
                break
            }
        }
        let picker = Bundle.main.loadNibNamed("HourMinutePicker", owner: nil, options: nil)?.first as! HourMinutePicker
        picker.show(in: UIApplication.shared.keyWindow!, selectedRow: selectedRow, dataList: dataList) { (selectedRow) in
            let selectedValue = minuteList[selectedRow]
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, delayCloseTimeConfig: selectedValue, timeout: 0, completion: { (status: SLPDataTransferStatus, data: Any?) in
                if (status == SLPDataTransferStatus.succeed) {
                    DataManager.shared()?.delayTime = selectedValue
                    Utils.showMessage("设置成功", controller: self)
                } else {
                    Utils.showDeviceOperationFailed(-1, at: self)
                }
            })
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

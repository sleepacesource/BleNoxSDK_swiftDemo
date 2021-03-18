//
//  NightLightViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/16.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

class NightLightViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var enable: Bool?
    
    var startHour: UInt8?
    var startMinute: UInt8?
    
    var endHour: UInt8?
    var endMinute: UInt8?
    
    var r: UInt8?
    var g: UInt8?
    var b: UInt8?
    var w: UInt8?
    var brightness: UInt8?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        
        self.initData()
    }
    
    func initData() -> Void {
        self.enable = DataManager.shared()?.nightLightInfo.enable;
        
        self.startHour = DataManager.shared()?.nightLightInfo.startHour;
        self.startMinute = DataManager.shared()?.nightLightInfo.startMinute;
        
        var duration: UInt16?
        duration = DataManager.shared()?.nightLightInfo.duration
        
        let time = UInt16(self.startHour!) * 60 + UInt16(self.startMinute!) + duration!
        var hour = UInt8(time / 60);
        if (hour >= 24) {
            hour = hour - 24;
        }
        
        let minute = UInt8(time % 60);
        
        self.endHour = hour;
        self.endMinute = minute;
        
        self.r = DataManager.shared()?.nightLightInfo.light.r;
        self.g = DataManager.shared()?.nightLightInfo.light.g;
        self.b = DataManager.shared()?.nightLightInfo.light.b;
        self.w = DataManager.shared()?.nightLightInfo.light.w;
        self.brightness = DataManager.shared()?.nightLightInfo.brightness;
    }
    
    func setUI() -> Void {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        rightButton.setTitle("保存", for: UIControl.State.normal)
        rightButton.addTarget(self, action: #selector(rightClick), for: UIControl.Event.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc func rightClick() ->Void {
        let info = BleNoxNightLightInfo.init()
        
        let light = SLPLight.init()
        light.r = self.r!
        light.g = self.g!
        light.b = self.b!
        light.w = self.w!
        info.enable = self.enable!;
        info.brightness = self.brightness!;
        info.startHour = self.startHour!;
        info.startMinute = self.startMinute!;
        
        var duration = (Int(self.endHour!) - Int(self.startHour!))*60 + Int(self.endMinute!) - Int(self.startMinute!)
        if duration < 0 {
            duration += 24*60;
        }
        info.duration = UInt16(duration);
        
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, nigthLightConfigSet: info, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status != SLPDataTransferStatus.succeed {
                Utils.showDeviceOperationFailed(-1, at: self)
                return
            }
            
            self.navigationController?.popViewController(animated: true)
            
            SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOffLightTimeout: 0, callback: { (status:SLPDataTransferStatus, data: Any?) in
                
            })
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.enable! {
            return 3
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if indexPath.row == 0 {
            tableView.register(UINib(nibName: "SwtichTableViewCell", bundle: nil), forCellReuseIdentifier: "SwtichTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "SwtichTableViewCell") as! SwtichTableViewCell
            normalCell.titleLabel?.text = "小夜灯"
            normalCell.switcher.isOn = self.enable!
            normalCell.switcherBlock = {(switcher) ->() in
                if switcher.isOn {
                    self.enable = true
                    self.tableView.reloadData()
                } else {
                    self.enable = false
                    self.tableView.reloadData()
                }
            }
            return normalCell
        } else if indexPath.row == 1 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = "灯光设置"
            return normalCell
        } else if indexPath.row == 2 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = "时间设置"
            let startStr = String(format: "%.2d:%.2d", self.startHour!, self.startMinute!)
            let endStr = String(format: "%.2d:%.2d", self.endHour!, self.endMinute!)
            normalCell.subTitleLabel?.text = String(format: "%@-%@", startStr, endStr)
            return normalCell
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel()
        label.text = "打开后,在设定的时间范围内,将启用小夜灯的颜色和亮度"
        view.addSubview(label)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true  //顶部约束
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true  //左端约束
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true  //右端约束
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true  //底部约束
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            self.goSetLight()
        } else if indexPath.row == 2 {
            self.goSetTime()
        }
    }
    
    func goSetLight() -> Void {
        let vc = SetLightViewController()
        vc.title = "灯光设置"
        vc.r = self.r;
        vc.g = self.g;
        vc.b = self.b;
        vc.w = self.w;
        vc.brightness = self.brightness;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goSetTime() -> Void {
        let vc = SetTimeViewController()
        vc.title = "时间设置"
        vc.startHour = self.startHour;
        vc.startMinute = self.startMinute;
        vc.endHour = self.endHour;
        vc.endMinute = self.endMinute;
        
        vc.setTimeBlock = {(startHour, startMinute, endHour, endMinute) ->() in
            self.startHour = startHour;
            self.startMinute = startMinute;
            self.endHour = endHour;
            self.endMinute = endMinute;
            self.tableView.reloadData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

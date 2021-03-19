//
//  SetTimeViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/17.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

typealias SetTimeBlock = (UInt8, UInt8, UInt8, UInt8)->()

class SetTimeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, SLPTimePickerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var timePicker: SLPTimePicker!
    
    var startTimeSelected = true
    
    var endTimeSelected = false
    
    var startHour: UInt8?
    var startMinute: UInt8?
    
    var endHour: UInt8?
    var endMinute: UInt8?
    
    var setTimeBlock: SetTimeBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
    }
    
    func setUI() -> Void {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.timePicker.delegate = self
        self.timePicker.mode = SLPTimePickerMode._24Hour
        let time24 = SLPTime24.init()
        time24.hour = Int(self.startHour!)
        time24.minute = Int(self.startMinute!)
        self.timePicker.setTime(time24, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if indexPath.row == 0 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("start_time", comment: "")
            let startStr = String(format: "%.2d:%.2d", self.startHour!, self.startMinute!)
            normalCell.subTitleLabel?.text = String(format: "%@", startStr)
            return normalCell
        } else if indexPath.row == 1 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("end_time", comment: "")
            let endStr = String(format: "%.2d:%.2d", self.endHour!, self.endMinute!)
            normalCell.subTitleLabel?.text = String(format: "%@", endStr)
            return normalCell
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let time24 = SLPTime24.init()
            time24.hour = Int(self.startHour!)
            time24.minute = Int(self.startMinute!)
            self.timePicker.setTime(time24, animated: true)
            self.startTimeSelected = true
            self.endTimeSelected = false
        } else if indexPath.row == 1 {
            let time24 = SLPTime24.init()
            time24.hour = Int(self.endHour!)
            time24.minute = Int(self.endMinute!)
            self.timePicker.setTime(time24, animated: true)
            self.startTimeSelected = false
            self.endTimeSelected = true
        }
    }
    
    
    
    func slpTimePicker(_ pickerView: SLPTimePicker!, widthForComponent component: Int) -> CGFloat {
        return 80
    }
    
    func slpTimePicker(_ pickerView: SLPTimePicker!, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func slpTimerPicker(_ pickerView: SLPTimePicker!, titleFontForRow row: Int, forComponent component: Int) -> UIFont! {
        var font: UIFont?
        switch component {
        case 2:
            font = UIFont.systemFont(ofSize: 24)
        default:
            font = UIFont.systemFont(ofSize: 30)
        }
        
        return font
    }
    
    func slpTimerPicker(_ pickerView: SLPTimePicker!, titleColorForRow row: Int, forComponent component: Int) -> UIColor! {
        return Theme.c3()
    }
    
    func slpTimePickerValueChanged(_ pickerView: SLPTimePicker!) {
        let time24 = pickerView.time as! SLPTime24
        
        if self.startTimeSelected {
            self.startHour = UInt8(time24.hour)
            self.startMinute = UInt8(time24.minute)
        } else {
            self.endHour = UInt8(time24.hour)
            self.endMinute = UInt8(time24.minute)
        }
        self.tableView.reloadData()
        
        self.setTimeBlock!(self.startHour!, self.startMinute!, self.endHour!, self.endMinute!)
    }
}

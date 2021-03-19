//
//  GestureViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/16.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

enum GestureMode: UInt8 {
    case wave = 0  //挥手
    case hover = 1 //悬停
}

enum GestureActionMode: UInt8 {
    case GestureDefault = 0
    case playOrStop = 1 // 播放或暂停
    case changeMusic = 2 // 切换音乐
    case changeLight = 3 // 切换灯光
    case disable = 0xFF // 停用
}

class GestureViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var mode = GestureMode.wave
    
    var orignalGestureAction = GestureActionMode.GestureDefault
    
    var currentGestureAction: GestureActionMode?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        
        self.loadLocalData()
    }
    
    func loadLocalData() -> Void {
        switch self.mode {
        case GestureMode.wave:
            self.orignalGestureAction = GestureActionMode(rawValue: DataManager.shared().waveAction)!
        case GestureMode.hover:
            self.orignalGestureAction = GestureActionMode(rawValue: DataManager.shared().hoverAction)!
        default:
            self.orignalGestureAction = GestureActionMode(rawValue: DataManager.shared().waveAction)!
        }
        self.currentGestureAction = self.orignalGestureAction
        print(self.currentGestureAction!.rawValue)
    }
    
    func setUI() -> Void {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CellID")
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        rightButton.setTitle("保存", for: UIControl.State.normal)
        rightButton.addTarget(self, action: #selector(rightClick), for: UIControl.Event.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc func rightClick() -> Void {
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, gestureConfigSet: self.mode.rawValue, opt: self.currentGestureAction!.rawValue, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if (status != SLPDataTransferStatus.succeed) {
                Utils.showDeviceOperationFailed(-1, at: self)
                return
            }
            Utils.showMessage("保存成功", controller: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.navigationController?.popViewController(animated: true)
            }
            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.mode == GestureMode.wave {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mode == GestureMode.wave {
            if section == 0 {
                return 4
            }
            
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if self.mode == GestureMode.wave {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 1:
                    tableView.register(UINib(nibName: "SelectItemCell", bundle: nil), forCellReuseIdentifier: "SelectItemCell")
                    let selectCell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell") as! SelectItemCell
                    selectCell.titleLabel?.text = "切换灯光"
                    
                    let isCurrent = self.currentGestureAction?.rawValue == GestureActionMode.changeLight.rawValue || self.currentGestureAction?.rawValue == GestureActionMode.GestureDefault.rawValue
                    selectCell.selectIcon?.isHidden = !isCurrent
                    return selectCell
                case 2:
                    tableView.register(UINib(nibName: "SelectItemCell", bundle: nil), forCellReuseIdentifier: "SelectItemCell")
                    let selectCell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell") as! SelectItemCell
                    let isCurrent = self.currentGestureAction?.rawValue == GestureActionMode.changeMusic.rawValue
                    selectCell.selectIcon?.isHidden = !isCurrent
                    selectCell.titleLabel?.text = "切换音乐"
                    return selectCell
                case 3:
                    tableView.register(UINib(nibName: "SelectItemCell", bundle: nil), forCellReuseIdentifier: "SelectItemCell")
                    let selectCell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell") as! SelectItemCell
                    let isCurrent = self.currentGestureAction?.rawValue == GestureActionMode.disable.rawValue
                    selectCell.selectIcon?.isHidden = !isCurrent
                    selectCell.titleLabel?.text = "停用"
                    return selectCell
                default:
                    tableView.register(UINib(nibName: "SelectItemCell", bundle: nil), forCellReuseIdentifier: "SelectItemCell")
                    let titleCell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell") as! SelectItemCell
                    titleCell.titleLabel?.text = "你想左右挥手切换灯光颜色还是切换音乐？"
                    return titleCell
                   
                }
            } else if indexPath.section == 1 {
                tableView.register(UINib(nibName: "TitleArrowCell", bundle: nil), forCellReuseIdentifier: "TitleArrowCell")
                let titleCell = tableView.dequeueReusableCell(withIdentifier: "TitleArrowCell") as! TitleArrowCell
                titleCell.titleLabel?.text = "设置挥手切换的灯光颜色"
                return titleCell
            }
        } else {
            switch indexPath.row {
            case 1:
                tableView.register(UINib(nibName: "SelectItemCell", bundle: nil), forCellReuseIdentifier: "SelectItemCell")
                let selectCell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell") as! SelectItemCell
                let isCurrent = self.currentGestureAction?.rawValue == GestureActionMode.playOrStop.rawValue || self.currentGestureAction?.rawValue == GestureActionMode.GestureDefault.rawValue
                selectCell.selectIcon?.isHidden = !isCurrent
                selectCell.titleLabel?.text = "播放/暂停音乐"
                return selectCell
            case 2:
                tableView.register(UINib(nibName: "SelectItemCell", bundle: nil), forCellReuseIdentifier: "SelectItemCell")
                let selectCell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell") as! SelectItemCell
                let isCurrent = self.currentGestureAction?.rawValue == GestureActionMode.disable.rawValue
                selectCell.selectIcon?.isHidden = !isCurrent
                selectCell.titleLabel?.text = "停用"
                return selectCell
            default:
                tableView.register(UINib(nibName: "SelectItemCell", bundle: nil), forCellReuseIdentifier: "SelectItemCell")
                let titleCell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell") as! SelectItemCell
                titleCell.titleLabel?.text = "是否选择悬停在Nox前播放/暂停音乐？"
                return titleCell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.mode == GestureMode.wave {
            if indexPath.section == 0 {
                if indexPath.row == 1 {
                    self.currentGestureAction = GestureActionMode.changeLight
                } else if indexPath.row == 2 {
                    self.currentGestureAction = GestureActionMode.changeMusic
                } else if indexPath.row == 3 {
                    self.currentGestureAction = GestureActionMode.disable
                }
                tableView.reloadData()
            } else {
                self.goSetCustomLight()
            }
        } else {
            if indexPath.row == 1 {
                self.currentGestureAction = GestureActionMode.playOrStop
            } else if indexPath.row == 2 {
                self.currentGestureAction = GestureActionMode.disable
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UIScreen.main.bounds.size.width * 2 / 3
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        if section == 0 {
            let imgView = UIImageView.init()
            var imgName = "device_pic_nox2_usetutorial_page2.jpg"
            if self.mode == GestureMode.hover {
                imgName = "device_pic_nox2_handstop.jpg"
            }
            let image = UIImage.init(named: imgName)
            imgView.image = image
            view.addSubview(imgView)
            
            imgView.translatesAutoresizingMaskIntoConstraints = false
            imgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true  //顶部约束
            imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true  //左端约束
            imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true  //右端约束
            imgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true  //底部约束
        } else {
            let label = UILabel()
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true  //顶部约束
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true  //左端约束
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true  //右端约束
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true  //底部约束
            label.text = "颜色设置"
            
            view.backgroundColor = UIColor.groupTableViewBackground
        }
        
        return view
    }
    
    func goSetCustomLight() -> Void {
        let vc = CustomColorViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

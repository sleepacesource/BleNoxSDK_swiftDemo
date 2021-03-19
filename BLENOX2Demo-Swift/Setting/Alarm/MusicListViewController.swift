//
//  MusicListViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/17.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

typealias SelectMusicBlock = (UInt16)->()

class MusicListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var musicID: UInt16?
    
    var musicList: Array<MusicInfo>?
    
    var selectMusicBlock:SelectMusicBlock?
    
    var mode: UInt8 = 0

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
    }

    func setUI() -> Void {
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
//        leftButton.setTitle("返回", for: UIControl.State.normal)
        leftButton.setImage(UIImage.init(named: "common_nav_btn_back_nor"), for: UIControl.State.normal)
        leftButton.addTarget(self, action: #selector(leftClick), for: UIControl.Event.touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        // 自定义
        if self.mode != 1 {
            let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            rightButton.setTitle(NSLocalizedString("save", comment: ""), for: UIControl.State.normal)
            rightButton.addTarget(self, action: #selector(rightClick), for: UIControl.Event.touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        }
    }
    
    @objc func leftClick() -> Void {
        if self.mode != 1 {
            self.stopMusic()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightClick() -> Void {
        self.selectMusicBlock!(self.musicID!)
        self.stopMusic()
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "SelectItemCell", bundle: nil), forCellReuseIdentifier: "SelectItemCell")
        let selectCell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell") as! SelectItemCell
        let musicInfo = self.musicList![indexPath.row] as! MusicInfo
        selectCell.titleLabel?.text = musicInfo.musicName
        selectCell.selectIcon?.isHidden = !(musicInfo.musicID == self.musicID)
        return selectCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let musicInfo = self.musicList![indexPath.row] as! MusicInfo
        self.musicID = musicInfo.musicID;
        if self.mode != 1 {
            self.playMusic(self.musicID!)
        } else {
            self.selectMusicBlock!(self.musicID!)
        }
        tableView.reloadData()
    }
    
    func playMusic(_ musicID:UInt16) -> Void {
        print(musicID)
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOnMusic: musicID, volume: 16, playMode: 0, timeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                print("play music succeed !")
            }
            else
            {
                print("play music failed !")
            }
        })
    }
    
    func stopMusic() -> Void {
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, turnOffMusicTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                print("stop music succeed !")
            }
            else
            {
                print("stop music failed !")
            }
        })
    }
}

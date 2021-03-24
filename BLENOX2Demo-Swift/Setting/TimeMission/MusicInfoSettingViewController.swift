//
//  MusicInfoSettingViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/23.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

typealias MusicInfoSettingBlock = (UInt8, UInt16, UInt8) -> ()

class MusicInfoSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var playMode: UInt8?
    var musicID: UInt16?
    var volume: UInt8?
    
    var musicInfoSettingBlock: MusicInfoSettingBlock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUI()
    }
    
    func getMusicList() -> Array<MusicInfo> {
        var musicList = [MusicInfo]()
        
        var musicInfo = MusicInfo()
        musicInfo.musicID = 30001
        musicInfo.musicName = NSLocalizedString("music_list_sea", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30002
        musicInfo.musicName = NSLocalizedString("music_list_sun", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30003
        musicInfo.musicName = NSLocalizedString("music_list_dance", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30004
        musicInfo.musicName = NSLocalizedString("music_list_star", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30005
        musicInfo.musicName = NSLocalizedString("music_list_solo", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30006
        musicInfo.musicName = NSLocalizedString("music_list_rain", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30007
        musicInfo.musicName = NSLocalizedString("music_list_wind", comment: "")
        musicList.append(musicInfo)
        
        musicInfo = MusicInfo()
        musicInfo.musicID = 30008
        musicInfo.musicName = NSLocalizedString("music_list_summer", comment: "")
        musicList.append(musicInfo)
        
        return musicList
    }
    
    func setUI() -> Void {
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        rightButton.setTitle(NSLocalizedString("save", comment: ""), for: UIControl.State.normal)
        rightButton.addTarget(self, action: #selector(rightClick), for: UIControl.Event.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }

    @objc func rightClick() -> Void {
        self.musicInfoSettingBlock!(self.playMode!, self.musicID!, self.volume!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
   
    
    func getMusicName(_ musicID: UInt16) -> String {
        let musicList = self.getMusicList()
        
        var musicName = ""
        for music in musicList {
            if music.musicID == musicID {
                musicName = music.musicName!
                break
            }
        }
        
        return musicName
    }
    
    func getPlayModeStringList() -> Array<String> {
        return [NSLocalizedString("顺序循环", comment: ""), NSLocalizedString("随机播放", comment: ""), NSLocalizedString("单曲循环", comment: "")]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if indexPath.row == 0 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("循环模式", comment: "")
            let list = self.getPlayModeStringList()
            normalCell.subTitleLabel?.text = list[Int(self.playMode!)]
            return normalCell
        } else if indexPath.row == 1 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.subTitleLabel?.text = self.getMusicName(self.musicID!)
            normalCell.titleLabel?.text = NSLocalizedString("music", comment: "")
            return normalCell
        }
        else if indexPath.row == 2 {
            tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
            let normalCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            normalCell.titleLabel?.text = NSLocalizedString("volume", comment: "")
            normalCell.subTitleLabel?.text = String(format: "%d", self.volume!)
            return normalCell
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.goSelectMode()
        } else if indexPath.row == 1 {
            self.goSelectMusic()
        } else if indexPath.row == 2 {
            self.goSelectVolume()
        }
    }
    
    func goSelectVolume() -> Void {
        let minuteSelectView = Bundle.main.loadNibNamed("SLPMinuteSelectView", owner: nil, options: nil)?.first as! SLPMinuteSelectView
        var values = [Int]()
        for i in 1...16 {
            values.append(i)
        }
        minuteSelectView.iValues = values
        minuteSelectView.show(in: UIApplication.shared.keyWindow!, mode: SLPMinutePickerMode.second, time: Int(self.volume!)) { (volume) in
            self.volume = UInt8(volume)
            self.tableView.reloadData()
        } cancelHandle: {
            
        }
    }
    
    func goSelectMusic() -> Void {
        let vc = MusicListViewController()
        vc.title = NSLocalizedString("music_list", comment: "")
        let musicList = self.getMusicList()
        vc.musicList = musicList
        vc.musicID = self.musicID!
        vc.selectMusicBlock = {(musicID) ->() in
            self.musicID = musicID
            self.tableView!.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goSelectMode() -> Void {
        let picker = Bundle.main.loadNibNamed("DataPicker", owner: nil, options: nil)?.first as! DataPicker
        let list = self.getPlayModeStringList()
        picker.dataList = list
        picker.selectedRow = Int(self.playMode!)
        picker.reload()
        picker.backgroundColor = UIColor.clear
        picker.cancelBlock = {() ->() in
            picker.removeFromSuperview()
        }
        picker.confirmBlock = {(row) ->() in
            self.playMode = UInt8(row)
            self.tableView.reloadData()
        }
        Utils.addSubView(picker, suitableTo: UIApplication.shared.keyWindow)
    }
}

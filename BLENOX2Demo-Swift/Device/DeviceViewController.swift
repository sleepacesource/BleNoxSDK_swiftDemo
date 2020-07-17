//
//  DeviceViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by San on 12/9/2019.
//  Copyright © 2019 medica. All rights reserved.
//

import UIKit
import BleNox

class DeviceViewController: UIViewController {

    @IBOutlet weak var connectBt: UIButton!
    @IBOutlet weak var deviceInfoTitleLabel: UILabel!
    @IBOutlet weak var getDeviceNameBt: UIButton!
    @IBOutlet weak var getDeviceIdBt: UIButton!
    @IBOutlet weak var getVersionBt: UIButton!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceInfoLabel: UILabel!
    @IBOutlet weak var upgradeInfoTitleLabel: UILabel!
    @IBOutlet weak var deviceVersionLabel: UILabel!
    @IBOutlet weak var upgradeBt: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        先初始化蓝牙单例模块
        SLPBLEManager.shared()
        
        // Do any additional setup after loading the view.
        self.setUI()
    
     
    }
    
    func setUI() -> Void {
        self.connectBt.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.connectBt.layer.cornerRadius = 2.0;
        self.connectBt.layer.masksToBounds = true;
        self.getDeviceNameBt.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.getDeviceNameBt.layer.cornerRadius = 2.0;
        self.getDeviceNameBt.layer.masksToBounds = true;
        self.getDeviceIdBt.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.getDeviceIdBt.layer.cornerRadius = 2.0;
        self.getDeviceIdBt.layer.masksToBounds = true;
        self.getVersionBt.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.getVersionBt.layer.cornerRadius = 2.0;
        self.getVersionBt.layer.masksToBounds = true;
        self.upgradeBt.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.upgradeBt.layer.cornerRadius = 2.0;
        self.upgradeBt.layer.masksToBounds = true;
    
    }

    @IBAction func connectDevice(_ sender: Any) {
        
        let searchVC = SearchViewController ()
        searchVC.title = "搜索蓝牙设备"
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    
    @IBAction func getDeviceName(_ sender: Any) {
        self.deviceNameLabel.text = DataManager.shared()?.deviceName
    }
    
    @IBAction func getDeviceInfo(_ sender: Any) {
        let bleOpen = SLPBLEManager.shared()?.blueToothIsOpen()
        if !bleOpen! {
            print("ble not open!")
            return ;
        }
    
        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, getDeviceInfoTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                let deviceInfo: BleNoxDeviceInfo = data as! BleNoxDeviceInfo
                self.deviceInfoLabel.text = deviceInfo.deviceID
            }
            else
            {
                print("get device id failed")
            }
        })
        
    }
    
    @IBAction func getDeviceVersion(_ sender: Any) {

        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, getDeviceInfoTimeout: 0, callback: { (status: SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                let deviceInfo: BleNoxDeviceInfo = data as! BleNoxDeviceInfo
                self.deviceVersionLabel.text = deviceInfo.firmwareVersion as String?
            }
            else
            {
                print("get device version failed")
            }
        })
    }
    
    @IBAction func upgrade(_ sender: Any) {
        let path = Bundle.main.path(forResource: "SN902B_20200610.1.29", ofType: "MVA")
        let packageData = NSData.init(contentsOfFile: path!)

        SLPBLEManager.shared()?.bleNox(DataManager.shared()?.peripheral, deviceUpgrade: packageData as Data?, timeout: 0, callback: { (status :SLPDataTransferStatus, data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                let info: BleNoxUpgradeInfo = data as! BleNoxUpgradeInfo
                self.progressLabel.text = "\(Int(info.progress * 100))" + "%"
            }
            else
            {
                print("upgrade failed")
            }
        })
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

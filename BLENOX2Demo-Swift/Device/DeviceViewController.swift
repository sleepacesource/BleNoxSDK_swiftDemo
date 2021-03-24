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
    
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        先初始化蓝牙单例模块
        SLPBLEManager.shared()
        
        // Do any additional setup after loading the view.
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
    }
    
    func showConnected(connected: Bool) -> Void {
        let alpha = connected ? 1: 0.3
        self.bottomView.alpha = CGFloat(alpha)
        self.bottomView.isUserInteractionEnabled = connected
        
        if connected {
            self.connectBt.setTitle(NSLocalizedString("disconnect", comment: ""), for: UIControl.State.normal)
        } else {
            self.connectBt.setTitle(NSLocalizedString("connect_device", comment: ""), for: UIControl.State.normal)
        }
    }
    
    func setUI() -> Void {
        self.connectBt.setTitle(NSLocalizedString("connect_device", comment: ""), for: UIControl.State.normal)
        self.connectBt.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.connectBt.layer.cornerRadius = 2.0;
        self.connectBt.layer.masksToBounds = true;
        
        self.getDeviceNameBt.setTitle(NSLocalizedString("device_id_clear", comment: ""), for: UIControl.State.normal)
        self.getDeviceNameBt.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.getDeviceNameBt.layer.cornerRadius = 2.0;
        self.getDeviceNameBt.layer.masksToBounds = true;
        
        self.getDeviceIdBt.setTitle(NSLocalizedString("device_id_cipher", comment: ""), for: UIControl.State.normal)
        self.getDeviceIdBt.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.getDeviceIdBt.layer.cornerRadius = 2.0;
        self.getDeviceIdBt.layer.masksToBounds = true;
        
        self.getVersionBt.setTitle(NSLocalizedString("obtain_firmware", comment: ""), for: UIControl.State.normal)
        self.getVersionBt.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.getVersionBt.layer.cornerRadius = 2.0;
        self.getVersionBt.layer.masksToBounds = true;
        
        self.upgradeBt.setTitle(NSLocalizedString("fireware_update", comment: ""), for: UIControl.State.normal)
        self.upgradeBt.backgroundColor = UIColor.init(red: 42/255.0, green: 151/255.0, blue: 254/255.0, alpha: 1.0)
        self.upgradeBt.layer.cornerRadius = 2.0;
        self.upgradeBt.layer.masksToBounds = true;
        
        self.deviceInfoTitleLabel.text = NSLocalizedString("device_infos", comment: "")
        self.upgradeInfoTitleLabel.text = NSLocalizedString("firmware_info", comment: "")
    }

    @IBAction func connectDevice(_ sender: Any) {
        
        if DataManager.shared().connected {
            SLPBLEManager.shared()?.disconnectPeripheral(DataManager.shared()?.peripheral, timeout: 0, completion: {(status: SLPBLEDisconnectReturnCodes, data: Any?) in
                
            })
        } else {
            let searchVC = SearchViewController ()
            searchVC.title = NSLocalizedString("search_ble", comment: "")
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
        
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
                self.progressLabel.text = ""
                print("upgrade failed")
                Utils.showMessage(NSLocalizedString("up_failed", comment: ""), controller: self)
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

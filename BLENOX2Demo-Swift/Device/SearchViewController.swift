//
//  SearchViewController.swift
//  BLENOX2Demo-Swift
//
//  Created by San on 12/9/2019.
//  Copyright © 2019 medica. All rights reserved.
//

import UIKit
import BleNox


class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var deviceList = NSMutableArray.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.dataSource = self;
        self.tableview.delegate = self;
        self.tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CellID")
        
        self.scan()
        
    }
    
    func scan() -> Void {
        let bleOpen = SLPBLEManager.shared()?.blueToothIsOpen()
        if !bleOpen! {
            print("ble not open!")
            return ;
        }
        
        deviceList.removeAllObjects()
        self.tableview.reloadData()
        
        let ret = SLPBLEManager.shared()?.scanBluetooth(withTimeoutInterval: 3.0, completion: { (code: SLPBLEScanReturnCodes, handleID: Int, peripheralInfo: SLPPeripheralInfo?) in
            if code == SLPBLEScanReturnCodes.normal{//SLPBLEScanReturnCode_Normal
                self.appendPeripheral(info: peripheralInfo!)
            }
            else if code == SLPBLEScanReturnCodes.disable{
                print("ble not open!")
            }
        })
        
        if !ret! {
            print("ble not open!")
        }
    }
    
    func appendPeripheral(info:SLPPeripheralInfo) -> Void {
        if info.name.count == 0 {
            return ;
        }
        
        if !info.name.hasPrefix("SN21") {
            return ;
        }
        
        for ainfo in deviceList {
            if info.name == (ainfo as AnyObject).name
            {
                return ;
            }
        }
        
        deviceList.add(info)
        self.tableview.reloadData()
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        
        self.scan()
    }
    
    ///连接设备
    func connectDevice(device:SLPPeripheralInfo) -> Void {
        let bleOpen = SLPBLEManager.shared()?.blueToothIsOpen()
        if !bleOpen! {
            print("ble not open!")
            return ;
        }
        
        SLPBLEManager.shared()?.bleNox(device.peripheral, loginCallback: { (status: SLPDataTransferStatus,data: Any?) in
            if status == SLPDataTransferStatus.succeed
            {
                print("connect succeed")
                
                let deviceInfo: BleNoxDeviceInfo = data as! BleNoxDeviceInfo
                DataManager.shared()?.deviceID = deviceInfo.deviceID
                DataManager.shared()?.deviceName = device.name
                DataManager.shared()?.peripheral = device.peripheral
                
                ///login device after sync time
                let timeInfo:SLPTimeInfo = SLPTimeInfo()
                timeInfo.timestamp =  UInt32(NSDate().timeIntervalSince1970)
                timeInfo.timezone = Int32(NSTimeZone.system.secondsFromGMT())
                timeInfo.season = 0
                
                SLPBLEManager.shared()?.bleNox(device.peripheral, syncTimeInfo: timeInfo, timeout: 0, callback: { (status: SLPDataTransferStatus,data: Any?) in
                    if status == SLPDataTransferStatus.succeed
                    {
                        print("sync time succeed")
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        print("sync time failed")
                    }
                })
                
                
            }
            else
            {
                print("connect failed")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deviceList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.textLabel?.text = (deviceList[indexPath.row] as AnyObject).name
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let per : SLPPeripheralInfo = deviceList[indexPath.row] as! SLPPeripheralInfo
        self.connectDevice(device: per)
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

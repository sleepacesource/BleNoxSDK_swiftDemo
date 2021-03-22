//
//  DataPicker.swift
//  BLENOX2Demo-Swift
//
//  Created by jie yang on 2021/3/18.
//  Copyright © 2021 medica. All rights reserved.
//

import UIKit

typealias CancelBlock = ()->()

typealias ConfirmBlock = (Int)->()

class DataPicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var bgMask: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var selectedRow = 0
    
    var cancelBlock: CancelBlock?
    
    var confirmBlock: ConfirmBlock?
    
    var dataList: Array<String>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bgMask.backgroundColor = Theme.color(of: UIColor.black, alpha: 0.8)
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.cancelBtn.setTitle(NSLocalizedString("cancel", comment: ""), for: UIControl.State.normal)
        self.confirmBtn.setTitle(NSLocalizedString("confirm", comment: ""), for: UIControl.State.normal)
        self.cancelBtn.setTitleColor(Theme.c4(), for: UIControl.State.normal)
        self.confirmBtn.setTitleColor(Theme.c2(), for: UIControl.State.normal)
    }
    
    func reload() -> Void {
        self.pickerView.selectRow(self.selectedRow, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataList!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let text = dataList![row]
        
        return text
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.cancelBlock?()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        let selectRow = self.pickerView.selectedRow(inComponent: 0)
        self.confirmBlock?(selectRow)
    }
    
}

//
//  HistorySelectDateVC.swift
//  CarTracker
//
//  Created by Viet Anh on 12/2/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit
import DatePickerDialog
import SwiftDate

class HistorySelectDateVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet var txtStartDate: UITextField!
    @IBOutlet var txtEndDate: UITextField!
    @IBOutlet var btnSearch: UIButton!
    var selectedDevice:CarDevice

    init(carDevice: CarDevice) {
        self.selectedDevice = carDevice
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        selectedDevice = CarDevice()
        super.init(coder: aDecoder)
    }
    
    override func setupUI() {
        self.title = "Lịch sử di chuyển"
        txtStartDate.delegate = self
        txtEndDate.delegate = self
        
        // setup Date
        let currentDateTime = Date()
        let minDate = currentDateTime.addingTimeInterval(-7*24*60*60)
        txtStartDate.text = currentDateTime.toFormat("dd/MM/yyyy hh:ss")
        txtEndDate.text = minDate.toFormat("dd/MM/yyyy hh:ss")
        btnSearch.layer.cornerRadius = AppConstant.CORNER_RADIUS
        btnSearch.layer.backgroundColor = AppUtils.getAccentColor().cgColor

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func txtStartDate(_ sender: Any) {
        datePickerTapped(self.txtStartDate)
    }
    
    @IBAction func txtEndDateTouch(_ sender: Any) {
        datePickerTapped(self.txtEndDate)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // show UIDatePicker
        return false
    }

    @IBAction func btnSearchTouch(_ sender: Any) {
        
    }
    
    func datePickerTapped(_ sender:UITextField) {
        var maxDate = Date()
        if sender == self.txtEndDate {
            let startDateStr = txtStartDate.text!.toDate("dd/MM/yyyy")
            maxDate = Date(timeIntervalSince1970: startDateStr!.timeIntervalSince1970)
        }
        let minDate = maxDate.addingTimeInterval(-30*24*60*60)

        DatePickerDialog(locale: Locale(identifier: "vi_VN")).show("Chọn ngày",doneButtonTitle: "OK", cancelButtonTitle: "Hủy", minimumDate: minDate, maximumDate: maxDate, datePickerMode: .dateAndTime) { date in
            if let dt = date {
                sender.text = dt.toFormat("dd/MM/yyyy hh:ss")
            }
        }
    }

}

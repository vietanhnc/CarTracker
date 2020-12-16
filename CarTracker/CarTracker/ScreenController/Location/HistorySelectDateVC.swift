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
    let locationService = LocationService()
    
    init(carDevice: CarDevice) {
        self.selectedDevice = carDevice
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        selectedDevice = CarDevice()
        super.init(coder: aDecoder)
    }
    
    override func setupUI() {
        super.setupUI()
        self.title = "Lịch sử di chuyển"
        txtStartDate.delegate = self
        txtEndDate.delegate = self
        
        // setup Date
        let currentDateTime = Date()
        let minDate = currentDateTime.addingTimeInterval(-30*24*60*60)
        txtStartDate.text = minDate.toFormat("dd/MM/yyyy HH:mm")
        txtEndDate.text = currentDateTime.toFormat("dd/MM/yyyy HH:mm")
        btnSearch.layer.cornerRadius = AppConstant.CORNER_RADIUS
        btnSearch.layer.backgroundColor = AppUtils.getAccentColor().cgColor
    }
    
    override func setupData() {
        locationService.selectedDevice = self.selectedDevice
        let vietnamRegion = Region(calendar: Calendars.gregorian, zone: Zones.asiaHoChiMinh, locale: Locales.vietnamese)
        SwiftDate.defaultRegion = vietnamRegion

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
        if let startDate = txtStartDate.text, let endDate = txtEndDate.text {
            let date1 = startDate.toDate("dd/MM/yyyy HH:mm")
            let date2 = endDate.toDate("dd/MM/yyyy HH:mm")
            let lessDateFmt = date1?.toFormat("yyyyMMddHH")
            let greaterDateFmt = date2?.toFormat("yyyyMMddHH")
            guard let lessDateFmtUW = lessDateFmt, let greaterDateFmtUW = greaterDateFmt else { return }
            locationService.getGetLocationHistory(lessDateFmtUW, greaterDateFmtUW, completion: {
                error,data in
                if error != nil {
                    AlertView.show("Không tìm thấy thông tin!");
                    return
                }
                if data!.count == 0  {
                    AlertView.show("Không tìm thấy thông tin!");
                    return
                }
                let nextView = HistoryDetailVC(carDevice: self.selectedDevice, locHisArr: data!)
                self.navigationController?.pushViewController(nextView, animated: true)
            })
        }
    }
    
    func datePickerTapped(_ sender:UITextField) {
        var maxDate = Date()
        let minDate = maxDate.addingTimeInterval(-30*24*60*60)
        var defaultSwiftDate = txtEndDate.text!.toDate("dd/MM/yyyy HH:mm")
        if sender == self.txtStartDate {
            let endDateStr = txtEndDate.text!.toDate("dd/MM/yyyy HH:mm")
            maxDate = Date(timeIntervalSince1970: endDateStr!.timeIntervalSince1970)
            defaultSwiftDate = txtStartDate.text!.toDate("dd/MM/yyyy HH:mm")
        }
        let defaultDate = Date(timeIntervalSince1970: defaultSwiftDate!.timeIntervalSince1970)
        DatePickerDialog(locale: Locale(identifier: "vi_VN")).show("Chọn ngày",doneButtonTitle: "OK", cancelButtonTitle: "Hủy",defaultDate: defaultDate, minimumDate: minDate, maximumDate: maxDate, datePickerMode: .dateAndTime) { date in
            if let dt = date {
                let dateFormated = dt.toFormat("dd/MM/yyyy HH:mm",locale: Locales.vietnamese)
                sender.text = dateFormated
            }
        }
    }

}

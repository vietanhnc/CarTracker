//
//  ListAgentVC.swift
//  CarTracker
//
//  Created by VietAnh on 12/10/20.
//  Copyright © 2020 MSB. All rights reserved.
//

import UIKit

class ListAgentVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tblMain: UITableView!
    let mainService :MainService = MainService()
    var dataSource:[Agent]? = nil
    override func setupData() {
        mainService.fetchAgentList(completion: { error,data in
            if(error == nil){
                self.dataSource = data
                self.tblMain.reloadData()
            }
        })
    }
    
    override func setupUI() {
        self.title = "Mua thiết bị mới"
        tblMain.dataSource = self
        tblMain.delegate = self
        self.tblMain.register(UINib(nibName: "AgentCell", bundle: nil), forCellReuseIdentifier: "AgentCell")
//        tblMain.register(AgentCell.self, forHeaderFooterViewReuseIdentifier: "AgentCell")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource![indexPath.row]
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "AgentCell") as! AgentCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgentCell", for: indexPath) as! AgentCell
        cell.lblName?.text = item.name
        cell.lblAddress?.text = item.address
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.init(hexaRGB: "#F9F9F9")
        }else{
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView,
//                            viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
//                                                                "AgentCell") as! AgentCell
//        view.lblName?.text = "Chi nhánh/ Đại lý"
//        view.lblAddress?.text = "Địa chỉ"
//
//        return view
//    }
}

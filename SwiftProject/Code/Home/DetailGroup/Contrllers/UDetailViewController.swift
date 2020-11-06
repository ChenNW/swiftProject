//
//  UDetailViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/5.
//

import UIKit

class UDetailViewController: UBaseViewController {

    var detailModel:DetailStaticModel?
    var detailRealtime:DetailRealtimeModel?
    var guessLike:GuessYouLikeModel?
    
    private lazy var tableView: UITableView = {
        let tableV = UITableView(frame: CGRect.zero, style: .plain)
        tableV.separatorStyle = .none
        tableV.backgroundColor = UIColor.customBackgroudColor
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(cellType: UDescriptionTCell.self)
        tableV.register(cellType: UOtherWorksTCell.self)
        tableV.register(cellType: UTicketTCell.self)
        return tableV
    }()
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func reloadData(){
        tableView.reloadData()
    }
}

extension UDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UDescriptionTCell.self)
            cell.model = detailModel
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UOtherWorksTCell.self)
            cell.model = detailModel
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UTicketTCell.self)
            cell.model = detailRealtime
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
           return UDescriptionTCell.height(for: detailModel)
        }else if indexPath.section == 3{
            return 200
        }
        
        return 44
    }
}

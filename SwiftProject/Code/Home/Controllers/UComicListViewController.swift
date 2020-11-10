//
//  UComicListViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/3.
//

import UIKit

class UComicListViewController: UBaseViewController {
    
    private var spinnerName:String?
    private var argCon:Int = 0
    private var argName:String?
    private var argValue:Int = 0
    private var page:Int = 0
    private var ControllerType:UComicType = .none
    
    
    private lazy var dataArray:[ComicModel] = []
    
    private lazy var tableView:UITableView = {
        let tableView   = UITableView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: UComicTCell.self)
        tableView.register(cellType: UUpdateTCell.self)
        tableView.refreshHeader = URefreshHeader { [weak self] in
            self?.loadData(more: false)
        }
        tableView.refreshFooter = URefreshAutoFooter{[weak self] in
            self?.loadData(more: true)
        }
        tableView.uempty = UEmptyView(tapClosure: {
            self.loadData(more: false)
        })
        return tableView
    }()
    
    convenience init(argCon: Int = 0 , argName:String? ,argValue:Int = 0 ,controllerType:UComicType = .none) {
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
        self.ControllerType = controllerType
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(more: false)
    }
    
    func loadData(more: Bool){
        page = more ? (page + 1) : 1
        ApiLoadingProvider.request(UApi.comicList(argCon: argCon, argName: argName ?? "", argValue: argValue, page: page), model: ComicListsModel.self, completion: { [weak self]
            (result) in
            self?.tableView.refreshHeader.endRefreshing()
            if result?.hasMore == false {
                self?.tableView.refreshFooter.endRefreshingWithNoMoreData()
            }else{
                self?.tableView.refreshFooter.endRefreshing()
            }
            
            if !more{self?.dataArray.removeAll()}
            self?.dataArray.append(contentsOf: result?.comics ?? [])
            self?.tableView.uempty?.allowShow = true
            self?.tableView.reloadData()
            
            guard let defaultParameters = result?.defaultParameters else{return}
            self?.argCon = defaultParameters.defaultArgCon
            self?.spinnerName = defaultParameters.defaultConTagType
            
            
        })
        
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }

}

extension UComicListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
}
extension UComicListViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        if ControllerType == .update {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UUpdateTCell.self)
            cell.model = self.dataArray[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UComicTCell.self)
            cell.spinnerName = spinnerName
            cell.indexPath = indexPath
            cell.model = self.dataArray[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.dataArray[indexPath.row]
        let vc = UComicViewController(detailId: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
}

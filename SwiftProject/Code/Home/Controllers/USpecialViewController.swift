//
//  USpecialViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/2.
//

import UIKit

class USpecialViewController: UBaseViewController {

    private var page:Int = 0
    private var argCon:Int = 0
    private lazy var dataArray:[ComicModel] = []
    
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.backgroundColor = UIColor.customBackgroudColor
        tb.separatorStyle = .none
        tb.tableFooterView = UIView()
        tb.refreshHeader = URefreshHeader{
            [weak self] in
            self?.loadData(false)
        }
        tb.refreshFooter = URefreshAutoFooter{
            [weak self] in
            self?.loadData(true)
        }
        tb.delegate = self
        tb.dataSource = self
        tb.uempty = UEmptyView(tapClosure: {
            [weak self] in
            self?.loadData(false)
        })
        tb.register(cellType: USpecialTCell.self)
        return tb
    }()
    
    private func loadData(_ more:Bool) -> Void {
        ApiLoadingProvider.request(UApi.special(argCon: argCon, page: page), model: ComicListsModel.self) { [weak self](result) in
            
            self?.tableView.refreshHeader.endRefreshing()
            if result?.hasMore == true {
                self?.tableView.refreshFooter.endRefreshing()
            }else{
                self?.tableView.refreshFooter.endRefreshingWithNoMoreData()
            }
            if !more {
                self?.dataArray.removeAll()
            }
            self?.tableView.uempty?.allowShow = true
            
            self?.dataArray.append(contentsOf: result?.comics ?? [])
            self?.tableView.reloadData()
            
            guard let defaultParameters = result?.defaultParameters else {return}
            self?.argCon = defaultParameters.defaultArgCon
        }

    }
    
    convenience init(argCon: Int) {
        self.init()
        self.argCon = argCon
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData(false)
    }

}

extension USpecialViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: USpecialTCell.self)
        cell.model = dataArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        var html:String?
        if model.specialType == 1 {
            html = "http://www.u17.com/z/zt/appspecial/special_comic_list_v3.html"
        }else if model.specialType == 2{
            html = "http://www.u17.com/z/zt/appspecial/special_comic_list_new.html"
        }
        guard let host = html else {
            return
        }
        
        let path = "special_id=\(model.specialId)&is_comment=\(model.isComment)"
        let url = [host,path].joined(separator: "?")
        
        let vc = UWebViewController(url: url)
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
}

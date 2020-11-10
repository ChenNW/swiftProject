//
//  USearchViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/9.
//

import UIKit
import KakaJSON
class USearchViewController: UBaseViewController {

    private var currentRequest:Cancellable?
    private var hotItems: [SearchItemModel]?
    private var relative: [SearchItemModel1]?
    private var comics:[ComicModel]?
    
    private lazy var searchHistory: [String]! = {
        return UserDefaults.standard.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
    }()
    
    
    
    
    private lazy var searchBar: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.tintColor = .gray
        textField.font = .systemFont(ofSize: 15)
        textField.placeholder = "输入漫画名称/作者"
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.clearsOnBeginEditing = true
        textField.returnKeyType = .search
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextChange(noti:)), name: UITextField.textDidChangeNotification, object: nil)
        return textField
    }()
    
    private lazy var historyTableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.register(headerFooterViewType: USearchTHead.self)
        tw.register(cellType: UBaseTableViewCell.self)
        tw.register(headerFooterViewType: USearchTFoot.self)
        return tw
    }()
    
    private lazy var searchTableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.register(headerFooterViewType: USearchTHead.self)
        tb.register(cellType: UBaseTableViewCell.self)
        return tb
    }()
    private lazy var resultTableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.register(cellType: UComicTCell.self)
        return tb
    }()
    

    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.titleView = searchBar
        searchBar.frame = CGRect(x: 0, y: 0, width: screenWidth - 50, height: 30)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消",
                                                            target: self,
                                                            action: #selector(leftButtonClick))
    }
    
    override func leftButtonClick() {
        super.leftButtonClick()
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHistory()
    }
    override func configUI() {
        view.addSubview(historyTableView)
        view.addSubview(searchTableView)
        view.addSubview(resultTableView)
        historyTableView.snp.makeConstraints {$0.edges.equalTo(self.view.usnp.edges)}
        searchTableView.snp.makeConstraints {$0.edges.equalTo(self.view.usnp.edges)}
        resultTableView.snp.makeConstraints {$0.edges.equalTo(self.view.usnp.edges)}
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:Method
    ///历史数据
    private func loadHistory (){
        
        historyTableView.isHidden = false
        searchTableView.isHidden = true
        resultTableView.isHidden = true
        
        ApiProvider.request(UApi.searchHot, model: HotItemsModel.self) { [weak self] (result) in
            self?.hotItems = result?.hotItems
            self?.historyTableView.reloadData()
        }
    }
    ///模糊搜索
    private func searchRelative(_ text: String) {
        if text.count > 0 {
            historyTableView.isHidden = true
            searchTableView.isHidden = false
            resultTableView.isHidden = true
            currentRequest?.cancel()
            currentRequest = ApiLoadingProvider.request(UApi.searchRelative(inputText: text), completion: { (result) in
                let data = result.value?.data
                let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let model = string?.kj.model(type: ResponseData1.self) as! ResponseData1
                self.relative = model.data?.returnData
                self.searchTableView.reloadData()
                
            })
            
        }else{
            historyTableView.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }
    ///精确搜索
    private func searchResult(_ text: String) {
        if text.count > 0 {
            historyTableView.isHidden = true
            searchTableView.isHidden = true
            resultTableView.isHidden = false
            
            searchBar.text = text
            ApiLoadingProvider.request(UApi.searchResult(argCon: 0, q: text), model: SearchResultModel.self) { (result) in
                self.comics = result?.comics
                self.resultTableView.reloadData()
            }
            
            let defaults = UserDefaults.standard
            var history = defaults.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
            history.removeAll([text])
            history.insertFirst(text)
            
            searchHistory = history
            historyTableView.reloadData()
            defaults.setValue(history, forKey: String.searchHistoryKey)
            defaults.synchronize()
            
            
        }else{
            historyTableView.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
        
    }
    
}

extension USearchViewController: UITextFieldDelegate {
    
    @objc func textFieldTextChange(noti:Notification){
        guard let textField = noti.object as? UITextField ,let text = textField.text else {
            return
        }
        searchRelative(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
extension USearchViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == historyTableView {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView {
            return section == 0 ? (searchHistory?.prefix(5).count ?? 0):0
        }else if tableView == searchTableView {
            return relative?.count ?? 0
        }else {
            return comics?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
            cell.textLabel?.text = searchHistory?[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        }else if tableView == searchTableView{
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
            cell.textLabel?.text = relative?[indexPath.row].name
            cell.textLabel?.textColor = .darkGray
            cell.textLabel?.font = .systemFont(ofSize: 13)
            cell.separatorInset = UIEdgeInsets.zero
            return cell
        }else if tableView == resultTableView{
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UComicTCell.self)
            cell.model = comics?[indexPath.row]
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)

            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == historyTableView {
            searchRelative(searchHistory[indexPath.row])
        }else if tableView == searchTableView {
            searchResult(relative?[indexPath.row].name ?? "")
        }else{
            guard let model = comics?[indexPath.row] else {
                return
            }
            let vc = UComicViewController(detailId: model.comicId)
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView {
            return 180
        }
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == historyTableView {
            return 44
        }else if tableView == searchTableView {
            return comics?.count ?? 0 > 0 ? 44 : CGFloat.leastNormalMagnitude
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == historyTableView {

            let head = tableView.dequeueReusableHeaderFooterView(USearchTHead.self)
            head?.titleLabel.text = section == 0 ? "看看你都搜过什么" : "大家都在搜"
            head?.moreButton.setImage(UIImage(named: section == 0 ? "search_history_delete" : "search_keyword_refresh"), for: .normal)
            head?.moreButtonAction = { [weak self] (button) in
                if section == 0 {
                    self?.searchHistory.removeAll()
                    self?.historyTableView.reloadData()
                    UserDefaults.standard.removeObject(forKey: String.searchHistoryKey)
                    UserDefaults.standard.synchronize()
                }else{
                    self?.loadHistory()
                }
            }
            return head
            
        }else if tableView == searchTableView {
            let head = tableView.dequeueReusableHeaderFooterView(USearchTHead.self)
            head?.titleLabel.text = "找到相关的漫画\(comics?.count ?? 0)本"
            head?.moreButton.isHidden = true
            return head
        }
        
        return nil
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == historyTableView {
            return section == 0 ? 10 : tableView.frame.height - 44
        }
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == historyTableView && section == 1 {
            let footer = tableView.dequeueReusableHeaderFooterView(USearchTFoot.self)
            footer?.data = hotItems ?? []
            footer?.didSelectIndexClosure({[weak self] (index, model) in
                let vc = UComicViewController(detailId: model.comic_id)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            return footer
        }
        
        return nil
    }
}

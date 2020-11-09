//
//  UCommentViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/5.
//

import UIKit

class UCommentViewController: UBaseViewController {

    var detailStacticModel:DetailStaticModel?
    var commentsList:CommentListModel?{
        didSet{
            guard let commentList = commentsList?.commentList else {
                return
            }
            let viewModelArray = commentList.compactMap { (comment) -> UCommentViewModel? in
                return UCommentViewModel(model: comment)
            }
            
            listArray.append(contentsOf: viewModelArray)
        }
    }
    
    private var listArray = [UCommentViewModel]()
    
    weak var delegate: UComicViewWillEndDraggingDelegate?
    
    private lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .plain)
        tb.register(cellType: UCommentTCell.self)
        tb.delegate = self
        tb.dataSource = self
        tb.refreshFooter = URefreshAutoFooter{[weak self] in
            self?.loadData()
        }
        return tb
    }()
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func reloadData(){
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        ApiProvider.request(UApi.commentList(object_id: detailStacticModel?.comic?.comic_id ?? 0, thread_id: detailStacticModel?.comic?.thread_id ?? 0, page: commentsList?.serverNextPage ?? 0), model: CommentListModel.self) {[weak self] (result) in
            
            if result?.hasMore == true{
                self?.tableView.refreshFooter.endRefreshing()
            }else{
                self?.tableView.refreshFooter.endRefreshingWithNoMoreData()
            }
            
            self?.commentsList = result
            self?.tableView.reloadData()
        }
    }
 
}
extension UCommentViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listArray[indexPath.row].height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UCommentTCell.self)
        cell.viewModel = listArray[indexPath.row]
        return cell
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
}

//extension

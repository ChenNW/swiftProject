//
//  UComicViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/5.
//

import UIKit

protocol UComicViewWillEndDraggingDelegate: class {
    func comicWillEndDragging(_ scrollView: UIScrollView)
}

class UComicViewController: UBaseViewController {

    private var detailId:Int = 0
    private var detailStackModel:DetailStaticModel?
    private var detailRealModel:DetailRealtimeModel?
    
    //scrollview
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var detailVC: UDetailViewController = {
        let detailVc = UDetailViewController()
        detailVc.delegate = self
        return detailVc
    }()
    private lazy var chapterVc: UChapterViewController = {
        let chapterV = UChapterViewController()
        chapterV.delegate = self
        return chapterV
    }()
    private lazy var commentVc: UCommentViewController = {
        let commentV = UCommentViewController()
        commentV.delegate = self
        return commentV
    }()
    
    private lazy var pageVc: UPageViewController = {
        let pageV = UPageViewController(titles: ["详情","目录","评论"], controllers: [detailVC,chapterVc,commentVc], style: .topTabBar)
        return pageV
    }()
    
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    private lazy var headView: UComicHead = {
        return UComicHead(frame: CGRect(x: 0, y: 0, width: screenWidth, height: navigationBarY + 150))
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.changeOrientationTo(landscapeRight: false)
    }
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.clear)
        mainScrollView.contentOffset = CGPoint(x: 0, y: -mainScrollView.parallaxHeader.height)
    }
    
    convenience init(detailId: Int) {
        self.init()
        self.detailId = detailId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    private func loadData (){
     
        let group = DispatchGroup()
        
        group.enter()
        ///请求基本信息
        ApiLoadingProvider.request(UApi.detailStatic(comicid: detailId), model: DetailStaticModel.self) {[weak self] (result) in
            
            self?.detailStackModel = result
            self?.headView.detailModel = self?.detailStackModel?.comic///头部赋值
            self?.detailVC.detailModel = result///详情数据
            self?.chapterVc.detailStaticModel = result ///目录数据
            ///请求评论
            ApiProvider.request(UApi.commentList(object_id: result?.comic?.comic_id ?? 0, thread_id: result?.comic?.thread_id ?? 0, page: -1), model: CommentListModel.self) { [weak self](result) in
                self?.commentVc.commentsList = result
                group.leave()
            }
        }
        
        group.enter()
        ///实时信息
        ApiProvider.request(UApi.detailRealtime(comicid: detailId), model: DetailRealtimeModel.self) { [weak self](result) in
            self?.headView.realTimeModel = result?.comic ///头部实时赋值
            self?.detailVC.detailRealtime = result/// 详情月票信息
            group.leave()
        }
        
        ///猜你喜欢
        group.enter()
        ApiProvider.request(UApi.guessLike, model: GuessYouLikeModel.self) { [weak self](result) in
            self?.detailVC.guessLike = result
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.detailVC.reloadData()
            self.chapterVc.reloadData()
            self.commentVc.reloadData()
        }
        
    }
    
    
    override func configUI() {
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges).priority(.low)
            $0.edges.equalToSuperview()
        }
        let contentView = UIView()
        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().offset(-navigationBarY)
        }

        addChild(pageVc)
        contentView.addSubview(pageVc.view)
        pageVc.view.snp.makeConstraints { $0.edges.equalToSuperview() }

        mainScrollView.parallaxHeader.view = headView
        mainScrollView.parallaxHeader.height = navigationBarY + 150
        mainScrollView.parallaxHeader.minimumHeight = navigationBarY
        mainScrollView.parallaxHeader.mode = .fill
        
    }
 
}

extension UComicViewController:UIScrollViewDelegate,UComicViewWillEndDraggingDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -scrollView.parallaxHeader.minimumHeight {
            navigationController?.barStyle(.theme)
            navigationItem.title = detailStackModel?.comic?.name
        }else{
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
        }
    }
    
    func comicWillEndDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0  {
            mainScrollView.setContentOffset(CGPoint(x: 0, y: -self.mainScrollView.parallaxHeader.minimumHeight), animated: true)
        }else{
            mainScrollView.setContentOffset(CGPoint(x: 0, y: -self.mainScrollView.parallaxHeader.height), animated: true)
        }
        
    }
    
}

//
//  UReadViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/9.
//

import UIKit

class UReadViewController: UBaseViewController {

    var edgeInsets:UIEdgeInsets{
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        }else{
            return .zero
        }
    }
    
    private var isLandscapeRight:Bool!{
        didSet{
            UIApplication.changeOrientationTo(landscapeRight: isLandscapeRight)
            collectionView.reloadData()
        }
    }
    private var isBarHidden:Bool = false{
        didSet{
            UIView.animate(withDuration: 0.5) {
                self.topBar.snp.updateConstraints{
                    $0.top.equalTo(self.backScrollView).offset(self.isBarHidden ? -(self.edgeInsets.top + 44) : 0)
                }
                self.bottomBar.snp.updateConstraints{
                    $0.bottom.equalTo(self.backScrollView).offset(self.isBarHidden ? (self.edgeInsets.bottom + 120) : 0)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private var chapterList = [ChapterModel]()
    private var destailStatic:DetailStaticModel?
    private var selectedIndex: Int = 0
    private var previousIndex: Int = 0
    private var nextIndex: Int = 0
    
    
    ///navBar
    private lazy var topBar: UReadTopBar = {
        let bar = UReadTopBar()
        bar.backgroundColor = .white
        bar.buttonClick = { [weak self] in
            self?.leftButtonClick()
        }
        return bar
    }()
    ///bottomView
    private lazy var bottomBar: UReadBottomBar = {
        let bottomBar = UReadBottomBar()
        bottomBar.backgroundColor = .white
        bottomBar.deviceDirectionButton.addTarget(self, action: #selector(changeDeviceDirection(_:)), for: .touchUpInside)
        bottomBar.chapterButton.addTarget(self, action: #selector(changeChapter(_:)), for: .touchUpInside)
        return bottomBar
    }()
    
    ///scrollView
    private lazy var backScrollView: UIScrollView = {
        let sw = UIScrollView()
        sw.delegate = self
        sw.minimumZoomScale = 1.0
        sw.maximumZoomScale = 1.5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        sw.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        sw.addGestureRecognizer(doubleTap)
        ///优先检测doubleTap,若doubleTap检测不到，或检测失败，则检测tap,检测成功后，触发方法

        tap.require(toFail: doubleTap)
        
        return sw
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = .zero
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 10
        let cw = UICollectionView(frame: .zero, collectionViewLayout: flow)
        cw.backgroundColor = UIColor.customBackgroudColor
        cw.delegate = self
        cw.dataSource = self
        cw.register(cellType: UReadCCell.self)
        cw.refreshHeader = URefreshHeader{ [weak self] in
            
            let previousIndex = self?.previousIndex ?? 0
            self?.loadData(with: previousIndex, isPreious: true, needClear: false,finished: { [weak self](finish) in
                self?.previousIndex = previousIndex - 1
            })
            
        }
        cw.refreshFooter = URefreshAutoFooter {[weak self] in
            let  nextIndex = self?.nextIndex ?? 0
            self?.loadData(with: nextIndex, isPreious: false, needClear: false ,finished: {[weak self] (finish) in
                self?.nextIndex = nextIndex + 1
            })
            
        }
        return cw
    }()
    
    convenience init(detailStatic: DetailStaticModel?,selectedIndex: Int) {
        self.init()
        self.destailStatic = detailStatic
        self.selectedIndex = selectedIndex
        self.previousIndex = selectedIndex - 1
        self.nextIndex = selectedIndex + 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .all
        loadData(with: selectedIndex, isPreious: false, needClear: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLandscapeRight = false
    }
    
    //MARK: 方法
    ///数据请求
    func loadData(with index: Int,isPreious: Bool,needClear: Bool,finished: ((_ finished: Bool) -> Void)? = nil) {
        
        guard let destailStatic = destailStatic else {
            return
        }
        topBar.titleLabel.text = destailStatic.comic?.name
        if index <= -1 {
            collectionView.refreshHeader.endRefreshing()
            UNoticeBar(config: UNoticeBarConfig(title: "亲,这已经是第一页了")).show(duration: 2)
        }else if index >= destailStatic.chapter_list?.count ?? 0{
            collectionView.refreshFooter.endRefreshingWithNoMoreData()
            UNoticeBar(config: UNoticeBarConfig(title:"亲,已经木有了")).show(duration: 2)
        }else{
        
            guard let chaperId = destailStatic.chapter_list?[index].chapter_id else {
                return
            }
            ApiLoadingProvider.request(UApi.chapter(chapter_id: chaperId), model: ChapterModel.self) { [weak self] (result) in
                
                self?.collectionView.refreshHeader.endRefreshing()
                self?.collectionView.refreshFooter.endRefreshing()
                
                guard let chapter = result else {return}
                
                if needClear {self?.chapterList.removeAll()}
                if isPreious {
                    self?.chapterList.insert(chapter, at: 0)
                }else{
                    self?.chapterList.append(chapter)
                }
                
                self?.collectionView.reloadData()
                guard let finished = finished else {return}
                
                finished(true)
            }
            
        }
        
    }
    
    @objc func tapAction() {//单点
        isBarHidden = !isBarHidden
    }
    
    @objc func doubleTapAction(){//双击
        var zoomScale = backScrollView.zoomScale
        zoomScale = 2.5 - zoomScale
        let width = view.frame.width / zoomScale
        let height = view.frame.height / zoomScale
        let zoomRect = CGRect(x: backScrollView.center.x - width/2, y: backScrollView.center.y - height/2, width: width, height: height)
        backScrollView.zoom(to: zoomRect, animated: true)
        
    }
    ///横竖屏
    @objc func changeDeviceDirection(_ button:UIButton){
        isLandscapeRight = !isLandscapeRight
        if isLandscapeRight {
            button.setImage(UIImage(named: "readerMenu_changeScreen_vertical")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }else{
            button.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    ///目录
    @objc func changeChapter(_ button: UIButton) {
    }

    
    override func configUI() {
        view.backgroundColor = .white
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
        backScrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(backScrollView)
        }
        
        view.addSubview(topBar)
        topBar.snp.makeConstraints{
            $0.left.right.top.equalTo(backScrollView)
            $0.height.equalTo(44)
        }
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints{
            $0.left.right.bottom.equalTo(backScrollView)
            $0.height.equalTo(120)
        }
    }
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.white)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_black"), style: .plain, target: self, action: #selector(leftButtonClick))
        navigationController?.disablePopGesture = true
    }
    
    override var prefersStatusBarHidden: Bool{
        return isIphoneX ? false : true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    
}



extension UReadViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        chapterList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterList[section].image_list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let image = chapterList[indexPath.section].image_list?[indexPath.item] else {
            return CGSize.zero
        }
        
        let width = backScrollView.frame.width
        let height = width/CGFloat(image.width)*CGFloat(image.height)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UReadCCell.self)
        cell.model = chapterList[indexPath.section].image_list?[indexPath.item]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isBarHidden == false {
            isBarHidden = true
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == backScrollView {
            return collectionView
        }else{
            return nil
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == scrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width * scrollView.zoomScale, height: scrollView.frame.height)
        }
    }
}

//
//  URefresh.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/30.
//


extension UIScrollView {
    
    var refreshHeader: MJRefreshHeader {
        set{
            mj_header = newValue
        }
        get{
            return mj_header!
        }
    }
    
    var refreshFooter: MJRefreshFooter {
        set{
            mj_footer = newValue
        }
        get{
            return mj_footer!
        }
    }
    
}

class URefreshAutoHeader: MJRefreshHeader {}
class URefreshFooter: MJRefreshFooter {}
class URefreshAutoFooter: MJRefreshAutoFooter {}

///自定义下拉刷新
class URefreshHeader: MJRefreshGifHeader {
    
    override func prepare() {
        super.prepare()
        ///闲置状态
        setImages([UIImage(named: "refresh_normal")!], for: .idle)
        ///松开刷新状态
        setImages([UIImage(named: "refresh_will_refresh")!], for: .pulling)
        ///刷新状态
        setImages([UIImage(named: "refresh_loading_1")!,
                   UIImage(named: "refresh_loading_2")!,
                   UIImage(named: "refresh_loading_3")!], for: .refreshing)
        lastUpdatedTimeLabel?.isHidden = true
        stateLabel?.isHidden = true
        
    }
    
}

///自定义上拉刷新
class URefreshDiscoverFooter: MJRefreshBackGifFooter {
    override func prepare() {
        super.prepare()
        backgroundColor = UIColor.customBackgroudColor
        setImages([UIImage(named: "refresh_discover")!], for: .idle)
        stateLabel?.isHidden = true
        refreshingBlock = {
            self.endRefreshing()
        }
        
        
    }
}


class URefreshTipKissFooter: MJRefreshBackFooter {
    
    lazy var tipLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
        
    }()
    
    lazy var imageView:UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "refresh_kiss")
        return img
    }()
    
    override func prepare() {
        super.prepare()
        backgroundColor = UIColor.customBackgroudColor
        mj_h = 240
        addSubview(tipLabel)
        addSubview(imageView)
    }
    
    override func placeSubviews() {
        tipLabel.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 60)
        imageView.frame = CGRect(x: (bounds.width - 80 ) / 2, y: 110, width: 80, height: 80)
    }
    
    convenience init(with tip: String) {
        self.init()
        refreshingBlock = {
            self.endRefreshing()
        }
        tipLabel.text = tip
    }
}

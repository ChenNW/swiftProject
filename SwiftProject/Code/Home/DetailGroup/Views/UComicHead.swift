//
//  UComicHead.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/5.
//

import UIKit


class UComicHeadCCell: UBaseCollectionViewCell {
    
     lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override func configUI() {
        contentView.addSubview(titleLabel)
        layer.cornerRadius = 3
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        titleLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}

class UComicHead: UIView {

    private var themes:[String]?
    
    private lazy var bgImgeView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.blurView.setup(style: .dark, alpha: 1).enable()
        return image
    }()
    
    private lazy var coverImgeView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 3
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
//        label.backgroundColor = .red
        return label
    }()
    
    lazy var themeView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 5
        flow.itemSize = CGSize(width: 40, height: 20)
        flow.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.register(cellType: UComicHeadCCell.self)
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    func config(){
        addSubview(bgImgeView)
        addSubview(coverImgeView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(totalLabel)
        addSubview(themeView)
        
        bgImgeView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        coverImgeView.snp.makeConstraints{
            $0.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0))
            $0.width.equalTo(90)
            $0.height.equalTo(120)
        }
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(coverImgeView.snp.right).offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(coverImgeView)
            $0.height.equalTo(20)
        }
        authorLabel.snp.makeConstraints{
            $0.left.right.height.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        totalLabel.snp.makeConstraints{
            $0.left.right.height.equalTo(titleLabel)
            $0.top.equalTo(authorLabel.snp.bottom).offset(5)
        }
        themeView.snp.makeConstraints{
            $0.left.right.equalTo(titleLabel)
            $0.height.equalTo(30)
            $0.bottom.equalTo(coverImgeView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var detailModel:ComicStaticModel?{
        didSet{
            guard let model = detailModel else {return}
            bgImgeView.setImageView(urlString: model.wideCover!, placeHorderImage:  UIImage(named: "normal_placeholder_v"))
            coverImgeView.setImageView(urlString: model.cover!, placeHorderImage:  UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name
            authorLabel.text = model.author?.name
            themes = model.theme_ids ?? []
            themeView.reloadData()
        }
    }
    /// 实时数据
    var realTimeModel:ComicRealtimeModel?{
        didSet{
            guard let model = realTimeModel else {
                return
            }
            
            let text = NSMutableAttributedString(string: "点击 收藏")
            text.insert(NSAttributedString(string: "\(model.click_total ?? "0")", attributes: [NSAttributedString.Key.foregroundColor:UIColor.orange,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)]), at: 2)
            text.append(NSAttributedString(string: "\(model.favorite_total ?? "0")",attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.orange]))
            totalLabel.attributedText = text
        }
    }
    
    
}


extension UComicHead:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        themes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicHeadCCell.self)
        cell.titleLabel.text = themes?[indexPath.item]
        return cell
        
    }
}

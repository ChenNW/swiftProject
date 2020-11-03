//
//  UComicTCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/3.
//



class UComicTCell: UBaseTableViewCell{

    var spinnerName:String?
    
    private lazy var CoverImage:UIImageView = {
        let coverImage = UIImageView()
        coverImage.contentMode = .scaleAspectFill
        coverImage.clipsToBounds = true
        return coverImage
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    private lazy var subTitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private lazy var desLabel:UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private lazy var tagLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.orange
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var orderImageView: UIImageView = {
        let ow = UIImageView()
        ow.contentMode = .scaleAspectFit
        ow.isHidden = true
        return ow
    }()
    
    
    override func configUI() {
        
        separatorInset = .zero
        contentView.addSubview(CoverImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(desLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(orderImageView)
        
        CoverImage.snp.makeConstraints{
            $0.left.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
            $0.width.equalTo(100)
        }
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(CoverImage.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(CoverImage)
            $0.height.equalTo(30)
        }
        subTitleLabel.snp.makeConstraints{
            $0.left.right.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.height.equalTo(20)
        }
        desLabel.snp.makeConstraints{
            $0.left.right.equalTo(titleLabel)
            $0.height.equalTo(60)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
        }
        orderImageView.snp.makeConstraints{
            $0.bottom.equalTo(CoverImage)
            $0.height.width.equalTo(30)
            $0.right.equalTo(titleLabel)
        }
        tagLabel.snp.makeConstraints{
            $0.left.equalTo(titleLabel)
            $0.height.equalTo(20)
            $0.right.equalTo(orderImageView.snp.left).offset(-10)
            $0.bottom.equalTo(CoverImage)
        }
    }
    
    var model:ComicModel?{
        didSet{
            guard let model = model else {return}
            CoverImage.setImageView(urlString: model.cover!, placeHorderImage: nil)
            titleLabel.text = model.name
            subTitleLabel.text = "\(model.tags?.joined(separator: " ") ?? "") | \(model.author ?? "")"
            desLabel.text = model.description
            
            if spinnerName == "更新时间" {
                tagLabel.text = "\(spinnerName ?? "") \(getTimeString(Timestamp: model.conTag))"
            }else{
                let value = getUnitString(value: model.conTag)
                if value != "0" {
                    tagLabel.text = "\(spinnerName ?? "总点击") \(value)"
                }
                orderImageView.isHidden = false
            }
            
        }
    }
    
    var indexPath:IndexPath? {
        didSet{
         
            guard let index = indexPath else {
                return
            }
            
            
            if index.row == 0 {
                orderImageView.image = UIImage(named:"rank_frist")
            }else if index.row == 1{
                orderImageView.image = UIImage(named: "rank_second")
            }else if index.row == 2{
                orderImageView.image = UIImage(named:"rank_third")
            }else{
                orderImageView.image = nil
            }
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

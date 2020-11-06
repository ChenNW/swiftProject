//
//  UOtherWorksTCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/6.
//

import UIKit

class UOtherWorksTCell: UBaseTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model:DetailStaticModel?{
        didSet{
            guard let model = model else {
                return
            }
            textLabel?.text = "其他作品"
            detailTextLabel?.text = "\(model.otherWorks?.count ?? 0) 本"
            detailTextLabel?.font = .systemFont(ofSize: 15)
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

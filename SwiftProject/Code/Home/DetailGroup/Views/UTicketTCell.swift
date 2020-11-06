//
//  UTicketTCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/6.
//

import UIKit

class UTicketTCell: UBaseTableViewCell {

    
    
    
    var model:DetailRealtimeModel?{
        didSet{
            guard let model = model else {
                return
            }
            
            let text = NSMutableAttributedString(string: "本月月票       |     累计月票  ", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
            text.append(NSAttributedString(string: "\(model.comic?.total_ticket ?? "")", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.orange]))
            text.insert(NSAttributedString(string: "\(model.comic?.monthly_ticket ?? "")", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.orange]), at: 6)
            textLabel?.textAlignment = .center
            textLabel?.attributedText = text
            
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

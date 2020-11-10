//
//  UIBarButtonItemExtension.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/10.
//


extension UIBarButtonItem {
    
    convenience init(title: String?,
                     titleColor: UIColor = .white,
                     titleFont:UIFont = .systemFont(ofSize: 15),
                     titleEdgeInsets: UIEdgeInsets = .zero,
                     target: Any?,
                     action: Selector?){
        
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = titleFont
        button.titleEdgeInsets = titleEdgeInsets
        
        if action != nil {
            button.addTarget(target, action: action!, for: .touchUpInside)
        }
        button.sizeToFit()
        if button.bounds.width < 40 || button.bounds.height > 40 {
            let width = 40 / button.bounds.height * button.bounds.width
            button.bounds = CGRect(x: 0, y: 0, width: width, height: 40)
        }
        self.init(customView:button)
    }
    
    convenience init (image:UIImage?,
                      selectedImage: UIImage?,
                      imageEdgeInsets: UIEdgeInsets = .zero,
                      target: Any?,
                      action:Selector?
    ){
        
        let button = UIButton(type: .system)
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .selected)
        button.imageEdgeInsets = imageEdgeInsets
        if action != nil {
            button.addTarget(target, action: action!, for: .touchUpInside)
        }
        button.sizeToFit()
        if button.bounds.width < 40 || button.bounds.height > 40 {
            let width = 40 / button.bounds.height * button.bounds.width;
            button.bounds = CGRect(x: 0, y: 0, width: width, height: 40)
        }
        
        self.init(customView: button)
    }
    
}


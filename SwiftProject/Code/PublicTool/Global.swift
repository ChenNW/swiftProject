//
//  Global.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/30.
//



let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

extension String {
    static let sexTypeKey = "sexTypeKey"
    
}

///顶层控制器
var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}
private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}
///Kingfisher
//MARK://Kingfisher

extension UIImageView {
    
    func setImageView(urlString: String,placeHorderImage:Placeholder? = UIImage(named: "normal_placeholder_h") ) {
        
        if urlString.count > 0 {
            self.kf.setImage(with: URL(string: urlString),
                             placeholder: placeHorderImage,
                             options:[.transition(.fade(0.5))])
        }else{
            self.image = placeHorderImage as? UIImage
        }
        
    }
    
}



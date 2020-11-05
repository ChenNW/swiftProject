//
//  Global.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/30.
//


import SnapKit
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
    
    func setImageView(urlString: String,placeHorderImage:Placeholder?) {
        
        if urlString.count > 0 {
            self.kf.setImage(with: URL(string: urlString),
                             placeholder: placeHorderImage ?? UIImage(named: "normal_placeholder_h") ,
                             options:[.transition(.fade(0.5))])
        }else{
            self.image = placeHorderImage as? UIImage
        }
        
    }
    
}

//MARK: 打印
func ULog<T>(_ message: T ,file: String = #file ,function: String = #function ,lineNumber: Int = #line){
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):function:\(function):line:\(lineNumber)] - \(message)")
    
    #endif
}

//MARK:根据时间戳转成时间
func getTimeString(Timestamp: Int) -> String {
    
    let comicDate = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(Timestamp)))
    var tagString = ""
    if comicDate < 60 {
        tagString = "\(Int(comicDate))秒前"
    } else if comicDate < 3600 {
        tagString = "\(Int(comicDate / 60))分前"
    } else if comicDate < 86400 {
        tagString = "\(Int(comicDate / 3600))小时前"
    } else if comicDate < 31536000{
        tagString = "\(Int(comicDate / 86400))天前"
    } else {
        tagString = "\(Int(comicDate / 31536000))年前"
    }
    
    return tagString
    
}

//MARK:根据金额转成单位
func getUnitString(value: Int) -> String {
    var tagString = ""
    if value > 100000000 {
        tagString = String(format: "%.1f亿", Double(value) / 100000000)
    } else if value > 10000 {
        tagString = String(format: "%.1f万", Double(value) / 10000)
    } else {
        tagString = "\(value)"
    }
    return tagString
}

///通知
extension Notification.Name{
    static let USexTypeDidChange = NSNotification.Name("USexTypeDidChange")
}
//MARK:SnapKit
extension ConstraintView {
    var usnp:ConstraintBasicAttributesDSL {
     
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }else{
            return self.snp
        }
    }
}

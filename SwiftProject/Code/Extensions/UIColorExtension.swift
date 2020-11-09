//
//  UIColorExtension.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/29.
//


extension UIColor {
    
    ///初始化器
    convenience init(r:UInt32,g:UInt32,b:UInt32,a:CGFloat = 1.0) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
    }
    
    ///随机色
    class var randomColor: UIColor {
        
        return UIColor( r: arc4random_uniform(256),
                        g: arc4random_uniform(256),
                        b: arc4random_uniform(256))
        
    }
    ///主题色
    class var theme: UIColor {
        return UIColor(r: 29, g: 221, b: 43)
    }
    
    ///十六进制颜色
    class func hex(hexString: String) -> UIColor {
        
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 { return UIColor.black }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") { cString = String(subString) }
        if cString.hasPrefix("#") { cString = String(subString) }
        
        if cString.count != 6 { return UIColor.black }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(r: r, g: g, b: b)
        
    }
    ///主题背景色
    class var customBackgroudColor:UIColor{
        
        return UIColor(r: 242, g: 242, b: 242)
    }
    
    ///根据颜色生成图片
    func image() -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let content = UIGraphicsGetCurrentContext()
        content?.setFillColor(self.cgColor)
        content?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
        
        
    }
}

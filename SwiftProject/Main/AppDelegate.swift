//
//  AppDelegate.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/29.
//

import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var reachbility: NetworkReachabilityManager? = {
        return NetworkReachabilityManager(host: "http://app.u17.com")
    }()

    var orientation:UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configBase()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func configBase(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //MARK: 性别缓存
        let defaults = UserDefaults.standard
        if defaults.value(forKey: String.sexTypeKey) == nil {
            defaults.setValue(1, forKey: String.sexTypeKey)
            defaults.synchronize()
        }
        
        //MARK: 网络监测
        reachbility?.startListening{ status in
        }
        
    }



}

extension UIApplication{
    
    class func changeOrientationTo(landscapeRight: Bool){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        if landscapeRight {
            delegate.orientation = .landscapeRight
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }else{
            delegate.orientation = .portrait
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        }
        
    }
    
}

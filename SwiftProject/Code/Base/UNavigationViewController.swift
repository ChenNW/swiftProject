//
//  UNavigationViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/30.
//

import UIKit

class UNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let gesture = interactivePopGestureRecognizer else {return}
        guard let targetView = gesture.view else {return}
        guard let internalTargets = gesture.value(forKey: "targets") as? [NSObject] else {
            return
        }
        guard let internalTarget = internalTargets.first?.value(forKey: "target") else {
            return
        }
        
        let action = Selector(("handleNavigationTransition:"))
        let fullScreenGesture = UIPanGestureRecognizer(target: internalTarget, action: action)
        fullScreenGesture.delegate = self
        targetView.addGestureRecognizer(fullScreenGesture)
        gesture.isEnabled = false
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension UNavigationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        guard let ges = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        
        if ges.translation(in: gestureRecognizer.view).x * (isLeftToRight ? 1: -1) <= 0 || disablePopGesture {
            return false
        }
        
        return viewControllers.count != 1
    }
    
}

extension UNavigationViewController {
    override var preferredStatusBarStyle:UIStatusBarStyle {
        
        guard let topVC = topViewController else {
            return .lightContent
        }
        return topVC.preferredStatusBarStyle
    }
}

enum UNavigationBarStyle {
    case theme
    case clear
    case white
}

extension UINavigationController {
    
    private struct AssoctcatedKeys {
        static var disablePopGesture: Void?
    }
    
    var disablePopGesture: Bool {
        
        set {
            objc_setAssociatedObject(self, &AssoctcatedKeys.disablePopGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssoctcatedKeys.disablePopGesture) as? Bool ?? false
        }
    }
    
    func barStyle (_ style: UNavigationBarStyle){
        
        switch style {
        case .theme:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            navigationBar.shadowImage = UIImage()
            
        case .clear:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        
        case .white:
            navigationBar.barStyle = .default
            navigationBar.setBackgroundImage(UIColor.white.image(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
    }
    
    
}

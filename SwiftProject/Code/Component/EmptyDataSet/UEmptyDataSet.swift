//
//  UEmptyDataSet.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/3.
//

import EmptyDataSet_Swift

extension UIScrollView {
    
    private struct AssociatedKeys {
        static var uemptyKey: Void?
    }
    
    var uempty:UEmptyView?{
        
        set{
            self.emptyDataSetSource = newValue
            self.emptyDataSetDelegate = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.uemptyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.uemptyKey) as? UEmptyView
        }
        
    }
    
    
    
    
}

class UEmptyView: EmptyDataSetSource,EmptyDataSetDelegate {
    
    var image:UIImage?
    var allowShow:Bool = false
    var verticalOffset:CGFloat = 0
    private var tapClosure:(()-> Void)?
    
    
    init(image: UIImage? = UIImage(named: "nodata"),verticalOffset: CGFloat = 0,tapClosure: (()-> Void)?) {
        self.image = image
        self.verticalOffset = verticalOffset
        self.tapClosure = tapClosure
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return verticalOffset
    }
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        image
    }
    ///是否显示占位图
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        allowShow
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        guard let tapClosure = tapClosure else {
            return
        }
        tapClosure()
    }
    
    
    
    
    
}

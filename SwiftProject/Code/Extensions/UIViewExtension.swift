//
//  UIViewExtension.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/5.
//


extension UIView {
    
    private struct AssociatedKeys{
        static var descriptiveName =  "AssociatedKeys.DescriptiveName.blurView"
    }
    
    private (set) var blurView:BlurView{
        get{
            
            if let blurView = objc_getAssociatedObject(self, &AssociatedKeys.descriptiveName) as? BlurView{
                return blurView
            }
            self.blurView = BlurView(to: self)
            return self.blurView
        }
        set(blurView){
            objc_setAssociatedObject(self, &AssociatedKeys.descriptiveName, blurView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
        
    }
    
    
    class BlurView{
        
        private var superview:UIView
        private var blur:UIVisualEffectView?
        private var editing:Bool = false
        private (set) var blurContentView: UIView?
        private (set) var vibrancyContentView:UIView?
        
        var animatonDuration:TimeInterval = 0.1

        ///style
        var style:UIBlurEffect.Style = .light {
            didSet{
                guard oldValue != style,!editing else {
                    return
                }
                applyBlurEffect()
            }
        }
        ///alpha
        var alpha:CGFloat = 0{
            didSet{
                guard !editing else {
                    return
                }
                if blur == nil {
                    applyBlurEffect()
                }
                
                let alpha = self.alpha
                UIView.animate(withDuration: animatonDuration) {
                    self.blur?.alpha = alpha
                }
            }
        }
        
        init(to view: UIView) {
            self.superview = view
        }
        
        func setup(style: UIBlurEffect.Style,alpha: CGFloat) -> Self{
            self.editing = true
            self.style = style
            self.alpha = alpha
            self.editing = false
            return self
            
        }
        func enable(isHidden: Bool = false){
            if blur == nil {
                applyBlurEffect()
            }
            self.blur?.isHidden = isHidden
        }
        
        private func applyBlurEffect(){
            blur?.removeFromSuperview()
            applyBlurEffect(
                style:style,
                blurAlpha:alpha
            )
        }
        
        private func applyBlurEffect(style:UIBlurEffect.Style,blurAlpha:CGFloat){
            
            superview.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            let vibranceEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyView = UIVisualEffectView(effect: vibranceEffect)
            
            blurEffectView.alpha = blurAlpha
            superview.insertSubview(blurEffectView, at: 0)
            
            blurEffectView.addAlignedConstrains()
            vibrancyView.addAlignedConstrains()
            
            self.blur = blurEffectView
            self.blurContentView = blurEffectView.contentView
            self.vibrancyContentView = vibrancyView.contentView
        
        }
        
    }
    
    private func addAlignedConstrains(){
        
        translatesAutoresizingMaskIntoConstraints = false
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.top)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.left)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.bottom)
        addAlignConstraintToSuperview(attribute: NSLayoutConstraint.Attribute.right)
        
    }
    
    private func addAlignConstraintToSuperview(attribute:NSLayoutConstraint.Attribute){
        superview?.addConstraint(
            NSLayoutConstraint(
            
                item: self,
                attribute: attribute,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1, constant: 0
                
            )
        
        )
    }
    
    
}

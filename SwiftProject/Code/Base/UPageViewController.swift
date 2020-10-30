//
//  UPageViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/30.
//

import UIKit
enum UPageStyle {
    case none
    case navgationBarSegment
    case topTabBar
}


class UPageViewController: UBaseViewController {
    
    
    var pageStyle: UPageStyle!
    ///分段选择
    lazy var segment = HMSegmentedControl().then {
        $0.addTarget(self, action: #selector(segmentControlClicked(segment:)), for: .valueChanged)
    }
    ///UIPageCOntroller
    lazy var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    ///属性
    private(set) var controllers: [UIViewController]!
    private(set) var titles: [String]!
    private var currentIndex:Int = 0
    
    convenience init(titles:[String] = [],controllers: [UIViewController] = [],style:UPageStyle = .none) {
        self.init()
        self.titles = titles
        self.controllers = controllers
        self.pageStyle = style
    }

    @objc func segmentControlClicked (segment:UISegmentedControl){
        let index = segment.selectedSegmentIndex
        if currentIndex != index {
            let target:[UIViewController] = [controllers[index]]
            let direction:UIPageViewController.NavigationDirection = currentIndex > index ?.reverse:.forward
            pageController.setViewControllers(target, direction: direction, animated: false) {_ in
                self.currentIndex = index
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configUI (){
        guard let vcs = controllers else {return}
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.setViewControllers([vcs[0]], direction: .forward, animated: true, completion: nil)
        
        pageController.delegate = self
        pageController.dataSource = self
        
        switch pageStyle {
        case .none:
            pageController.view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        case .navgationBarSegment:
            segment.backgroundColor = .clear
            segment.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(white: 1, alpha: 0.5),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20)]
            segment.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20)]
            segment.selectionIndicatorLocation = .bottom
            segment.selectionIndicatorColor = .white
            segment.borderWidth = 0.5
            segment.selectionIndicatorHeight = 3
            navigationItem.titleView = segment
            segment.frame = CGRect(x: 0, y: 0, width: view.mj_size.width - 120, height: 40)
            pageController.view.snp.makeConstraints{$0.edges.equalToSuperview()}
            
        case .topTabBar:
            segment.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            segment.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor(r: 127, g: 221, b: 146),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 15)]
            segment.selectionIndicatorLocation = .bottom
            segment.selectionIndicatorColor = UIColor(r: 127, g: 221, b: 146)
            segment.selectionIndicatorHeight = 1
            segment.borderColor = .lightGray
            segment.borderWidth = 0.5
            view.addSubview(segment)
            
            segment.snp.makeConstraints{
                $0.top.left.right.equalToSuperview()
                $0.height.equalTo(40)
            }
            pageController.view.snp.makeConstraints{
                $0.top.equalTo(segment.snp.bottom)
                $0.bottom.left.right.equalToSuperview()
            }
            
            
        default:break
            
        }
        
        guard let titles = titles else {
            return
        }
        
        segment.sectionTitles = titles
        currentIndex = 0
        segment.selectedSegmentIndex = UInt(currentIndex)
        
    }

}

extension UPageViewController:UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = controllers.firstIndex(of: viewController) else {
            return nil
        }
        let beforeIndex = index - 1
        guard beforeIndex >= 0 else {
            return nil
        }
        
        return controllers[beforeIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = controllers.firstIndex(of: viewController) else {
            return nil
        }
        let afterIndex = index + 1
        guard afterIndex <= controllers.count - 1 else {
            return nil
        }
        
        return controllers[afterIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewController = pageViewController.viewControllers?.last,let index = controllers.firstIndex(of: viewController) else {
            return
        }
        
        currentIndex = index
        segment.setSelectedSegmentIndex(UInt(index), animated: true)
        guard titles != nil && pageStyle == .none else {
            return
        }
        navigationItem.title = titles[index]
    }
    
    
    
    
}

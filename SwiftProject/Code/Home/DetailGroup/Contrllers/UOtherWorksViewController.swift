//
//  UOtherWorksViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/9.
//

import UIKit

class UOtherWorksViewController: UBaseViewController {
    
    var otherWorks: [OtherWorkModel]?
    
    
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 5
        let cw = UICollectionView(frame: .zero, collectionViewLayout: flow)
        cw.backgroundColor = UIColor.customBackgroudColor
        cw.dataSource = self
        cw.delegate = self
        cw.register(cellType: UOtherWorksCCell.self)
        return cw
    }()
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.title = "其他作品"
    }
    
    convenience init(otherWorks: [OtherWorkModel]?) {
        self.init()
        self.otherWorks = otherWorks
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UOtherWorksViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        otherWorks?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40)/3
        return CGSize(width: width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UOtherWorksCCell.self)
        cell.model = otherWorks?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let model = otherWorks?[indexPath.item] else {
            return
        }
        let vc = UComicViewController(detailId: model.comicId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

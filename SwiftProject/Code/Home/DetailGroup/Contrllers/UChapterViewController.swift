//
//  UChapterViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/5.
//

import UIKit

class UChapterViewController: UBaseViewController {

    var detailStaticModel: DetailStaticModel?
    var detailRealtimeModel: DetailRealtimeModel?
    weak var delegate: UComicViewWillEndDraggingDelegate?
    
    private var isPositive:Bool = true
    
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        ///整个组的内间距
        flow.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        ///跟滚动方向一致间距
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 5
        flow.itemSize = CGSize(width: (screenWidth - 30)/2, height: 40)
        let vc = UICollectionView(frame: .zero, collectionViewLayout: flow)
        vc.backgroundColor = .white
        vc.alwaysBounceVertical = true
        vc.delegate = self
        vc.dataSource = self
        vc.register(cellType: UChapterCCell.self)
        vc.register(supplementaryViewType: UChapterCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        return vc
    }()
    
    override func configUI() {
        view.backgroundColor = .red
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func reloadData(){
        collectionView.reloadData()
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

extension UChapterViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource
{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailStaticModel?.chapter_list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UChapterCCell.self)
        if self.isPositive == true {
            cell.model = detailStaticModel?.chapter_list?[indexPath.item]
        }else{
            cell.model = detailStaticModel?.chapter_list?.reversed()[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath,viewType: UChapterCHead.self)
        head.model = detailStaticModel
        head.buttonAction = {[weak self] button in
         
            if self?.isPositive == true {
                self?.isPositive = false
                button.setTitle("正序", for: .normal)
            }else{
                self?.isPositive = true
                button.setTitle("倒序", for: .normal)
            }
            self?.collectionView.reloadData()
        }
        return head
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = isPositive ? indexPath.row : ((detailStaticModel?.chapter_list?.count)! - indexPath.row - 1)
        let  vc  = UReadViewController(detailStatic: detailStaticModel, selectedIndex: index)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

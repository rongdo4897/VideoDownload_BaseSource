//
//  BannerCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/13/21.
//

import UIKit
import FSPagerView

protocol BannerCellDelegate: class {
    func onClickMoreInfo()
}

class BannerCell: BaseTBCell {

    @IBOutlet weak var collectionView: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    
    var timer = Timer()
    var currentIndex: Int = 0
    var data: [Banner] = [Banner]()
    weak var delegate: BannerCellDelegate?
    let screenSize: CGFloat = UIScreen.main.bounds.width
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initData()
        initComponent()
    }

    fileprivate func initData() {
        
    }

    fileprivate func initComponent() {
        self.selectionStyle = .none
        self.setUpCollection()
        self.pageControl.contentHorizontalAlignment = .left
        self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.pageControl.backgroundColor = .clear
        pageControl.setFillColor(#colorLiteral(red: 0.5568627451, green: 0.5764705882, blue: 0.5882352941, alpha: 1), for: .normal)
        pageControl.setFillColor(#colorLiteral(red: 0.2980392157, green: 0.5803921569, blue: 0.4549019608, alpha: 1), for: .selected)
    }

    func setUpCollection() {
        self.collectionView.register(UINib(nibName: "BannerPagerCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BannerPagerCell")
        self.collectionView.itemSize = CGSize(width: screenSize, height: HomeConstant.bannerCellHeight)
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    func setUpCell(data: [Banner]) {
        self.data = data
        pageControl.numberOfPages = data.count
        if data.count > 1 {
            self.collectionView.isInfinite = !self.collectionView.isInfinite
        } else {
            self.collectionView.isInfinite = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension BannerCell: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return data.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BannerPagerCell", at: index) as? BannerPagerCell else { return BannerPagerCell() }
        cell.setUpCell(data: data[index])
        cell.backgroundColor = .clear
        cell.contentView.layer.shadowColor = UIColor.clear.cgColor
        return cell
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.delegate?.onClickMoreInfo()
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}

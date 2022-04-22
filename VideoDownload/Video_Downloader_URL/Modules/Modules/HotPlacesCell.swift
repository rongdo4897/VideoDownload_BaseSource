//
//  HotPlacesCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/13/21.
//

import UIKit

protocol HotPlacesCellDeleagte: class {
    func collectionView(collectioncell: HotPlacesCollectionCell?, didTappedInTableview TableCell: HotPlacesCell, indexPath: IndexPath)
}

class HotPlacesCell: BaseTBCell {

    @IBOutlet weak var lbSeeAll: UILabel!
    @IBOutlet weak var lbHotPlaces: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var data: [RecommendedTrip] = [RecommendedTrip]()
    weak var delegate: HotPlacesCellDeleagte?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initData()
        initComponent()
    }

    fileprivate func initData() {
        
    }

    fileprivate func initComponent() {
        self.selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        HotPlacesCollectionCell.registerCellByNib(collectionView)

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }

        lbHotPlaces.text = HomeConstant.hotPlaces
        lbSeeAll.text = HomeConstant.seeAll
    }

    func setUpCell(data: [RecommendedTrip]) {
        self.data = data
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HotPlacesCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = HotPlacesCollectionCell.loadCell(collectionView, path: indexPath) as? HotPlacesCollectionCell else {return UICollectionViewCell()}
        cell.setUpCell(data: data[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HomeConstant.hotPlacesCellWidth, height: HomeConstant.hotPlacesCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = HotPlacesCollectionCell.loadCell(collectionView, path: indexPath) as? HotPlacesCollectionCell
        self.delegate?.collectionView(collectioncell: cell, didTappedInTableview: self, indexPath: indexPath)
    }
}

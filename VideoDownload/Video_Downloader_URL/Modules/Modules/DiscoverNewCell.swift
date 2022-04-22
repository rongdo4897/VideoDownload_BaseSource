//
//  DiscoverNewCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/13/21.
//

import UIKit
protocol DiscoverNewCellDelegate: class {
    func collectionView(collectioncell: DiscoverNewCollectionCell?, didTappedInTableview TableCell: DiscoverNewCell, indexPath: IndexPath)
}
class DiscoverNewCell: BaseTBCell {

    @IBOutlet weak var lbSeeAll: UILabel!
    @IBOutlet weak var lbDiscoverNew: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var data: [RecommendedTrip] = [RecommendedTrip]()
    weak var delegate: DiscoverNewCellDelegate?

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
        DiscoverNewCollectionCell.registerCellByNib(collectionView)

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }

        lbDiscoverNew.text = HomeConstant.discoverNew
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

extension DiscoverNewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = DiscoverNewCollectionCell.loadCell(collectionView, path: indexPath) as? DiscoverNewCollectionCell else {return UICollectionViewCell()}
        cell.setUpCell(data: data[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HomeConstant.discoverNewCellWidth, height: HomeConstant.discoverNewCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = DiscoverNewCollectionCell.loadCell(collectionView, path: indexPath) as? DiscoverNewCollectionCell
        self.delegate?.collectionView(collectioncell: cell, didTappedInTableview: self, indexPath: indexPath)
    }
}

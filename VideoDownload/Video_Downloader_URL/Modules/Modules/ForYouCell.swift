//
//  ForYouCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/13/21.
//

import UIKit

protocol ForYouCellDelegate: class {
    func collectionView(collectioncell: ForYouCollectionCell?, didTappedInTableview TableCell: ForYouCell, indexPath: IndexPath)
}

class ForYouCell: BaseTBCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbForYou: UILabel!
    @IBOutlet weak var lbSeeAll: UILabel!
    
    
    weak var delegate: ForYouCellDelegate?
    var data: [RecommendedTrip] = [RecommendedTrip]()

    override func awakeFromNib() {
        super.awakeFromNib()
       initData()
        initComponent()
    }

    fileprivate func initData() {
        
    }

    fileprivate func initComponent () {
        self.selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        ForYouCollectionCell.registerCellByNib(collectionView)

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }

        lbForYou.text = HomeConstant.forYou
        lbSeeAll.text = HomeConstant.seeAll
    }

    func setUpCell(data: [RecommendedTrip]) {
        self.data = data
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension ForYouCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = ForYouCollectionCell.loadCell(collectionView, path: indexPath) as? ForYouCollectionCell else {return UICollectionViewCell()}
        cell.setUpCell(data: data[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: HomeConstant.forYouCellWidth, height: HomeConstant.forYouCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = ForYouCollectionCell.loadCell(collectionView, path: indexPath) as? ForYouCollectionCell
        self.delegate?.collectionView(collectioncell: cell, didTappedInTableview: self, indexPath: indexPath)
    }
}

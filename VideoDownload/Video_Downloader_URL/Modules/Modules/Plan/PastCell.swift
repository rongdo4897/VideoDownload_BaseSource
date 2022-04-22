//
//  PastCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 15/04/2021.
//

import UIKit

protocol PastCellDelegate: class {
    func collectionView(collectioncell: PastCollectionCell?, didTappedInTableview TableCell: PastCell, indexPath: IndexPath)
}

class PastCell: BaseTBCell {

    @IBOutlet weak var lbPast: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbSeeAll: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    weak var delegate: PastCellDelegate?
    var data: [Plan] = [Plan]()

    override func awakeFromNib() {
        super.awakeFromNib()
        initComponent()
    }

    fileprivate func initComponent() {
        self.selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        PastCollectionCell.registerCellByNib(collectionView)
    
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }

        lbPast.text = PlanConstant.past
        lbSeeAll.text = PlanConstant.seeAll
    }

    func setUpData(data: [Plan]) {
        self.data = data
        if data.isEmpty {
            viewTitle.isHidden = true
        } else {
            viewTitle.isHidden = false
        }
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PastCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.count < 5 {
            return data.count
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = PastCollectionCell.loadCell(collectionView, path: indexPath) as? PastCollectionCell else {return UICollectionViewCell()}
        if !data.isEmpty {
            cell.setUpCell(data: data[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.width - PlanConstant.lineSpacingCell) / 2, height: PlanConstant.pastCollectionHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PlanConstant.lineSpacingCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return PlanConstant.lineSpacingCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = PastCollectionCell.loadCell(collectionView, path: indexPath) as? PastCollectionCell
        self.delegate?.collectionView(collectioncell: cell, didTappedInTableview: self, indexPath: indexPath)
    }
}

//
//  PlannedCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 15/04/2021.
//

import UIKit

protocol PlannedCellDelegate: class {
    func collectionView(collectioncell: PlannedCollectionCell?, didTappedInTableview TableCell: PlannedCell, indexPath: IndexPath)
}

class PlannedCell: BaseTBCell {

    @IBOutlet weak var lbFuture: UILabel!
    @IBOutlet weak var lbSeeAll: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: PlannedCellDelegate?
    var data: [Plan] = [Plan]()

    override func awakeFromNib() {
        super.awakeFromNib()
        initComponent()
    }

    fileprivate func initComponent() {
        self.selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        PlannedCollectionCell.registerCellByNib(collectionView)

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }

        lbFuture.text = PlanConstant.future
        lbSeeAll.text = PlanConstant.seeAll
    }

    func setUpData(data: [Plan]) {
        self.data = data
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension PlannedCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.count < 5 {
            return data.count
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = PlannedCollectionCell.loadCell(collectionView, path: indexPath) as? PlannedCollectionCell else {return UICollectionViewCell()}
        if !data.isEmpty {
            cell.setUpCell(data: data[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: PlanConstant.plannedCollectionWidth, height: PlanConstant.plannedCollectionHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = PlannedCollectionCell.loadCell(collectionView, path: indexPath) as? PlannedCollectionCell
        self.delegate?.collectionView(collectioncell: cell, didTappedInTableview: self, indexPath: indexPath)
    }
}

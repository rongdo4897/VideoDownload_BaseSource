//
//  DetailsBottomCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 14/04/2021.
//

import UIKit
import ImageViewer_swift

class DetailsBottomCell: BaseTBCell {

    @IBOutlet weak var collectionView: UICollectionView!

    var gallaries: [Banner] = [Banner]()
    var imagesName = [String]()
    var images = [UIImage]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initComponent()
    }

    fileprivate func initComponent() {
        self.selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        GalleryCollectionCell.registerCellByNib(collectionView)

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }

    func setUpData(data: [Banner]) {
        self.gallaries = data
        gallaries.forEach { (gallary) in
            self.imagesName.append(gallary.image ?? "")
        }
        images = self.imagesName.compactMap { UIImage(named: $0)! }
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension DetailsBottomCell: UICollisionBehaviorDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = GalleryCollectionCell.loadCell(collectionView, path: indexPath) as? GalleryCollectionCell else {
            return UICollectionViewCell()
        }
        cell.setUpCell(image: gallaries[indexPath.row].image ?? "")
        cell.gallary.setupImageViewer(images: images, initialIndex: indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.width - HomeConstant.lineSpacingCell) / 2, height: HomeConstant.recommendCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return HomeConstant.lineSpacingCell
    }
}

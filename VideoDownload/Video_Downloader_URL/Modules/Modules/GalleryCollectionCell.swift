//
//  GalleryCollectionCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 15/04/2021.
//

import UIKit

class GalleryCollectionCell: BaseCLCell {

    @IBOutlet weak var gallary: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setUpCell(image: String) {
        gallary.layer.cornerRadius = 10
        gallary.image = UIImage(named: image)
    }

}

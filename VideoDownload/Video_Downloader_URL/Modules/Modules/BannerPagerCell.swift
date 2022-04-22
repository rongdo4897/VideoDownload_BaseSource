//
//  BannerPagerCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 16/04/2021.
//

import UIKit
import FSPagerView

class BannerPagerCell: FSPagerViewCell {

    @IBOutlet weak var imgBanner: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setUpCell(data: Banner) {
        imgBanner.image = UIImage(named: data.image ?? "")
    }
}

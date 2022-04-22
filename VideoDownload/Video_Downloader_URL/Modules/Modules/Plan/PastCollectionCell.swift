//
//  PastCollectionCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 15/04/2021.
//

import UIKit
import Kingfisher

class PastCollectionCell: BaseCLCell {

    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbTimeAgo: UILabel!
    @IBOutlet weak var viewCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(data: Plan) {
        // setup view
        imgLocation.layer.cornerRadius = 10
        imgLocation.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        imgLocation.roundCorners([.topLeft, .topRight], radius: 10)
        // setup data
        imgLocation.kf.setImage(with: URL(string: data.imgUrl ?? ""))
        lbLocation.text = data.place?.placeName
        if let date = data.end?.getDateFromUTC() {
            lbTimeAgo.text = date.getElapsedInterval
        }
    }

}

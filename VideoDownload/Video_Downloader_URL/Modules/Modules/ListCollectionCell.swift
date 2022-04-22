//
//  ListCollectionCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 19/04/2021.
//

import UIKit

class ListCollectionCell: BaseCLCell {

    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(data: RecommendedTrip) {
        // setup view
        viewCell.layer.cornerRadius = 5
        imgLocation.layer.cornerRadius = 5
        // setup data
        imgLocation.image = UIImage(named: data.image ?? "")
        lbName.text = data.name
        lbLocation.text = data.location
    }
}

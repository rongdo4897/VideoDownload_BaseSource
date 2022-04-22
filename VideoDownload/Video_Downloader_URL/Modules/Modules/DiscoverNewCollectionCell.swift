//
//  DiscoverNewCollectionCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/13/21.
//

import UIKit

class DiscoverNewCollectionCell: BaseCLCell {

    @IBOutlet weak var imageLocation: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(data: RecommendedTrip) {
        // setup view
        imageLocation.layer.cornerRadius = 10
        // setup data
        imageLocation.image = UIImage(named: data.image ?? "")
        lbName.text = data.name
        lbLocation.text = data.location
    }

}

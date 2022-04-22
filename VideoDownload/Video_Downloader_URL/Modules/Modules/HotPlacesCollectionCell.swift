//
//  HotPlacesCollectionCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/13/21.
//

import UIKit

class HotPlacesCollectionCell: BaseCLCell {

    @IBOutlet weak var imageLocation: UIImageView!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbTravelers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setUpCell(data: RecommendedTrip) {
        // setup view
        imageLocation.layer.cornerRadius = 10
        // setup data
        imageLocation.image = UIImage(named: data.image ?? "")
        lbLocation.text = "\(data.name ?? ""), \(data.location ?? "")"
        lbTravelers.text = "\(data.travelers ?? 0) travelers now"
    }

}

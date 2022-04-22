//
//  PlannedCollectionCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 15/04/2021.
//

import UIKit
import Kingfisher

class PlannedCollectionCell: BaseCLCell {

    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbMonth: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(data: Plan) {
        // setup view
        imgLocation.layer.cornerRadius = 10
        viewDate.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        viewDate.addShadow(radius: 4, width: 0, height: -1)
        viewDate.layer.cornerRadius = 10
        
        // setup data
        lbLocation.text = "\(data.title ?? ""), \(data.place?.placeName ?? "")"
        imgLocation.kf.setImage(with: URL(string: data.imgUrl ?? ""))
        if let startDate = data.start?.getDateFromUTC(), let endDate = data.end?.getDateFromUTC() {
            lbDay.text = startDate.day
            lbMonth.text = startDate.month
            lbTime.text = "\(startDate.day) \(startDate.month) - \(endDate.day) \(endDate.month)"
        }
    }

}

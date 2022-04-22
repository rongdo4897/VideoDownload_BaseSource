//
//  DayCell.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 14/04/2021.
//

import UIKit

class DayCell: BaseCLCell {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbDayTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 10
    }
    
    func setUp(data: DayTitle) {
        lbDayTitle.text = data.title
        lbDate.text = data.dateString
        if data.isHightlighted {
            backView.layer.borderColor = Defined.midBlue.cgColor
            backView.layer.borderWidth = 2
            backView.addShadow(radius: 4)
        } else {
            backView.layer.borderColor = Defined.belowLightGray.cgColor
            backView.layer.borderWidth = 1
            backView.removeShadow()
        }
    }

}

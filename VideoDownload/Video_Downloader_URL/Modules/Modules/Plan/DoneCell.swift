//
//  DoneCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/13/21.
//

import UIKit
import Kingfisher

protocol DoneCellDelegate: class {
    func onClickShare()
}
class DoneCell: BaseTBCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imageTrip: UIImageView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbBudget: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbBudgetText: UILabel!
    
    weak var delegate: DoneCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
    }

    func setUpCell(data: Plan) {
        // setup view
        viewCell.addShadow(shadowRadius: 8)
        imageTrip.layer.cornerRadius = 10
        imageTrip.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        btnShare.layer.cornerRadius = btnShare.height / 2
        btnShare.addShadow(radius: 4)
        viewInfo.layer.cornerRadius = 10
        viewInfo.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        viewInfo.addShadow(radius: 4, width: -2, height: -2)
        viewDate.layer.cornerRadius = 10
        viewDate.layer.maskedCorners = [.layerMinXMaxYCorner]
        Constants.formatter.groupingSeparator = "."
        Constants.formatter.numberStyle = .decimal
        btnShare.setTitle(HomeConstant.shareNow, for: .normal)
        lbBudgetText.text = HomeConstant.budget

        // setup data
        lbTitle.text = "\(HomeConstant.doneMessage) \(data.place?.placeName ?? "")"
        lbBudget.text = "\(Constants.formatter.string(from: NSNumber(value: data.budget ?? 0)) ?? "") VND"
        imageTrip.kf.setImage(with: URL(string: data.imgUrl ?? ""))

        if let startDate = data.start?.getDateFromUTC(), let endDate = data.end?.getDateFromUTC() {
            let count = (Int(endDate.day) ?? 0) - (Int(startDate.day) ?? 0)
            lbDate.text = (count <= 1) ? "\(count + 1) \(HomeConstant.day)" : "\(count + 1) \(HomeConstant.days)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickShare(_ sender: UIButton) {
        sender.showAnimation {
            self.delegate?.onClickShare()
        }
        
    }
}

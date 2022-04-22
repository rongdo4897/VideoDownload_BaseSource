//
//  OngoingCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/13/21.
//

import UIKit
import Kingfisher

protocol OngoingCellDelegate: class {
    func onclickViewDetails()
}

class OngoingCell: BaseTBCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imageTrip: UIImageView!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbBudget: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbBudgetText: UILabel!
    
    weak var delegate: OngoingCellDelegate?
    var date: Date = Date()
    let dateFormatter: DateFormatter = {
        let formartDate = DateFormatter()
        formartDate.dateFormat = "dd/MM/yyyy"
        formartDate.timeZone = TimeZone(abbreviation: "UTC")
        formartDate.locale = Locale.current
        return formartDate
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

    }

    func setUpCell(data: Plan) {
        // setup view
        viewCell.addShadow(shadowRadius: 8)
        imageTrip.layer.cornerRadius = 10
        imageTrip.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        btnView.layer.cornerRadius = btnView.height / 2
        btnView.addShadow(radius: 6)
        viewInfo.layer.cornerRadius = 10
        viewInfo.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        viewInfo.addShadow(radius: 4, width: -2, height: -2)
        viewDate.layer.cornerRadius = 10
        viewDate.layer.maskedCorners = [.layerMinXMaxYCorner]
        Constants.formatter.groupingSeparator = "."
        Constants.formatter.numberStyle = .decimal

        lbBudgetText.text = HomeConstant.budget
        btnView.setTitle(HomeConstant.viewDetails, for: .normal)

        // setup data
        lbTitle.text = "\(HomeConstant.ongoingMessage) \(data.place?.placeName ?? "")"
        lbBudget.text = "\(Constants.formatter.string(from: NSNumber(value: data.budget ?? 0)) ?? "") VND"
        imageTrip.kf.setImage(with: URL(string: data.imgUrl ?? ""))
        let time = dateFormatter.date(from: self.dateFormatter.string(from: self.date)) ?? Date()
        if let startDate = data.start?.getDateFromUTC(), let endDate = data.end?.getDateFromUTC() {
            let start = dateFormatter.date(from: self.dateFormatter.string(from: startDate)) ?? Date()
            let end = dateFormatter.date(from: self.dateFormatter.string(from: endDate)) ?? Date()
            if start == end {
                lbDate.text = HomeConstant.onDay
            } else if start == time {
                lbDate.text = HomeConstant.startingToday
            } else if end == time {
                lbDate.text = HomeConstant.enDay
            } else {
                let dayLeft = Calendar.current.dateComponents([.day], from: time, to: end)
                let dayString = Int(dayLeft.day ?? 0)
                lbDate.text = (dayString <= 1) ? "\(dayString) \(HomeConstant.dayLeft)" : "\(dayString) \(HomeConstant.daysLeft)"
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clickView(_ sender: UIButton) {
        sender.showAnimation {
            self.delegate?.onclickViewDetails()
        }
    }
    
}

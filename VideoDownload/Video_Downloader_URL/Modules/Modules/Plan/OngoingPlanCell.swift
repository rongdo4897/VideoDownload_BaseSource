//
//  OngoingPlanCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 15/04/2021.
//

import UIKit
import Kingfisher

class OngoingPlanCell: BaseTBCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbOngoing: UILabel!
    
    var date: Date = Date()
    let dateFormatter: DateFormatter = {
        let formartDate = DateFormatter()
        formartDate.timeZone = TimeZone(abbreviation: "UTC")
        formartDate.dateFormat = "dd/MM/yyyy"
        formartDate.locale = Locale.current
        return formartDate
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUpCell(data: Plan) {
        // setup view
        viewCell.addShadow(shadowRadius: 8)
        viewDate.layer.cornerRadius = 10
        viewDate.addShadow(radius: 4, width: 0, height: 2)
        viewDate.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        imgLocation.layer.cornerRadius = 10
        lbOngoing.text = PlanConstant.ongoing
        
        // setup data
        imgLocation.kf.setImage(with: URL(string: data.imgUrl ?? ""))
        lbName.text = data.title
        lbLocation.text = data.place?.placeName
        let time = dateFormatter.date(from: self.dateFormatter.string(from: self.date)) ?? Date()
        if let startDate = data.start?.getDateFromUTC(), let endDate = data.end?.getDateFromUTC() {
            let start = dateFormatter.date(from: self.dateFormatter.string(from: startDate)) ?? Date()
            let end = dateFormatter.date(from: self.dateFormatter.string(from: endDate)) ?? Date()
            lbTime.text = "\(start.day) \(start.month) - \(end.day) \(end.month)"
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
    
}

//
//  ListCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 15/04/2021.
//

import UIKit
import Kingfisher

class ListCell: BaseTBCell {

    @IBOutlet weak var progressView: CircularProgressBar!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbBudget: UILabel!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var viewCell: UIView!

    var progress: Double = 0.85

    override func awakeFromNib() {
        self.selectionStyle = .none
        super.awakeFromNib()
        viewCell.addShadow(shadowRadius: 4)
        progressView.labelSize = 15
        progressView.safePercent = 100
        progressView.setProgress(to: progress, withAnimation: true)
        let timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        Constants.formatter.groupingSeparator = "."
        Constants.formatter.numberStyle = .decimal
    }

    @objc func updateProgress() {
        progressView.setProgress(to: progress, withAnimation: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpCell(data: Plan) {
        imgLocation.kf.setImage(with: URL(string: data.imgUrl ?? ""))
        lbLocation.text = "\(data.title ?? ""), \(data.place?.placeName ?? "")"
        lbBudget.text = "\(Constants.formatter.string(from: NSNumber(value: data.budget ?? 0)) ?? "") VND"
        if let startDate = data.start?.getDateFromUTC(), let endDate = data.end?.getDateFromUTC() {
            self.lbDate.text = "\(startDate.fullDateString) - \(endDate.fullDateString)"
        }
        switch data.status {
        case PlanTrip.past.rawValue:
            progressView.isHidden = false
        default:
            progressView.isHidden = true
        }
    }
    
}

//
//  ItineraryItemCell.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 14/04/2021.
//

import UIKit

protocol ItineraryItemDelegate: class {
    func didClickNote(note: String)
}

class ItineraryItemCell: BaseTBCell {

    @IBOutlet weak var verticleDash: UIView!
    @IBOutlet weak var noteView: RectangularDashedView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var lbNo: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var imgTrip: UIImageView!
    @IBOutlet weak var lbNote: UILabel!
    @IBOutlet weak var lbBudget: UILabel!
    @IBOutlet weak var lbTripTitle: UILabel!
    @IBOutlet weak var lbTimeRange: UILabel!
    
    weak var delegate: ItineraryItemDelegate?
    var model: ItineraryModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        initComponents()
        addGestures()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initComponents() {
        circleView.layer.cornerRadius = circleView.frame.width / 2
        detailView.layer.cornerRadius = 6
        detailView.addShadow(radius: 4)
        noteView.layer.cornerRadius = 6
        imgTrip.image = #imageLiteral(resourceName: "travel2")
        imgTrip.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        imgTrip.layer.cornerRadius = 6
        imgTrip.contentMode = .scaleAspectFill
        verticleDash.createDottedLine(width: 1, color: UIColor.black.cgColor)
    }

    func addGestures() {
        let tapNote = UITapGestureRecognizer(target: self, action: #selector(handleTapNote))
        noteView.addGestureRecognizer(tapNote)
    }
    
    @objc func handleTapNote() {
        if let note = self.model?.note {
            self.delegate?.didClickNote(note: note)
        }
    }
    
    func setUp(data: ItineraryModel) {
        self.model = data
        lbTimeRange.text = "\(data.from) > \(data.to)"
        lbNo.text = data.no.description
        imgTrip.image = UIImage(named: data.imageUrl)!
        lbTripTitle.text = data.tripName
        lbBudget.text = data.budget
        if let note = data.note {
            lbNote.text = note
            noteView.isHidden = false
        }
    }
    
}

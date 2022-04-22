//
//  OverallInfoView.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 29/04/2021.
//

import UIKit

protocol OverallInfoViewDelegate: AnyObject {
    func clickItinerary()
    func clickEdit()
}

class OverallInfoView: BaseTBCell {
    
    @IBOutlet weak var btnDay: UIButton!
    weak var delegate: OverallInfoViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        initComponents()
        // Initialization code
    }
    
    func initComponents() {
        btnDay.layer.cornerRadius = 15
        btnDay.addShadow(radius: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickItinerary(_ sender: Any) {
        self.delegate?.clickItinerary()
    }
    
    
    @IBAction func clickEdit(_ sender: Any) {
        self.delegate?.clickEdit()
    }
    
}

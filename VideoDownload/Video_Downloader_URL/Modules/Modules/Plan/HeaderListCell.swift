//
//  HeaderListCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 15/04/2021.
//

import UIKit

class HeaderListCell: BaseTBCell {

    @IBOutlet weak var lbDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpCell(date: Date) {
        self.selectionStyle = .none
        lbDate.text = "\(date.month) \(date.year)"
    }
    
}

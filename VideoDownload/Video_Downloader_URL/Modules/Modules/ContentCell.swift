//
//  ContentCell.swift
//  Traveldy
//
//  Created by Huong Nguyen on 14/04/2021.
//

import UIKit

protocol ContentCellDelegate: class {
    func onClickReadMore(sender: Int)
}

class ContentCell: BaseTBCell {
    
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var graterHeightCons: NSLayoutConstraint!
    @IBOutlet weak var fixedHeightCons: NSLayoutConstraint!

    weak var delegate: ContentCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpCell(content: String) {
        self.selectionStyle = .none
        lbContent.text = content
    }
    
    @IBAction func changeHeightLabel(_ sender: UIButton) {
        self.delegate?.onClickReadMore(sender: sender.tag)
    }
}

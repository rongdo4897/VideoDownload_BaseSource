//
//  DateCalendarCell.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 19/04/2021.
//

import UIKit
import FSCalendar

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class DateCalendarCell: FSCalendarCell {

    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!

    fileprivate var boldGreen: UIColor = Defined.boldPinkColor
    fileprivate var lightGreen: UIColor = Defined.lightGreen
    fileprivate var darkBlue: UIColor = UIColor.clear

    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let circleImageView = UIImageView(image: UIImage(named: "ic_press_left")!)
        self.contentView.insertSubview(circleImageView, at: 0)
        self.circleImageView = circleImageView

        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = darkBlue.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, at: 0)
        self.selectionLayer = selectionLayer

        self.shapeLayer.isHidden = true
        self.titleLabel.textColor = UIColor.black
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        self.backgroundView = view

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = frame
        self.eventIndicator.isHidden = true
        self.backgroundView?.frame = self.bounds.insetBy(dx: 0, dy: 0)
        self.selectionLayer.frame = self.contentView.bounds
        self.selectionLayer.fillColor = UIColor.white.cgColor
        self.titleLabel.textColor = Defined.reuColor
        selectionLayer.sublayers?.removeAll()
        if isPlaceholder {
            self.titleLabel.textColor = Defined.lineColor
        } else {
            if selectionType == .middle || selectionType == .single {
                self.selectionLayer.fillColor = lightGreen.cgColor
                self.titleLabel.textColor = Defined.darkBlue
                self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
            } else if selectionType == .rightBorder {
                let layer = CAShapeLayer()
                let path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2))
                layer.path = path.cgPath
                layer.fillColor = boldGreen.cgColor
                self.selectionLayer.insertSublayer(layer, at: 0)
                self.titleLabel.textColor = .white
                self.selectionLayer.fillColor = lightGreen.cgColor
                self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
            } else if selectionType == .leftBorder {
                let layer = CAShapeLayer()
                let path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2))
                layer.path = path.cgPath
                layer.fillColor = boldGreen.cgColor
                self.selectionLayer.insertSublayer(layer, at: 0)
                self.titleLabel.textColor = .white
                self.selectionLayer.fillColor = lightGreen.cgColor
                self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
            } else {
                self.selectionLayer.fillColor = UIColor.white.cgColor
                self.titleLabel.textColor = Defined.darkBlue
                let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
                self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            }
        }
    }

    override func configureAppearance() {
        super.configureAppearance()
        self.eventIndicator.isHidden = true
    }

}

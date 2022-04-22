//
//  AlertView.swift
//  Traveldy
//
//  Created by Huong Nguyen on 16/04/2021.
//

import UIKit

protocol AlertViewDelegate: class {
    func onClickOK()
}

class AlertView: UIView {
    
    static let instance = AlertView()
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lbdescription: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    weak var delegate: AlertViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        initComponent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func initComponent() {
        lbdescription.text = "write something here \nwrite something here \nwrite something here \nwrite something here  4 lines."
        btnOk.layer.cornerRadius = btnOk.height / 2
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func showAlert() {
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }

    @IBAction func onClickOk(_ sender: Any) {
        self.delegate?.onClickOK()
        parentView.removeFromSuperview()
    }

    @IBAction func onClickCancel(_ sender: Any) {
        parentView.removeFromSuperview()
    }

}

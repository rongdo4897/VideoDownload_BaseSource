//
//  HourViewController.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 19/04/2021.
//

import UIKit

protocol HourDelegate: class {
    func clickDone(from: Date, to: Date)
}

class HourViewController: BaseViewController {
    
    @IBOutlet weak var lbTo: UILabel!
    @IBOutlet weak var lbFrom: UILabel!
    @IBOutlet weak var clockTo: UIDatePicker!
    @IBOutlet weak var clockFrom: UIDatePicker!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var btnDone: UIButton!
    
    //variables
    let formatter = DateFormatter()
    weak var delegate: HourDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
    }
    
    fileprivate func initComponents() {
        customizeLayouts()
        changeLanguage()
    }
    
    fileprivate func customizeLayouts() {
        fromView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        toView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        fromView.layer.cornerRadius = 13
        toView.layer.cornerRadius = 13
        fromView.layer.borderColor = UIColor.orange.cgColor
        toView.layer.borderColor = UIColor.orange.cgColor
        btnDone.layer.cornerRadius = 10
        btnDone.addShadow(radius: 6)
    }
    
    func changeLanguage() {
        lbFrom.text = "From"
        lbTo.text = "To"
        btnDone.setTitle("DONE", for: .normal)
    }
    
    fileprivate func initData() {
        
    }
    
    @IBAction func clickDone(_ sender: Any) {
        delegate?.clickDone(from: clockFrom.date, to: clockTo.date)
    }
    
}

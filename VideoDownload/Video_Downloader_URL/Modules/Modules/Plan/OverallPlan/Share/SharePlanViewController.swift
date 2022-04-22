//
//  SharePlanViewController.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 14/04/2021.
//

import UIKit

class SharePlanViewController: BaseViewController {

    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var screenTitle: UILabel!
    
    @IBOutlet weak var lbTitleShare2: UILabel!
    @IBOutlet weak var lbTitleShare1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
    }
    
    fileprivate func initComponents() {
        customizeLayouts()
        changeLanguage()
    }
    
    func changeLanguage() {
        screenTitle.text = "Share your plan"
        lbTitleShare1.text = "Share your " + "Da nang trip " + "instantly with the QR code below:"
        lbTitleShare2.text = "or share on:"
    }
    
    fileprivate func initData() {
        
    }
    
    func customizeLayouts() {
        btnFacebook.layer.cornerRadius = 6
        btnInsta.layer.cornerRadius = 6
        btnInsta.layer.borderWidth = 1
        btnInsta.layer.borderColor = Defined.darkBlue.cgColor
    }
    
    @IBAction func clickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

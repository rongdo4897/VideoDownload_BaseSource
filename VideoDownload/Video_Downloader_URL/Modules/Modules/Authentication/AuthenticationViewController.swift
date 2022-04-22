//
//  AuthenticationViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 16/04/2021.
//

import UIKit

class AuthenticationViewController: BaseViewController {

    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnGg: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initComponent()
    }

    fileprivate func initData() {
        
    }

    fileprivate func initComponent() {
        setUpButton(buttons: [btnFb, btnGg, btnApple])
        btnFb.layer.borderColor = #colorLiteral(red: 0.137254902, green: 0.3764705882, blue: 0.9960784314, alpha: 1)
        btnGg.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        btnApple.layer.borderColor = #colorLiteral(red: 0.5568627451, green: 0.5764705882, blue: 0.5882352941, alpha: 1)
        if UIDevice.current.hasNotch {
            imgTopConstraint.constant = AuthenticationConstant.imgTopConstraint
            btnTopConstraint.constant = AuthenticationConstant.topConstraint
        } else {
            imgTopConstraint.constant = AuthenticationConstant.imgTopConstraint2
            btnTopConstraint.constant = AuthenticationConstant.topConstraint2
        }
    }
    
    @IBAction func backToView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func connectWithFb(_ sender: UIButton) {
        sender.showAnimation {
            
        }
    }

    @IBAction func connectWithGg(_ sender: UIButton) {
        sender.showAnimation {
            
        }
    }
    
    @IBAction func signInWithApple(_ sender: UIButton) {
        sender.showAnimation {
            
        }
    }

    // Make rounded buttons
    func setUpButton(buttons: [UIButton]) {
        buttons.forEach { (button) in
            button.layer.cornerRadius = button.height / 2
            button.layer.borderWidth = 1
        }
    }
}

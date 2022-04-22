//
//  EditItineraryViewController.swift
//  Traveldy
//
//  Created by bigdreamer on 4/15/21.
//

import UIKit

class EditScheduleViewController: DismissKeyboardViewController {

    @IBOutlet weak var lbTitleOptional: UILabel!
    @IBOutlet weak var tfNote: UITextView!
    @IBOutlet weak var tfBudget: UITextField!
    @IBOutlet weak var tfPlace: UITextField!
    @IBOutlet weak var tfClock: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var model: ItineraryModel?
    let screenSize = UIScreen.main.bounds.size
    var hourView: HourViewController!
    let noteHeight: CGFloat = 385
    var blurBackView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
        
        if let model = self.model {
            tfClock.text = "\(model.from) - \(model.to)"
            self.tfNote.text = model.note ?? ""
            tfPlace.text = model.tripName
            tfBudget.text = model.budget
        }
    }
    
    fileprivate func initComponents() {
        customizeLayouts()
        changeLanguage()
        let tapClock = UITapGestureRecognizer(target: self, action: #selector(handleTapHour))
        tfClock.addGestureRecognizer(tapClock)
    }
    
    func changeLanguage() {
        tfClock.placeholder = "Select time range"
        tfPlace.placeholder = "Where you at?"
        tfBudget.placeholder = "Budget"
        lbTitleOptional.text = "optional"
        btnEdit.setTitle("Edit", for: .normal)
    }
    
    fileprivate func customizeLayouts() {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = Defined.belowLightGray.cgColor
        textView.layer.cornerRadius = 6
        btnEdit.layer.cornerRadius = 6
    }
    
    fileprivate func initData() {
        
    }
    
    @IBAction func clickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickEdit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTapHour() {
        view.endEditing(true)
        hourView = HourViewController()
        hourView.view.layer.cornerRadius = 30
        hourView.view.addShadow(radius: 8)
        hourView.delegate = self
        hourView.view.frame = CGRect(x: screenSize.width / 2 - 350 / 2, y: screenSize.height / 2 - noteHeight / 2 - 30, width: 350, height: noteHeight)
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            blurBackView.frame = self.view.frame
            blurBackView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
            window?.addSubview(blurBackView)
            window?.addSubview(hourView.view)
        } else {
            // Fallback on earlier versions
        }
        
        blurBackView.alpha = 0
        hourView.view.alpha = 0
        hourView.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseInOut) {
            self.blurBackView.alpha = 0.8
            self.hourView.view.transform = .identity
            self.hourView.view.alpha = 1
        }
    }
    
}

extension EditScheduleViewController : HourDelegate {
    func clickDone(from: Date, to: Date) {
        UIView.animate(
            withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut){
            self.hourView.view.alpha = 0
            self.blurBackView.alpha = 0
        } completion: { (complete) in
            self.blurBackView.removeFromSuperview()
            self.hourView.view.removeFromSuperview()
        }
        self.tfClock.text = "\(from.timeString) - \(to.timeString)"
    }
}


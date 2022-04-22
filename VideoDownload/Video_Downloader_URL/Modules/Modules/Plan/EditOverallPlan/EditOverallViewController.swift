//
//  EditOverallViewController.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 27/04/2021.
//

import UIKit

class EditOverallViewController: DismissKeyboardViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var lbTitleBudget: UILabel!
    @IBOutlet weak var lbTitleDate: UILabel!
    @IBOutlet weak var lbTitleDestination: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tfDestination: UITextField!
    @IBOutlet weak var tfTripName: UITextField!
    @IBOutlet weak var tfCalendar: UITextField!
    @IBOutlet weak var tfBudget: UITextField!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var viewDestination: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewBudget: UIView!
    //MARK: - Variables
    let screenSize = UIScreen.main.bounds.size
    var calendarView: DateRangeViewController!
    var calendarHeight: CGFloat = 380
    var blurBackView = UIView()
    var budget: Int = 0
    var dates: [Date]?
    var model: PlanModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
    }
    
    fileprivate func initComponents() {
        customizeLayouts()
        changeLanguage()
        
        let tapSelectRange = UITapGestureRecognizer(target: self, action: #selector(handleSelectRange))
        tfCalendar.addGestureRecognizer(tapSelectRange)
        
        let tapBlur = UITapGestureRecognizer(target: self, action: #selector(dismissCalendarView))
        blurBackView.addGestureRecognizer(tapBlur)
        
        tfBudget.delegate = self
        //tfBudget.addTarget(self, action: #selector(budgetDidChange(_:)), for: .editingChanged)
    }
    
    fileprivate func customizeLayouts() {
        [viewDate, viewDestination, viewBudget].forEach { (holderView) in
            holderView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            holderView?.layer.cornerRadius = 13
        }
        btnNext.layer.cornerRadius = 15
        btnNext.addShadow(radius: 8)
        tfCalendar.backgroundColor = UIColor.white
    }
    
    fileprivate func changeLanguage() {
        screenTitle.text = "Edit Plan"
        lbTitleDestination.text = "Choose Destination"
        lbTitleDate.text = "Choose Date"
        lbTitleBudget.text = "Budget"
        tfTripName.placeholder = "Name your trip"
        tfDestination.placeholder = "Where are you going?"
        tfCalendar.placeholder = "When are you going?"
        tfBudget.placeholder = "How much you gonna spend?"
        btnNext.setTitle("Update", for: .normal)
    }
    
    fileprivate func initData() {
        if let data = self.model {
            tfTripName.text = data.title
            tfDestination.text = data.place?.place_name ?? ""
            if let budget = data.budget {
                tfBudget.text = budget.description
            }
            if let start = data.start?.getDateFromUTC(), let end = data.end?.getDateFromUTC() {
                //self.dates = [start, end]
                didSelectDateRange(dates: [start, end])
            }
            
        }
    }
    
//    @objc func budgetDidChange(_ textField: UITextField) {
//        print("")
//    }
    
    
    @IBAction func clickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickNext(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSelectRange() {
        view.endEditing(true)
        calendarView = DateRangeViewController()
        calendarView.delegate = self
        if let dates = self.dates {
            calendarView.dates = dates
        }
        
        calendarView.view.frame = CGRect(x: screenSize.width / 2 - 350 / 2, y: screenSize.height / 2 - calendarHeight / 2, width: 350, height: calendarHeight)
        calendarView.view.layer.cornerRadius = 10
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
            window?.addSubview(calendarView.view)
        } else {
            // Fallback on earlier versions
        }
        
        blurBackView.alpha = 0
        calendarView.view.alpha = 0
        calendarView.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseInOut) {
            self.blurBackView.alpha = 0.8
            self.calendarView.view.transform = .identity
            self.calendarView.view.alpha = 1
        }
    }
    
    @objc func dismissCalendarView() {
        UIView.animate(
            withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut){
            self.calendarView.view.alpha = 0
            self.blurBackView.alpha = 0
        } completion: { (complete) in
            self.blurBackView.removeFromSuperview()
            self.calendarView.view.removeFromSuperview()
        }
    }
}

extension EditOverallViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters =
            CharacterSet(charactersIn: "0123456789").inverted
          return (string.rangeOfCharacter(from: invalidCharacters) == nil)
    }
    
}

extension EditOverallViewController : DateRangeDelegate {
    func didSelectDateRange(dates: [Date]) {
        self.dates = dates
        if dates.count == 1 {
            tfCalendar.text = "\(dates[0].dateString)"
        } else {
            tfCalendar.text = "\(dates[0].dateString) - \(dates[1].dateString)"
        }
    }
    
    func clickSave() {
        UIView.animate(
            withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut){
            self.calendarView.view.alpha = 0
            self.blurBackView.alpha = 0
        } completion: { (complete) in
            self.blurBackView.removeFromSuperview()
            self.calendarView.view.removeFromSuperview()
        }
    }
}

//
//  DateRangeViewController.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 19/04/2021.
//

import UIKit

protocol DateRangeDelegate: class {
    func clickSave()
    func didSelectDateRange(dates: [Date])
}

class DateRangeViewController: UIViewController {
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lbMonthYear: UILabel!
    @IBOutlet weak var calendarView: CustomCalendarView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var lbDateRange: UILabel!
    
    weak var delegate: DateRangeDelegate?
    
    var dates: [Date] = [Date]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
    }
    
    fileprivate func initComponents() {
        customizeLayouts()
        calendarView.delegate = self
        if self.dates.isEmpty {
            btnSave.isEnabled = false
        } else {
            btnSave.isEnabled = true
        }
    }
    
    fileprivate func customizeLayouts() {
        self.view.layer.cornerRadius = 10
        btnLeft.changeImageColor(image: btnLeft.currentImage!, color: Defined.arrowColor)
        btnRight.changeImageColor(image: btnRight.currentImage!, color: Defined.arrowColor)
        buttonView.addLineToView(position: .LINE_POSITION_TOP)
        btnSave.setTitleColor(Defined.darkBlue, for: .normal)
        btnSave.setTitleColor(Defined.darkBlue.withAlphaComponent(0.5), for: .disabled)
    }
    
    func changeLanguage() {
        btnSave.setTitle("Save", for: .normal)
    }
    
    fileprivate func initData() {
        if (!self.dates.isEmpty) {
            dates.forEach { (date) in
                calendarView.select(date)
            }
            if (dates.count == 1) {
                lbDateRange.text = dates[0].shortDateString
            } else {
                lbDateRange.text = dates[0].shortDateString + " - " + dates[1].shortDateString
            }
        } else {
            lbDateRange.text = "Select date"
        }
        lbMonthYear.text = calendarView.calendar.currentPage.tailDate
    }
    
    @IBAction func clickSave(_ sender: Any) {
        self.delegate?.clickSave()
        self.delegate?.didSelectDateRange(dates: self.dates)
    }
    
    
    @IBAction func clickLeft(_ sender: Any) {
        let current = calendarView.calendar.currentPage
        let date = Calendar.current.date(byAdding: .month, value: -1, to: current)!
        calendarView.setCurrentPage(date)
    }
    
    @IBAction func clickRight(_ sender: Any) {
        let current = calendarView.calendar.currentPage
        let date = Calendar.current.date(byAdding: .month, value: 1, to: current)!
        calendarView.setCurrentPage(date)
    }
    
}

extension DateRangeViewController : CustomCalendarViewDelegate {
    func didSelectSingleDate(date: Date) {
        self.dates = [date]
        lbDateRange.text = "\(date.shortDateString)"
        
    }
    func didSelectRangeDate(from: Date, to: Date) {
        self.dates = [from, to]
        lbDateRange.text = "\(from.shortDateString) - \(to.shortDateString)"
        btnSave.isEnabled = true
    }
    
    func currentPageChanged(date: Date) {
        self.lbMonthYear.text = date.tailDate
    }
}

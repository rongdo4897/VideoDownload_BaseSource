//
//  CustomCalendarView.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 19/04/2021.
//

import UIKit

import UIKit
import FSCalendar

@objc protocol CustomCalendarViewDelegate: class {
    @objc optional func didSelectSingleDate(date: Date)
    @objc optional func didSelectRangeDate(from: Date, to: Date)
    func currentPageChanged(date: Date)
}

class CustomCalendarView: UIView {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet var contentView: UIView!
    
    weak var delegate: CustomCalendarViewDelegate?

    fileprivate let gregorian = Calendar(identifier: .gregorian)
    var shouldDisplayToday: Bool = false

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    convenience init(calendar: FSCalendar) {
        self.init(frame: .zero)
        self.calendar = calendar
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        initCalendar()
    }

    func initCalendar() {
        calendar.isHidden = false
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.firstWeekday = 2
        calendar.backgroundColor = .white
        calendar.appearance.eventSelectionColor = UIColor.black
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.appearance.titleOffset = CGPoint(x: 0, y: 3)
        calendar.placeholderType = .fillSixRows
        calendar.scope = .month
        calendar.appearance.headerTitleColor = Defined.reuColor
        calendar.appearance.weekdayTextColor = Defined.reuColor
        calendar.today = nil // Hide the today circle
        calendar.register(DateCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.clipsToBounds = false // Remove top/bottom line
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        self.calendar.accessibilityIdentifier = "calendar"

        translatesAutoresizingMaskIntoConstraints = false
    }

    func setCornerRadius(_ value: CGFloat) {
        contentView.layer.cornerRadius = value
        calendar.layer.cornerRadius = value
        layoutIfNeeded()
    }

    func setUpMultipleSelection(_ value: Bool) {
        calendar.allowsMultipleSelection = value
    }

    func clearCalendar() {
        for d in calendar.selectedDates {
            calendar.deselect(d)
        }
        configureVisibleCells()
    }

    func select(_ date: Date) {
        calendar.select(date)
    }

    func selectRangeInCalendar(_ first: Date, _ second: Date) {
        calendar.select(first)
        calendar.select(second)
        configureVisibleCells()
    }

    func setCurrentPage(_ date: Date) {
        calendar.setCurrentPage(date, animated: true)
    }

    func shouldDisplayTodayImage(_ value: Bool) {
        shouldDisplayToday = value
    }
}

extension CustomCalendarView : FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }

    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }

    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return Defined.reuColor
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.delegate?.currentPageChanged(date: calendar.currentPage)
    }

    // MARK: - FSCalendarDelegate

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height

    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }

    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.selectedDates.count == 3 {
            for date in calendar.selectedDates {
                calendar.deselect(date)
            }
            calendar.select(date)
        }

        if calendar.selectedDates.count == 1 {
            let date = calendar.selectedDates[0]
            self.delegate?.didSelectSingleDate?(date: date)
        }

        if calendar.selectedDates.count == 2 {
            var first = calendar.selectedDates[0]
            var second = calendar.selectedDates[1]
            if second <= first {
                let temp = first
                first = second
                second = temp
            }
            self.delegate?.didSelectRangeDate?(from: first, to: second)
        }
        self.configureVisibleCells()

    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if (calendar.selectedDates.count == 1) {
            let date = calendar.selectedDates[0]
            self.delegate?.didSelectSingleDate?(date: date)
        } else if (calendar.selectedDates.isEmpty) {
            calendar.select(date)
        }
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 3
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [appearance.eventDefaultColor]
    }

    // MARK: - Private functions

    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }

    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard let diyCell = (cell as? DateCalendarCell) else {return}
        diyCell.circleImageView.isHidden = shouldDisplayToday ? !self.gregorian.isDateInToday(date) : true
        if position == .current {
            var selectionType = SelectionType.none
            if calendar.selectedDates.count == 2 {
                var first = calendar.selectedDates[0]
                var second = calendar.selectedDates[1]
                if second <= first {
                    let temp = first
                    first = second
                    second = temp
                }
                if date == first {
                    selectionType = .leftBorder
                } else if date > first && date < second {
                    selectionType = .middle
                } else if date == second {
                    selectionType = .rightBorder
                }
//                if date >= first && date <= second {
//                    selectionType = .middle
//                }
            } else {
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.count == 1 {
                        selectionType = .leftBorder
                    } else {
                        selectionType = .none
                    }
                } else {
                    selectionType = .none
                }
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
        } else {
            diyCell.selectionLayer.isHidden = true
            diyCell.titleLabel.textColor = Defined.lineColor
        }
    }
}

//
//  ListTripsViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 15/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ListTripsViewController: UIViewController {

    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    var magnifyingGlassIcon = UIImageView()

    var data: [Plan] = [Plan]()
    var dict: [Date: [Plan]] = [:]
    var keys = [Date]()
    var searchPlan: [Plan] = []
    let disposeBag = DisposeBag()
    var isSearching = false
    var searchDict: [Date: [Plan]] = [:]
    var searchKeys = [Date]()
    
    let dateFormatter: DateFormatter = {
        let formartDate = DateFormatter()
        formartDate.timeZone = TimeZone(abbreviation: "UTC")
        formartDate.dateFormat = "MM/yyyy"
        formartDate.locale = Locale.current
        return formartDate
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initComponent()
    }

    fileprivate func initData() {
        self.dict = groupData(data: self.data)
        self.keys = Array(self.dict.keys)
        self.keys.sort(by: {$0 > $1})
        self.tableView.reloadData()
    }

    fileprivate func initComponent() {
        ListCell.registerCellByNib(tableView)
        HeaderListCell.registerCellByNib(tableView)
        
        lbTitle.text = PlanConstant.listTrips
        tfSearch.placeholder = PlanConstant.search
        setUpTextFields(textFields: [tfSearch])
        addMagnifyingGlassIcon()
        searchActionPerform()
    }
    
    @IBAction func backToView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func searchActionPerform() {
        self.tfSearch.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] (text) in
                if !text.isEmpty {
                    self.searchPlan.removeAll()
                    for plan in self.data {
                        let name = plan.title?.uppercased()
                        let location = plan.place?.placeName?.uppercased()
                        if name?.contains(text.uppercased()) ?? true || location?.contains(text.uppercased()) ?? true {
                            self.searchPlan.append(plan)
                        }
                    }
                    self.isSearching = true
                } else {
                    self.isSearching = false
                }
                DispatchQueue.main.async {
                    self.searchDict = self.groupData(data: self.searchPlan)
                    self.searchKeys = Array(self.searchDict.keys)
                    self.searchKeys.sort(by: {$0 > $1})
                    self.tableView.reloadData()
                }
                
            }).disposed(by: disposeBag)
    }
}

extension ListTripsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if !self.isSearching {
            return keys.count
        } else {
            return searchKeys.count
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.isSearching {
            return dict[keys[section]]?.count ?? 0
        } else {
            return searchDict[searchKeys[section]]?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !self.isSearching {
            guard let cell = ListCell.loadCell(tableView) as? ListCell else { return UITableViewCell() }
            if let data = dict[keys[indexPath.section]] {
                cell.setUpCell(data: data[indexPath.row])
            }
            return cell
        } else {
            guard let cell = ListCell.loadCell(tableView) as? ListCell else { return UITableViewCell() }
            if let data = searchDict[searchKeys[indexPath.section]] {
                cell.setUpCell(data: data[indexPath.row])
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = HeaderListCell.loadCell(tableView) as? HeaderListCell else {return UITableViewCell()}
        if !self.isSearching {
            cell.setUpCell(date: keys[section])
        } else {
            cell.setUpCell(date: searchKeys[section])
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return PlanConstant.headerListCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlanConstant.listCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isSearching {
            if let data = dict[keys[indexPath.section]] {
                print("Go to details \(data[indexPath.row])")
            }
        } else {
            if let data = searchDict[searchKeys[indexPath.section]] {
                print("Go to details \(data[indexPath.row])")
            }
        }
    }
}

extension ListTripsViewController {
    func groupData(data: [Plan]) -> [Date: [Plan]] {
        var dict: [Date: [Plan]] = [:]
        data.forEach { (model) in
            guard let time = model.start?.getDateFromUTC() else {return}
            let date = self.dateFormatter.date(from: self.dateFormatter.string(from: time)) ?? Date()
            if dict.keys.contains(date) {
                dict[date]?.append(model)
            } else {
                var newData = [Plan]()
                newData.append(model)
                dict[date] = newData
            }
         }
        return dict
    }

    // Make rounded text fields
    func setUpTextFields(textFields: [UITextField]) {
        textFields.forEach { (textField) in
            textField.setLeftPaddingPoints(15)
            textField.setRightPaddingPoints(15)
            textField.layer.borderColor = UIColor.colorFromHexString(hex: "BDBDBD").cgColor
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = textField.height / 2
        }
    }
    
    // Add magnifying glass icon
    func addMagnifyingGlassIcon() {
        self.magnifyingGlassIcon.frame = CGRect(x: 10, y: 12.5, width: 15, height: 15)
        var image = #imageLiteral(resourceName: "iconSearch")
        image = image.maskWithColor(color: UIColor.colorFromHexString(hex: "BDBDBD")) ?? UIImage()
        self.magnifyingGlassIcon.image = image
        self.magnifyingGlassIcon.contentMode = .scaleAspectFit

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.addSubview(self.magnifyingGlassIcon)
        self.tfSearch.leftViewMode = .always
        self.tfSearch.leftView = view
    }
}

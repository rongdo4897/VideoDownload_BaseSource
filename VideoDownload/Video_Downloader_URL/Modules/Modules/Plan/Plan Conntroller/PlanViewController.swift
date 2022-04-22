//
//  PlanViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/12/21.
//

import UIKit

enum PlanCell: Int {
    case ongoing = 0
    case planned = 1
    case past = 2
}

class PlanViewController: BaseViewController {

    @IBOutlet weak var viewNoTrip: UIView!
    @IBOutlet weak var btnStartTrip: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddTrip: UIButton!
    @IBOutlet weak var lbNoTrip: UILabel!
    @IBOutlet weak var lbCreateTripMess: UILabel!
    @IBOutlet weak var lbTitle: UILabel!

    var presenter: PlanPresenter?
    var dict: [String: [Plan]] = [:]
    var keys = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initComponent()
        
    }

    fileprivate func initData() {
        self.presenter?.getListPlan()
    }

    fileprivate func initComponent() {
        btnStartTrip.layer.cornerRadius = btnStartTrip.height / 2
        btnAddTrip.layer.cornerRadius = btnAddTrip.height / 2
        btnAddTrip.addShadow(radius: 4)
        viewNoTrip.isHidden = true

        OngoingPlanCell.registerCellByNib(tableView)
        PlannedCell.registerCellByNib(tableView)
        PastCell.registerCellByNib(tableView)
        EmptyCell.registerCellByNib(tableView)

        btnStartTrip.setTitle(PlanConstant.startTrip, for: .normal)
        lbNoTrip.text = PlanConstant.noTripMessage
        lbCreateTripMess.text = PlanConstant.createTripMess
        lbTitle.text = PlanConstant.myTrip
    }

    func setUp(presenter: PlanPresenter) {
        self.presenter = presenter
    }
    
    @IBAction func onClickStartTrip(_ sender: Any) {
//        print("Go to add trip screen")
        let vc = RouterType.addOverall.getVc()
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        self.present(nav
                     , animated: true, completion: nil)
    }

    func gotoViewList(data: [Plan]) {
        guard let vc = RouterType.listTrips.getVc() as? ListTripsViewController else { return }
        vc.data = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PlanViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case PlanCell.ongoing.rawValue:
            if let data = self.dict[PlanTrip.ongoing.rawValue] {
                guard let cell = OngoingPlanCell.loadCell(tableView) as? OngoingPlanCell else { return UITableViewCell() }
                cell.setUpCell(data: data[0])
                return cell
            } else {
                guard let cell = EmptyCell.loadCell(tableView) as? EmptyCell else {return UITableViewCell()}
                return cell
            }
        case PlanCell.planned.rawValue:
            if let data = self.dict[PlanTrip.planned.rawValue] {
                guard let cell = PlannedCell.loadCell(tableView) as? PlannedCell else {return UITableViewCell()}
                cell.setUpData(data: data)
                cell.delegate = self
                return cell
            } else {
                guard let cell = EmptyCell.loadCell(tableView) as? EmptyCell else {return UITableViewCell()}
                return cell
            }
        default:
            if let data = self.dict[PlanTrip.past.rawValue]  {
                guard let cell = PastCell.loadCell(tableView) as? PastCell else {return UITableViewCell()}
                cell.setUpData(data: data)
                cell.delegate = self
                return cell
            } else {
                guard let cell = EmptyCell.loadCell(tableView) as? EmptyCell else {return UITableViewCell()}
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var myHeight: CGFloat = 0
        switch indexPath.section {
        case PlanCell.ongoing.rawValue:
            if (self.dict[PlanTrip.ongoing.rawValue] ?? [Plan]()).isEmpty {
                myHeight = 0
            } else {
                myHeight = PlanConstant.ongoingCellHeight
            }
        case PlanCell.planned.rawValue:
            if (self.dict[PlanTrip.planned.rawValue] ?? [Plan]()).isEmpty {
                myHeight = 0
            } else {
                myHeight = PlanConstant.plannedCellHeight
            }
        default:
            if (self.dict[PlanTrip.past.rawValue] ?? [Plan]()).isEmpty {
                myHeight = 0
            } else {
                myHeight = PlanConstant.pastCellHeight
            }
        }
        return myHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case PlanCell.ongoing.rawValue:
            print("Go to details")
        case PlanCell.planned.rawValue:
            gotoViewList(data: self.dict[PlanTrip.planned.rawValue] ?? [Plan]())
        case PlanCell.past.rawValue:
            gotoViewList(data: self.dict[PlanTrip.past.rawValue] ?? [Plan]())
        default:
            break
        }
    }

}

extension PlanViewController: PlannedCellDelegate {
    func collectionView(collectioncell: PlannedCollectionCell?, didTappedInTableview TableCell: PlannedCell, indexPath: IndexPath) {
        let vc = RouterType.viewOverall.getVc()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PlanViewController: PastCellDelegate {
    func collectionView(collectioncell: PastCollectionCell?, didTappedInTableview TableCell: PastCell, indexPath: IndexPath) {
        let vc = RouterType.viewOverall.getVc()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PlanViewController: PlanPresenterDelegate {
    func fetchData(data: [Plan]) {
        DispatchQueue.main.async {
            guard let dict = self.presenter?.groupData(data: data) else {return}
            self.dict = dict

            if dict.isEmpty {
                self.tableView.isHidden = true
                self.viewNoTrip.isHidden = false
            } else {
                self.tableView.isHidden = false
                self.viewNoTrip.isHidden = true
            }

            self.tableView.reloadData()
        }
    }
    
    func showError(message: String) {
        print(message)
    }
}

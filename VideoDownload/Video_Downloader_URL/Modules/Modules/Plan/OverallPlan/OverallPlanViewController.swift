//
//  SecondOverallPlanViewController.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 29/04/2021.
//

import UIKit

class OverallPlanViewController: UIViewController {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbTripName: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func initComponents() {
        customizeLayouts()
        OverallInfoView.registerCellByNib(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        imageView.translatesAutoresizingMaskIntoConstraints = true
        tableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func customizeLayouts() {
        [btnBack, btnShare].forEach { (button) in
            button?.layer.cornerRadius = 15
        }
        statusView.layer.cornerRadius = 17
        statusView.addShadow(radius: 7)
    }
    
    fileprivate func initData() {
        
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickShare(_ sender: Any) {
        let vc = RouterType.sharePlan.getVc()
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension OverallPlanViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = OverallInfoView.loadCell(tableView) as? OverallInfoView else {
            return UITableViewCell()
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = 300 - (scrollView.contentOffset.y + 300)
        let h = max(250, y)
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: h)
        imageView.frame = rect
    }
    
}

extension OverallPlanViewController : OverallInfoViewDelegate {
    func clickEdit() {
        let plan = PlanModel(id: "2", title: "Hallo testo 2", start: "2020-03-26T11:21:37.914Z", end: "2020-08-26T18:55:59.535Z", place: PlaceAttribute(place_name: "Ha Long Bay", longtitude: 71.4188, latitude: -84.4731), budget: 422.4, status: "FUTURE")
        let vc = RouterType.editOverall(model: plan).getVc()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func clickItinerary() {
        let vc = RouterType.itinerary.getVc()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

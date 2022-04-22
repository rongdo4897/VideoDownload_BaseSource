//
//  AddItineraryViewController.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 14/04/2021.
//

import UIKit

class AddItineraryViewController: BaseViewController {
    //MARK: - Outlets
    @IBOutlet weak var lbSuggest: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lbAddNew: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    //MARK: - Variables
    let screenSize = UIScreen.main.bounds.size
    var dayTitles = [
        DayTitle(title: "Day 1", dateString: "April 4, 2021", isHightlighted: true),
        DayTitle(title: "Day 2", dateString: "April 4, 2021", isHightlighted: false)
    ]
    
    var itineraryItems = [
        ItineraryModel(no: 1, from: "6:00", to: "8:00", imageUrl: "travel1", tripName: "Cafe at Hoi An", budget: "100,000", note: "Hello from the other side and you're walking around the beach with your friends and talking nonsense"),
        ItineraryModel(no: 2, from: "6:00", to: "8:00", imageUrl: "travel1", tripName: "Cafe at Hoi An", budget: "100,000", note: "Hello from the other side and you're walking around the beach with your friends and talking nonsense"),
        ItineraryModel(no: 3, from: "6:00", to: "8:00", imageUrl: "travel1", tripName: "Cafe at Hoi An", budget: "100,000"),
        ItineraryModel(no: 4, from: "6:00", to: "8:00", imageUrl: "travel1", tripName: "Cafe at Hoi An", budget: "100,000")
    ]
    
    //var itineraryItems = [ItineraryModel]()
    
    var noteView: NoteViewController!
    let noteHeight: CGFloat = 200
    var blurBackView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
    }
    
    fileprivate func initComponents() {
        customizeLayouts()
        changeLanguage()
        let tapAdd = UITapGestureRecognizer(target: self, action: #selector(handleTapAdd))
        btnAdd.addGestureRecognizer(tapAdd)
        DayCell.registerCellByNib(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        ItineraryItemCell.registerCellByNib(tableView)
        ItineraryItemNoNoteCell.registerCellByNib(tableView)
        AddNewCell.registerCellByNib(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
    }
    
    fileprivate func customizeLayouts() {
        btnBack.layer.cornerRadius = 15
        btnAdd.layer.cornerRadius = btnAdd.frame.width / 2
        btnAdd.addShadow(radius: 8)
    }
    
    func changeLanguage() {
        screenTitle.text = "Add Itinerary"
        btnDone.setTitle("Done", for: .normal)
        lbSuggest.text = "Let's add a new schedule"
    }
    
    fileprivate func initData() {
        if itineraryItems.isEmpty {
            lbAddNew.isHidden = false
        } else {
            lbAddNew.isHidden = true
        }
    }
    
    @IBAction func clickDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTapAdd() {
        let vc = RouterType.addSchedule.getVc()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func setDayTitleSelected(index: Int) {
        for i in 0..<dayTitles.count {
            if i != index {
                dayTitles[i].isHightlighted = false
            } else {
                dayTitles[i].isHightlighted = true
            }
        }
    }
}


extension AddItineraryViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = DayCell.loadCell(collectionView, path: indexPath) as? DayCell else {
            return UICollectionViewCell()
        }
        cell.setUp(data: dayTitles[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 71)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setDayTitleSelected(index: indexPath.row)
        collectionView.reloadData()
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    
    
}

extension AddItineraryViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itineraryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _ = itineraryItems[indexPath.row].note {
            guard let cell = ItineraryItemCell.loadCell(tableView) as? ItineraryItemCell else {
                return UITableViewCell()
            }
            cell.setUp(data: itineraryItems[indexPath.row])
            return cell
        } else {
            guard let cell = ItineraryItemNoNoteCell.loadCell(tableView) as? ItineraryItemNoNoteCell else {
                return UITableViewCell()
            }
            cell.setUp(data: itineraryItems[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = itineraryItems[indexPath.row].note {
            return PlanConstant.scheduleWithNoteCell
        } else {
            return PlanConstant.sheduleNoNoteCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RouterType.editSchedule(model: itineraryItems[indexPath.row]).getVc()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}


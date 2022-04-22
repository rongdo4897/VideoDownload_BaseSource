//
//  ItineraryViewController.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 13/04/2021.
//

import UIKit
import Floaty

class ItineraryViewController: BaseViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Variables
    let screenSize = UIScreen.main.bounds.size
    var dayTitles = [
        DayTitle(title: "Day 1", dateString: "April 4, 2021", isHightlighted: true),
        DayTitle(title: "Day 2", dateString: "April 4, 2021", isHightlighted: false),
        DayTitle(title: "Day 3", dateString: "April 4, 2021", isHightlighted: false),
        DayTitle(title: "Day 4", dateString: "April 4, 2021", isHightlighted: false),
        DayTitle(title: "Day 5", dateString: "April 4, 2021", isHightlighted: false)
    ]
    
    var itineraryItems = [
    ItineraryModel(no: 1, from: "6:00", to: "8:00", imageUrl: "travel1", tripName: "Cafe at Hoi An with my best friend alohfdohfdhf", budget: "100,000", note: "Hello from the other side and you're walking around the beach with your friends and talking nonsense"),
        ItineraryModel(no: 2, from: "6:00", to: "8:00", imageUrl: "travel2", tripName: "Cafe at Hoi An", budget: "200,000"),
        ItineraryModel(no: 3, from: "6:00", to: "8:00", imageUrl: "travel1", tripName: "Cafe at Hoi An", budget: "300,000", note: "lol ur off"),
        ItineraryModel(no: 4, from: "11:00", to: "12:00", imageUrl: "travel1", tripName: "Lunch", budget: "400,000"),
        ItineraryModel(no: 12, from: "16:00", to: "17:00", imageUrl: "travel1", tripName: "Cafe at Hoi An", budget: "500,000", note: "lol ur off")
    ]
    
    var noteView: NoteViewController!
    let noteHeight: CGFloat = 200
    var blurBackView = UIView()
    let latitude = 21.01313981720607
    let longtitude = 105.52718231495639
    var floaty: Floaty!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func initComponents() {
        customizeLayouts()
        changeLanguage()
        DayCell.registerCellByNib(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        ItineraryItemCell.registerCellByNib(tableView)
        ItineraryItemNoNoteCell.registerCellByNib(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        setUpFloatingButton()
    }
    
    fileprivate func customizeLayouts() {
        btnBack.layer.cornerRadius = 15
    }
    
    func setUpFloatingButton() {
        // CGRect(x: 100, y: 100, width: 50, height: 50)
        floaty = Floaty(frame: CGRect(x: self.view.frame.maxX - 90, y: self.view.frame.maxY - 120, width: 50, height: 50))
        floaty.buttonImage = #imageLiteral(resourceName: "ic_bottom_menu")
        floaty.hasShadow = true
        floaty.overlayColor = UIColor.darkGray.withAlphaComponent(0.7)
        floaty.buttonColor = Defined.otherBlackColor
        floaty.size = CGSize(width: 50, height: 50)

        let addNewItem = FloatyItem()
        addNewItem.hasShadow = false
        addNewItem.titleLabelPosition = .left
        addNewItem.title = "Add new"
        addNewItem.icon = #imageLiteral(resourceName: "ic_add_new")
        addNewItem.imageSize = CGSize(width: 30, height: 30)
        addNewItem.buttonColor = Defined.minGreenColor
        addNewItem.titleLabel.font = UIFont.init(name: "Raleway-SemiBold", size: 17)
        addNewItem.itemBackgroundColor = UIColor.white
        addNewItem.hasShadow = true
        addNewItem.handler = { item in
            let vc = RouterType.addSchedule.getVc()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        let deleteAllItem = FloatyItem()
        deleteAllItem.hasShadow = false
        deleteAllItem.titleLabelPosition = .left
        deleteAllItem.title = "Delete all"
        deleteAllItem.icon = #imageLiteral(resourceName: "ic_delete_all")
        deleteAllItem.imageSize = CGSize(width: 30, height: 30)
        deleteAllItem.buttonColor = Defined.minGreenColor
        deleteAllItem.titleLabel.font = UIFont.init(name: "Raleway-SemiBold", size: 17)
        deleteAllItem.hasShadow = true
        deleteAllItem.handler = { item in
            self.itineraryItems.removeAll()
            self.tableView.reloadData()
        }
        
        floaty.addItem(item: deleteAllItem)
        floaty.addItem(item: addNewItem)
        floaty.fabDelegate = self
        
        view.addSubview(floaty)

        floaty.alpha = 0
        floaty.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseInOut) {
            self.floaty.transform = .identity
            self.floaty.alpha = 1
        }
        
    }
    
    func changeLanguage() {

    }
    
    fileprivate func initData() {
        
    }
    
    @IBAction func clickLeft(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickHome(_ sender: Any) {
        
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

extension ItineraryViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension ItineraryViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itineraryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _ = itineraryItems[indexPath.row].note {
            guard let cell = ItineraryItemCell.loadCell(tableView) as? ItineraryItemCell else {
                return UITableViewCell()
            }
            cell.setUp(data: itineraryItems[indexPath.row])
            cell.delegate = self
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
        let url = URL(string: "comgooglemaps://?daddr=\(latitude),\(longtitude)&directionsmode=driving&zoom=14&views=traffic")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: Constants.delete) { (action, view, completion) in
            completion(true)
        }
        delete.image = #imageLiteral(resourceName: "ic_trash_white")
        delete.backgroundColor = Defined.quiteRedColor
        let edit = UIContextualAction(style: .normal, title: Constants.edit) { (action, view, completion) in
            let vc = RouterType.editSchedule(model: self.itineraryItems[indexPath.row]).getVc()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            completion(true)
        }
        edit.image = #imageLiteral(resourceName: "ic_edit-1")
        edit.backgroundColor = Defined.lightBlueColor
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }
}

extension ItineraryViewController : ItineraryItemDelegate {
    func didClickNote(note: String) {
        noteView = NoteViewController()
        noteView.delegate = self
        noteView.note = note
        
        noteView.view.frame = CGRect(x: screenSize.width / 2 - screenSize.width * 0.7 / 2, y: screenSize.height / 2 - noteHeight / 2, width: screenSize.width * 0.7, height: noteHeight)
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
            window?.addSubview(noteView.view)
        } else {
            // Fallback on earlier versions
        }
        
        blurBackView.alpha = 0
        noteView.view.alpha = 0
        noteView.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseInOut) {
            self.blurBackView.alpha = 0.8
            self.noteView.view.transform = .identity
            self.noteView.view.alpha = 1
        }
    }
}

extension ItineraryViewController : NoteDelegate {
    func dismissNote() {
        UIView.animate(
            withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut){
            self.noteView.view.alpha = 0
            self.blurBackView.alpha = 0
        } completion: { (complete) in
            self.blurBackView.removeFromSuperview()
            self.noteView.view.removeFromSuperview()
        }
    }
}

extension ItineraryViewController : FloatyDelegate {
    func floatyWillOpen(_ floaty: Floaty) {
        
    }
    
    func floatyWillClose(_ floaty: Floaty) {
        
    }
    
    func floatyDidOpen(_ floaty: Floaty) {
        
    }
    
    func floatyDidClose(_ floaty: Floaty) {
        
    }
}

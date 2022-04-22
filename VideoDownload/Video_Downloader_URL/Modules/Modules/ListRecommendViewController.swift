//
//  ListRecommendViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 19/04/2021.
//

import UIKit
import BetterSegmentedControl
import OverlayContainer
import RxCocoa
import RxSwift

enum State {
    case forYou
    case hotPlaces
    case discoverNew
}

class ListRecommendViewController: BaseViewController {

    @IBOutlet weak var segment: BetterSegmentedControl!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    
    var forYouModel: [RecommendedTrip] = [RecommendedTrip]()
    var hotPlacesModel: [RecommendedTrip] = [RecommendedTrip]()
    var discoverNewModel: [RecommendedTrip] = [RecommendedTrip]()
    var searchforYouModel: [RecommendedTrip] = [RecommendedTrip]()
    var searchhotPlacesModel: [RecommendedTrip] = [RecommendedTrip]()
    var searchdiscoverNewModel: [RecommendedTrip] = [RecommendedTrip]()

    var state: State?
    private let backDrop = BackdropViewController()
    private var recommendTripDetails = RecommendDetailsViewController()
    private var detailsBottomSheet = DetailsBottomSheetViewController()
    var magnifyingGlassIcon = UIImageView()
    let disposeBag = DisposeBag()
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initComponent()
    }

    fileprivate func initData() {
        
    }

    fileprivate func initComponent() {
        collectionView.delegate = self
        collectionView.dataSource = self
        ListCollectionCell.registerCellByNib(collectionView)

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
        }

        segment.isHidden = true
        segment.segments = LabelSegment.segments(withTitles: [HomeConstant.forYou, HomeConstant.hotPlaces, HomeConstant.discoverNew], normalFont: Defined.fontWithSize(name: Constants.ralewayMedium, size: 14), normalTextColor: #colorLiteral(red: 0.06666666667, green: 0.2156862745, blue: 0.2941176471, alpha: 1), selectedFont: Defined.fontWithSize(name: Constants.ralewayMedium, size: 14), selectedTextColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        lbTitle.text = HomeConstant.recommend
        tfSearch.placeholder = HomeConstant.search
        setUpTextFields(textFields: [tfSearch])
        addMagnifyingGlassIcon()
        searchActionPerform()
    }

    @IBAction func backToView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func selectedSegment(_ sender: Any) {
    }

    func searchActionPerform() {
        self.tfSearch.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] (text) in
                if !text.isEmpty {
                    self.searchforYouModel.removeAll()
                    self.searchhotPlacesModel.removeAll()
                    self.searchdiscoverNewModel.removeAll()
                    switch state {
                    case .forYou:
                        for trip in self.forYouModel {
                            let name = trip.name?.uppercased()
                            let location = trip.location?.uppercased()
                            if name?.contains(text.uppercased()) ?? true || location?.contains(text.uppercased()) ?? true {
                                self.searchforYouModel.append(trip)
                            }
                        }
                    case .hotPlaces:
                        for trip in self.hotPlacesModel {
                            let name = trip.name?.uppercased()
                            let location = trip.location?.uppercased()
                            if name?.contains(text.uppercased()) ?? true || location?.contains(text.uppercased()) ?? true {
                                self.searchhotPlacesModel.append(trip)
                            }
                        }
                    default:
                        for trip in self.discoverNewModel {
                            let name = trip.name?.uppercased()
                            let location = trip.location?.uppercased()
                            if name?.contains(text.uppercased()) ?? true || location?.contains(text.uppercased()) ?? true {
                                self.searchdiscoverNewModel.append(trip)
                            }
                        }
                    }
                    self.isSearching = true
                } else {
                    self.isSearching = false
                }
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
                
            }).disposed(by: disposeBag)
    }
    
}

extension ListRecommendViewController {
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

extension ListRecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            switch state {
            case .forYou:
                return searchforYouModel.count
            case .hotPlaces:
                return searchhotPlacesModel.count
            default:
                return searchdiscoverNewModel.count
            }
        } else {
            switch state {
            case .forYou:
                return forYouModel.count
            case .hotPlaces:
                return hotPlacesModel.count
            default:
                return discoverNewModel.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = ListCollectionCell.loadCell(collectionView, path: indexPath) as? ListCollectionCell else {
           return UICollectionViewCell()
        }
        if isSearching {
            switch state {
            case .forYou:
                cell.setUpCell(data: searchforYouModel[indexPath.row])
            case .hotPlaces:
                cell.setUpCell(data: searchhotPlacesModel[indexPath.row])
            default:
                cell.setUpCell(data: searchdiscoverNewModel[indexPath.row])
            }
        } else {
            switch state {
            case .forYou:
                cell.setUpCell(data: forYouModel[indexPath.row])
            case .hotPlaces:
                cell.setUpCell(data: hotPlacesModel[indexPath.row])
            default:
                cell.setUpCell(data: discoverNewModel[indexPath.row])
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc1 = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(withIdentifier: Constants.recommendController) as? RecommendDetailsViewController else {
            return
        }
        guard let vc2 = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(withIdentifier: Constants.detailsBottomSheet) as? DetailsBottomSheetViewController else {
            return
        }
        if isSearching {
            switch state {
            case .forYou:
                vc1.data = searchforYouModel[indexPath.row]
                vc2.data = searchforYouModel[indexPath.row]
            case .hotPlaces:
                vc1.data = searchhotPlacesModel[indexPath.row]
                vc2.data = searchhotPlacesModel[indexPath.row]
            default:
                vc1.data = searchdiscoverNewModel[indexPath.row]
                vc2.data = searchdiscoverNewModel[indexPath.row]
            }
        } else {
            switch state {
            case .forYou:
                vc1.data = forYouModel[indexPath.row]
                vc2.data = forYouModel[indexPath.row]
            case .hotPlaces:
                vc1.data = hotPlacesModel[indexPath.row]
                vc2.data = hotPlacesModel[indexPath.row]
            default:
                vc1.data = discoverNewModel[indexPath.row]
                vc2.data = discoverNewModel[indexPath.row]
            }
        }
        
        self.recommendTripDetails = vc1
        self.detailsBottomSheet = vc2
        self.recommendTripDetails.detailsBottomSheet = self.detailsBottomSheet
        let containerController = OverlayContainerViewController()
        containerController.delegate = self
        containerController.viewControllers = [self.recommendTripDetails, self.backDrop, self.detailsBottomSheet]
        containerController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(containerController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.width - HomeConstant.lineSpacingRecommend) / 2, height: HomeConstant.recommendCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return HomeConstant.lineSpacingRecommend
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return HomeConstant.lineSpacingRecommend
    }
    
}
extension ListRecommendViewController: OverlayContainerViewControllerDelegate {
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, heightForNotchAt index: Int, availableSpace: CGFloat) -> CGFloat {
        var value = UIScreen.main.bounds.size.height
        if #available(iOS 11.0, *) {
            value -= view.safeAreaInsets.top
        }
        if UIDevice.current.hasNotch {
            switch OverlayNotch.allCases[index] {
            case .maximum:
                value -= 45
            case .medium:
                value -= 2 / 3 * UIScreen.main.bounds.size.height + 10
            case .minimum:
                value -= 2 / 3 * UIScreen.main.bounds.size.height + 10
            }
        } else {
            switch OverlayNotch.allCases[index] {
            case .maximum:
                value -= 45
            case .medium:
                value -= 2 / 3 * UIScreen.main.bounds.size.height - 20
            case .minimum:
                value -= 2 / 3 * UIScreen.main.bounds.size.height - 20
            }
        }
        
        return value
    }
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        return OverlayNotch.allCases.count
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController,
                                        willTranslateOverlay overlayViewController: UIViewController,
                                        transitionCoordinator: OverlayContainerTransitionCoordinator) {
        transitionCoordinator.animate(alongsideTransition: { [weak self] context in
            self?.backDrop.view.alpha = context.translationProgress()
        }, completion: nil)
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, willEndDraggingOverlay overlayViewController: UIViewController, atVelocity velocity: CGPoint) {
        if velocity.y > 0 {
            self.recommendTripDetails.btnBack.isUserInteractionEnabled = true
        } else {
            self.recommendTripDetails.btnBack.isUserInteractionEnabled = false
        }
    }

    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, scrollViewDrivingOverlay overlayViewController: UIViewController) -> UIScrollView? {
        return (overlayViewController as? DetailsBottomSheetViewController)?.detailsTableView
    }
}

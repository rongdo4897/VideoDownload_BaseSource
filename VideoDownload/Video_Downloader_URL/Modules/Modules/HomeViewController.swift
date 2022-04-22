//
//  HomeViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/12/21.
//

import UIKit
import OverlayContainer

enum HomeCell: Int {
    case banner = 0
    case plan = 1
    case forYou = 2
    case hotPlaces = 3
    case discoverNew = 4
}

class BackdropViewController: UIViewController {
    override func loadView() {
        view = PassThroughView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
    }
}

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var model = homeData
    var foryouModel = dataForYou
    var hotPlacesModel = dataHotPlaces
    var discoverNewModel = dataDiscoverNew
    
    private let backDrop = BackdropViewController()
    private var recommendTripDetails = RecommendDetailsViewController()
    private var detailsBottomSheet = DetailsBottomSheetViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initComponent()
    }

    fileprivate func initData() {
        
    }

    fileprivate func initComponent() {
        BannerCell.registerCellByNib(tableView)
        DiscoverNewCell.registerCellByNib(tableView)
        HotPlacesCell.registerCellByNib(tableView)
        ForYouCell.registerCellByNib(tableView)
        DoneCell.registerCellByNib(tableView)
        OngoingCell.registerCellByNib(tableView)
        EmptyCell.registerCellByNib(tableView)

        if isFirstLaunch() {
            AlertView.instance.delegate = self
            AlertView.instance.showAlert()
        }
    }

    func goToDetail(data: RecommendedTrip) {
        guard let vc1 = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(withIdentifier: Constants.recommendController) as? RecommendDetailsViewController else {
            return
        }
        vc1.data = data
        self.recommendTripDetails = vc1
        guard let vc2 = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(withIdentifier: Constants.detailsBottomSheet) as? DetailsBottomSheetViewController else {
            return
        }
        vc2.data = data
        self.detailsBottomSheet = vc2
        self.recommendTripDetails.detailsBottomSheet = self.detailsBottomSheet
        let containerController = OverlayContainerViewController()
        containerController.delegate = self
        containerController.viewControllers = [self.recommendTripDetails, self.backDrop, self.detailsBottomSheet]
        containerController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(containerController, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case HomeCell.banner.rawValue:
            guard let cell = BannerCell.loadCell(tableView) as? BannerCell else {return UITableViewCell()}
            cell.setUpCell(data: model.banner ?? [Banner]())
            cell.delegate = self
            return cell
        case HomeCell.plan.rawValue:
            switch model.plan?.status {
            case PlanTrip.ongoing.rawValue:
                guard let cell = OngoingCell.loadCell(tableView) as? OngoingCell else {return UITableViewCell()}
                cell.setUpCell(data: model.plan ?? Plan())
                cell.delegate = self
                return cell
            case PlanTrip.done.rawValue:
                guard let cell = DoneCell.loadCell(tableView) as? DoneCell else {return UITableViewCell()}
                cell.setUpCell(data: model.plan ?? Plan())
                cell.delegate = self
                return cell
            default:
                guard let cell = EmptyCell.loadCell(tableView) as? EmptyCell else {return UITableViewCell()}
                return cell
            }
        case HomeCell.forYou.rawValue:
            guard let cell = ForYouCell.loadCell(tableView) as? ForYouCell else {return UITableViewCell()}
            cell.setUpCell(data: dataForYou)
            cell.delegate = self
            return cell
        case HomeCell.hotPlaces.rawValue:
            guard let cell = HotPlacesCell.loadCell(tableView) as? HotPlacesCell else {return UITableViewCell()}
            cell.setUpCell(data: dataHotPlaces)
            cell.delegate = self
            return cell
        default:
            guard let cell = DiscoverNewCell.loadCell(tableView) as? DiscoverNewCell else {return UITableViewCell()}
            cell.setUpCell(data: dataDiscoverNew)
            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var myHeight: CGFloat = 0
        switch indexPath.section {
        case HomeCell.banner.rawValue:
            myHeight = HomeConstant.bannerHeight
        case HomeCell.plan.rawValue:
            if model.plan != nil {
                myHeight = HomeConstant.planHeight
            } else {
                myHeight = 0
            }
        case HomeCell.forYou.rawValue:
            myHeight = HomeConstant.forYouHeight
        case HomeCell.hotPlaces.rawValue:
            myHeight = HomeConstant.hotPlacesHeight
        default:
            myHeight = HomeConstant.discoverNewHeight
        }
        return myHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case HomeCell.plan.rawValue:
            let vc = RouterType.viewOverall.getVc()
            self.navigationController?.pushViewController(vc, animated: true)
        case HomeCell.banner.rawValue:
            print("banner")
        case HomeCell.forYou.rawValue:
            guard let vc = RouterType.listRecommend.getVc() as? ListRecommendViewController else {return}
            vc.forYouModel = dataForYou
            vc.state = .forYou
            navigationController?.pushViewController(vc, animated: true)
        case HomeCell.hotPlaces.rawValue:
            guard let vc = RouterType.listRecommend.getVc() as? ListRecommendViewController else {return}
            vc.hotPlacesModel = dataHotPlaces
            vc.state = .hotPlaces
            navigationController?.pushViewController(vc, animated: true)
        default:
            guard let vc = RouterType.listRecommend.getVc() as? ListRecommendViewController else {return}
            vc.discoverNewModel = discoverNewModel
            vc.state = .discoverNew
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController {
    func isFirstLaunch() -> Bool {
        if (!UserDefaults.standard.bool(forKey: "launched_before")) {
            UserDefaults.standard.set(true, forKey: "launched_before")
            return true
        }
        return false
    }
}

extension HomeViewController: OngoingCellDelegate {
    func onclickViewDetails() {
        print("View")
    }
}

extension HomeViewController: DoneCellDelegate {
    func onClickShare() {
        print("Share")
    }
}

extension HomeViewController: BannerCellDelegate {
    func onClickMoreInfo() {
        let vc = RouterType.listTrips.getVc()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: ForYouCellDelegate {
    func collectionView(collectioncell: ForYouCollectionCell?, didTappedInTableview TableCell: ForYouCell, indexPath: IndexPath) {
        self.goToDetail(data: dataForYou[indexPath.row])
    }
}

extension HomeViewController: HotPlacesCellDeleagte {
    func collectionView(collectioncell: HotPlacesCollectionCell?, didTappedInTableview TableCell: HotPlacesCell, indexPath: IndexPath) {
        self.goToDetail(data: dataHotPlaces[indexPath.row])
    }
}

extension HomeViewController: DiscoverNewCellDelegate {
    func collectionView(collectioncell: DiscoverNewCollectionCell?, didTappedInTableview TableCell: DiscoverNewCell, indexPath: IndexPath) {
        self.goToDetail(data: dataDiscoverNew[indexPath.row])
    }
}

enum OverlayNotch: Int, CaseIterable {
    case minimum, medium, maximum
}

extension HomeViewController: OverlayContainerViewControllerDelegate {
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

extension HomeViewController: AlertViewDelegate {
    func onClickOK() {
        let vc = RouterType.addOverall.getVc()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

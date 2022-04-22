//
//  AppRouter.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/12/21.
//

import Foundation
import UIKit

enum RouterOption: Int {
    case present = 0
    case push = 1
}

enum RouterType {
    case tabbar
    case home
    case profile
    case plan
    case addOverall
    case viewOverall
    case itinerary
    case sharePlan
    case addItinerary
    case addSchedule
    case editSchedule(model: ItineraryModel)
    case recommendTripDetails
    case bottomSheetDetails
    case listTrips
    case authentication
    case accountDetails
    case settings
    case listRecommend
    case introContent
    case introPage
    case intro
    case editOverall(model: PlanModel)
}

class AppRouter {
    class func routerTo(from vc: UIViewController, router: RouterType, options: RouterOption) {
        switch options {
        case .present:
            let vct = router.getVc()
            vct.modalPresentationStyle = .fullScreen
            vc.present(vct, animated: true, completion: nil)
        default:
            vc.navigationController?.pushViewController(router.getVc(), animated: true)
        }
    }
}

extension RouterType {
    func getVc() -> UIViewController {
        switch self {
        case .tabbar:
            let vc = UIStoryboard(name: Constants.tabbar, bundle: nil).instantiateViewController(ofType: TabbarViewController.self)
            return vc
        case .home:
            let vc = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(ofType: HomeViewController.self)
            return vc
        case .profile:
            let vc = UIStoryboard(name: Constants.profile, bundle: nil).instantiateViewController(ofType: ProfileViewController.self)
            return vc
        case .plan:
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: PlanViewController.self)
            vc.setUp(presenter: PlanPresenter(delegate: vc, usecase: PlanUseCase()))
            return vc
        case .addOverall:
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: AddOverallPlanViewController.self)
            return vc
        case .viewOverall:
//            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: OverallPlanViewController.self)
//            let presenter = OverallPlanPresenter(delegate: vc, usecase: OverallPlanUseCase())
//            vc.setUp(presenter: presenter)
            
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: OverallPlanViewController.self)
            return vc
        case .itinerary:
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: ItineraryViewController.self)
            return vc
        case .sharePlan:
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: SharePlanViewController.self)
            return vc
        case .addItinerary:
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: AddItineraryViewController.self)
            return vc
        case .addSchedule:
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: AddScheduleViewController.self)
            return vc
        case .editSchedule(let model):
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: EditScheduleViewController.self)
            vc.model = model
            return vc
        case .recommendTripDetails:
            let vc = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(ofType: RecommendDetailsViewController.self)
            return vc
        case .bottomSheetDetails:
            let vc = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(ofType: DetailsBottomSheetViewController.self)
            return vc
        case .listTrips:
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: ListTripsViewController.self)
            return vc
        case .authentication:
            let vc = UIStoryboard(name: Constants.authentication, bundle: nil).instantiateViewController(ofType: AuthenticationViewController.self)
            return vc
        case .accountDetails:
            let vc = UIStoryboard(name: Constants.profile, bundle: nil).instantiateViewController(ofType: AccountDetailsViewController.self)
            return vc
        case .settings:
            let vc = UIStoryboard(name: Constants.profile, bundle: nil).instantiateViewController(ofType: SettingsViewController.self)
            return vc
        case .listRecommend:
            let vc = UIStoryboard(name: Constants.home, bundle: nil).instantiateViewController(ofType: ListRecommendViewController.self)
            return vc
        case .introContent:
            let vc = UIStoryboard(name: Constants.intro, bundle: nil).instantiateViewController(ofType: IntroContentViewController.self)
            return vc
        case .introPage:
            let vc = UIStoryboard(name: Constants.intro, bundle: nil).instantiateViewController(ofType: IntroPageViewController.self)
            return vc
        case .intro:
            let vc = UIStoryboard(name: Constants.intro, bundle: nil).instantiateViewController(ofType: IntroViewController.self)
            return vc
        case .editOverall(let model):
            let vc = UIStoryboard(name: Constants.plan, bundle: nil).instantiateViewController(ofType: EditOverallViewController.self)
            vc.model = model
            return vc
        }
    }
}

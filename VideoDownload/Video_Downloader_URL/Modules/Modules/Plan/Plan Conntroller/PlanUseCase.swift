//
//  PlanUseCase.swift
//  Traveldy
//
//  Created by Huong Nguyen on 23/04/2021.
//

import UIKit
protocol PlanUseCaseDelegate: BaseUseCaseDelegate {
    func getListPlan(completion: (@escaping ( ResponseServerEntity<[Plan]>?) -> Void))
}

class PlanUseCase: BaseUseCase {

}

extension PlanUseCase: PlanUseCaseDelegate {
    func getListPlan(completion: @escaping ((ResponseServerEntity<[Plan]>?) -> Void)) {
        ApiManage.shared.request(router: .getListPlan) { (data: ResponseServerEntity<[Plan]>) in
            completion(data)
        }
    }
}

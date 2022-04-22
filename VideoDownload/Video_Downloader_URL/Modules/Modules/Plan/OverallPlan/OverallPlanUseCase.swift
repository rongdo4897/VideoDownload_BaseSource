//
//  OverallPlanUseCase.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 22/04/2021.
//

import Foundation

protocol OverallPlanUseCaseDelegate : BaseUseCaseDelegate {
    func getPlan(id: String, completion: @escaping ((ResponseServerEntity<PlanModel>?) -> Void))
}

class OverallPlanUseCase : BaseUseCase {
    
}

extension OverallPlanUseCase : OverallPlanUseCaseDelegate {
    func getPlan(id: String, completion: @escaping ((ResponseServerEntity<PlanModel>?) -> Void)) {
        ApiManage.shared.request(router: .getPlan(id: id)) { (data: ResponseServerEntity<PlanModel>) in
            completion(data)
        }
    }
}

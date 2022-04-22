//
//  OverallPlanPresenter.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 22/04/2021.
//

import Foundation

protocol OverallPlanPresenterDelegate: BasePresenterDelegate {
    func responseData(data: PlanModel)
}

class OverallPlanPresenter : BasePresenter {
    weak var delegate: OverallPlanPresenterDelegate?
    fileprivate var usecase: OverallPlanUseCase?
    
    init(delegate: OverallPlanPresenterDelegate, usecase: OverallPlanUseCase) {
        self.delegate = delegate
        self.usecase = usecase
    }
    
    func getPlan(id: String) {
        usecase?.getPlan(id: id, completion: { [weak self](serverData) in
            if let data = serverData?.data {
                self?.delegate?.responseData(data: data)
            } else {
                self?.delegate?.showError(message: serverData?.message ?? "")
            }
        })
    }
}

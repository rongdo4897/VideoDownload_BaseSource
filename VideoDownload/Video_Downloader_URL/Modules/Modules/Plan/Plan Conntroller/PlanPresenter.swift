//
//  PlanPresenter.swift
//  Traveldy
//
//  Created by Huong Nguyen on 23/04/2021.
//

import UIKit

protocol PlanPresenterDelegate: BasePresenterDelegate {
    func fetchData(data: [Plan])
}
class PlanPresenter: BasePresenter {
    weak var delegate: PlanPresenterDelegate?
    fileprivate var usecase: PlanUseCase?

    init(delegate: PlanPresenterDelegate, usecase: PlanUseCase) {
        self.delegate = delegate
        self.usecase = usecase
    }

    func getListPlan() {
        self.usecase?.getListPlan(completion: { [weak self] (serverData) in
            guard let `self` = self, let serverData = serverData else {
                return
            }
            if let data = serverData.data {
                self.delegate?.fetchData(data: data)
            } else {
                self.delegate?.showError(message: serverData.message ?? "")
            }
        })
    }

    func groupData(data: [Plan]) -> [String: [Plan]] {
        var dict: [String: [Plan]] = [:]
        data.forEach { (model) in
            guard let title = model.status else {return}
            if dict.keys.contains(title) {
                dict[title]?.append(model)
            } else {
                var newData = [Plan]()
                newData.append(model)
                dict[title] = newData
            }
        }
        return dict
    }
}

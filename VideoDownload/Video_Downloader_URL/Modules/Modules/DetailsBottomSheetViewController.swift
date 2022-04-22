//
//  DetailsBottomSheetViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 14/04/2021.
//

import UIKit
enum BottomSheet: Int {
    case text = 0
    case image = 1
}
class DetailsBottomSheetViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pullBarView: UIView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var viewPull: UIView!

    var data: RecommendedTrip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initComponent()
    }

    fileprivate func initData() {
        
    }

    fileprivate func initComponent() {
        viewPull.layer.cornerRadius = viewPull.height / 2
        containerView.layer.cornerRadius = 20
        pullBarView.layer.cornerRadius = 20
        
        detailsTableView.tableFooterView = UIView()
        detailsTableView.rowHeight = UITableView.automaticDimension
        detailsTableView.estimatedRowHeight = 120
        DetailsBottomCell.registerCellByNib(detailsTableView)
        ContentCell.registerCellByNib(detailsTableView)
    }
}

extension DetailsBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case BottomSheet.text.rawValue:
            guard let cell = ContentCell.loadCell(tableView) as? ContentCell else { return UITableViewCell() }
            cell.setUpCell(content: data?.content ?? "")
            cell.btnMore.tag = indexPath.row
            cell.delegate = self
            cell.layoutSubviews()
            return cell
        default:
            guard let cell = DetailsBottomCell.loadCell(tableView) as? DetailsBottomCell else { return UITableViewCell() }
            cell.setUpData(data: data?.gallery ?? [Banner]())
            cell.layoutSubviews()
            return cell
        }
    }

}

extension DetailsBottomSheetViewController: ContentCellDelegate {
    func onClickReadMore(sender: Int) {
        let indexpath = NSIndexPath(row: sender, section: 0)
        let cell = self.detailsTableView.cellForRow(at: indexpath as IndexPath) as? ContentCell

        if(cell?.fixedHeightCons.priority == UILayoutPriority(rawValue: 750)){
            cell?.btnMore.setTitle("View More", for: UIControl.State.normal)
            cell?.fixedHeightCons.priority = UILayoutPriority(rawValue: 250)
            cell?.graterHeightCons.priority = UILayoutPriority(rawValue: 750)
        } else {
            cell?.btnMore.setTitle("Show Less", for: UIControl.State.normal)
            cell?.fixedHeightCons.priority = UILayoutPriority(rawValue: 750)
            cell?.graterHeightCons.priority = UILayoutPriority(rawValue: 250)

        }
        detailsTableView.reloadData()
    }
}

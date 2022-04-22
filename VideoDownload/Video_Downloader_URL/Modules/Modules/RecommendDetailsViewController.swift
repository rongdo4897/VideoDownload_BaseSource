//
//  RecommendDetailsViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 4/13/21.
//

import UIKit
import OverlayContainer

class RecommendDetailsViewController: BaseViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var imgLocation: UIImageView!

    var detailsBottomSheet: DetailsBottomSheetViewController?
    var data: RecommendedTrip?

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initComponent()
    }

    fileprivate func initData() {
        lbName.text = data?.name
        lbLocation.text = data?.location
        imgLocation.image = UIImage(named: data?.image ?? "")
    }

    fileprivate func initComponent() {
        
    }
    
    @IBAction func popToView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

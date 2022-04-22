//
//  IntroContentViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 22/04/2021.
//

import UIKit

class IntroContentViewController: UIViewController {

    @IBOutlet weak var imgIntro: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var index = 0
    var heading = ""
    var subTitle = ""
    var image = ""
    var numberOfPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        lbTitle.text = heading
        lbSubTitle.text = subTitle
        imgIntro.image = UIImage(named: image)
        pageControl.numberOfPages = numberOfPage
        pageControl.currentPage = index

        imgIntro.layer.cornerRadius = 40
        imgIntro.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

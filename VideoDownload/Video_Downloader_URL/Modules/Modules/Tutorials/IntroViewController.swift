//
//  IntroViewController.swift
//  Traveldy
//
//  Created by Huong Nguyen on 22/04/2021.
//

import UIKit

class IntroViewController: BaseViewController {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!

    var introPage: IntroPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initComponent()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? IntroPageViewController {
            introPage = pageViewController
            introPage?.introDelegate = self
        }
    }

    fileprivate func initData() {
        
    }

    fileprivate func initComponent() {
        btnNext.layer.cornerRadius = 10
    }

    @IBAction func onClickNext(_ sender: Any) {
        if let index = introPage?.currentIndex {
            switch index {
            case 0...(IntroConstant.numberOfItem - 2):
                introPage?.forwardPage()
            case (IntroConstant.numberOfItem - 1):
                UserDefaults.standard.set(true, forKey: "hasViewIntro")
                let vc = RouterType.tabbar.getVc()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
        updateUI()
    }

    func updateUI() {
        if let index = introPage?.currentIndex {
            switch index {
            case 0...(IntroConstant.numberOfItem - 2):
                btnNext.setTitle("Next", for: .normal)
                btnSkip.isHidden = false
            case (IntroConstant.numberOfItem - 1):
                btnNext.setTitle("Get Started", for: .normal)
                btnSkip.isHidden = true
            default:
                break
            }
        }
    }

    @IBAction func onClickSkip(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "hasViewIntro")
        let vc = RouterType.tabbar.getVc()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension IntroViewController: IntroPageViewControllerDelegate {
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}

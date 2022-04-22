//
//  NoteViewController.swift
//  Traveldy
//
//  Created by Thuy Nguyen Duong Thu on 14/04/2021.
//

import UIKit

protocol NoteDelegate: class {
    func dismissNote()
}

class NoteViewController: UIViewController {

    
    @IBOutlet weak var backViewNote: UIView!
    @IBOutlet weak var textView: UITextView!
    var note: String?
    weak var delegate: NoteDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        if let note = self.note {
            self.textView.text = note
        }
    }
    
    fileprivate func initComponents() {
        backViewNote.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        backViewNote.layer.cornerRadius = 13
    }
    
    @IBAction func clickClose(_ sender: Any) {
        note = nil
        delegate?.dismissNote()
    }
    
}

//
//  PanAndRotateView.swift
//  BaseTableView
//
//  Created by Hoang Lam on 24/11/2021.
//

import Foundation
import UIKit

enum Actiontype {
    case share
    case save
    case play
    case delete
    case none
}

protocol PanDynamicViewDelegate: AnyObject {
    func getLocation(location: CGPoint, type: Actiontype)
}

class PanDynamicView: UIView {
    weak var delegate: PanDynamicViewDelegate?
    var isRotate = false
    
    var type: Actiontype!
    
    func signleDragable(view: UIView, damping: CGFloat = 0.4, type: Actiontype) -> Void {
        self.type = type
        signleDraggableInView(view: view, damping: damping)
    }
    
    func signleDraggableInView(view: UIView!, damping: CGFloat) -> Void {
        if (view) != nil {
            removeAllDraggable()
            zm_playground = view
            zm_damping = damping
            signleAnimator()
            signleAddPanGesture()
        }
    }
    
    private func removeAllDraggable() -> Void {
        if (zm_panGesture) != nil {
            self.removeGestureRecognizer(zm_panGesture!)
        }
        zm_panGesture = nil
        zm_playground = nil
        zm_animator = nil
        zm_snapBehavior = nil
        zm_attachmentBehavior = nil
        zm_centerPoint = CGPoint.zero
    }
    
    private func signleAnimator() -> Void {
        zm_animator = UIDynamicAnimator.init(referenceView: zm_playground!)
        signleUpdateSnapPoint()
    }
    
    private func signleUpdateSnapPoint() -> Void {
        zm_centerPoint = self.convert(CGPoint.init(x: self.bounds.size.width/2, y: self.bounds.size.height/2), to: zm_playground!)
        zm_snapBehavior = UISnapBehavior.init(item: self, snapTo: zm_centerPoint!)
        zm_snapBehavior?.damping = zm_damping!
    }
    
    private func signleAddPanGesture() -> Void {
        zm_panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(signlePanGesture(pan:)))
        self.addGestureRecognizer(zm_panGesture!)
    }
    
    @objc func signlePanGesture(pan: UIPanGestureRecognizer) -> Void {
        let panLocation = pan.location(in: zm_playground)
        if pan.state == .began {
            signleUpdateSnapPoint()
            let offSet = UIOffset(horizontal: panLocation.x - (zm_centerPoint?.x)!, vertical: panLocation.y - (zm_centerPoint?.y)!)
            zm_animator?.removeAllBehaviors()
            if isRotate {
                zm_attachmentBehavior = UIAttachmentBehavior.init(item: self, offsetFromCenter: offSet, attachedToAnchor: panLocation)
            } else {
                zm_attachmentBehavior = UIAttachmentBehavior.init(item: self, attachedToAnchor: panLocation)
            }
            zm_animator?.addBehavior(zm_attachmentBehavior!)
            delegate?.getLocation(location: zm_centerPoint!, type: self.type)
        } else if pan.state == .changed {
            zm_attachmentBehavior?.anchorPoint = panLocation
            delegate?.getLocation(location: panLocation, type: self.type)
        } else if (pan.state == .ended) || (pan.state == .cancelled) || (pan.state == .failed) {
            zm_animator?.addBehavior(zm_snapBehavior!)
            zm_animator?.removeBehavior(zm_attachmentBehavior!)
            delegate?.getLocation(location: zm_centerPoint!, type: .none)
        }
    }

    // View g???c (superview)
    private var zm_playground: UIView? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_playgroundKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_playgroundKey!) as? UIView
        }
    }
    
    /*
     UIDynamicAnimator: M???t ?????i t?????ng cung c???p c??c kh??? n??ng v?? ho???t ???nh li??n quan ?????n v???t l?? cho c??c m???c ?????ng c???a n?? v?? cung c???p b???i c???nh cho c??c ho???t ???nh ????.
     */
    private var zm_animator: UIDynamicAnimator? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_animatorKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_animatorKey!) as? UIDynamicAnimator
        }
    }
    
    /*
     UISnapBehavior: M???t h??nh vi gi???ng nh?? l?? xo m?? chuy???n ?????ng ban ?????u c???a n?? b??? t???t d???n theo th???i gian ????? v???t ???? ?????ng y??n t???i m???t ??i???m c??? th???. ( tr??? v??? v??? tr?? g???c s??? rung )
     */
    private var zm_snapBehavior: UISnapBehavior? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_snapBehavior!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_snapBehavior!) as? UISnapBehavior
        }
    }
    
    /*
     UIAttachmentBehavior: M???i quan h??? gi???a hai m???c ?????ng ho???c gi???a m???t m???c ?????ng v?? ??i???m neo.
     */

    private var zm_attachmentBehavior: UIAttachmentBehavior? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_attachmentBehavior!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_attachmentBehavior!) as? UIAttachmentBehavior
        }
    }
    
    // K??o view
    private var zm_panGesture: UIPanGestureRecognizer? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_panGesture!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_panGesture!) as? UIPanGestureRecognizer
        }
    }
    
    // ??i???m trung t??m (s??? d???ng ????? rung khi tr??? v??? v??? tr?? c??)
    private var zm_centerPoint: CGPoint? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_centerPoint!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_centerPoint!) as? CGPoint
        }
    }
    
    // T???c ????? h???i l???i so v???i v??? tr?? g???c
    private var zm_damping: CGFloat? {
        set{
            objc_setAssociatedObject(self, RuntimeKey.zm_damping!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, RuntimeKey.zm_damping!) as? CGFloat
        }
    }
}

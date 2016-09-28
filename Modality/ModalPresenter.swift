//
//  ModalPresenter.swift
//  Modality
//
//  Created by Chase Wasden on 9/26/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import Foundation


//@objc
public protocol ModalPresenter {
    //    func setInitialModalWrapperConstraints(_ modal:Modal)
    func presentModal(_ modal:Modal, animated:Bool, completion:@escaping ()->())
    func dismissModal(_ modal:Modal, completion:@escaping ()->() )
}



public class ModalPresenterRightEdge: ModalPresenter {
    
    public init() { }
    
    public func presentModal(_ modal: Modal, animated: Bool, completion:@escaping ()->()) {
        let vc = modal.viewController
        let width = modal.settings.preferredModalSize.width
        vc.modalWrapper.alSetDimension( .width, toSize: width)
        vc.modalWrapper.alPinEdgesToSuperviewEdges(withInsets: .zero, excludingEdge: .left)
        
        if animated {
            vc.view.layoutIfNeeded()
            vc.modalWrapper.transform = CGAffineTransform(translationX: width, y: 0)
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                vc.modalWrapper.transform = CGAffineTransform.identity
                completion()
            })
        }
        else {
            vc.modalWrapper.transform = CGAffineTransform.identity
            completion()
        }
    }
    
    public func dismissModal(_ modal: Modal, completion: @escaping (Void) -> Void) {
        let vc = modal.viewController
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            vc.modalWrapper.transform = CGAffineTransform(translationX: vc.view.bounds.size.width, y: 0)
        }, completion: { (success) -> Void in
            completion()
        })
    }
    
}

public class ModalPresenterCentered: ModalPresenter {
    
    public init() {}
    
    public func constrainModalWrapper(_ modal: Modal, animated: Bool) {
        let vc = modal.viewController
        NSLayoutConstraint.alSetPriority(999) {
            //            vc.preferredModalWidthConstraint =
            vc.modalWrapper.alSetDimension(.width, toSize: modal.settings.preferredModalSize.width)
        }
        NSLayoutConstraint.alSetPriority(998) {
            vc.modalWrapper.alCenterInSuperview()
        }
        
        vc.modalWrapper.alPinEdge(toSuperviewEdge: .top, withInset: 20, relation: .greaterThanOrEqual)
    }
    
    public func presentModal(_ modal:Modal, animated:Bool, completion:@escaping ()->()) {
        constrainModalWrapper(modal, animated: animated)
        modal.viewController.view.layoutIfNeeded()
        presentView(modal.viewController.modalWrapper, animated: animated, completion:completion)
    }
    
    public func dismissModal(_ modal: Modal, completion: @escaping (Void) -> Void) {
        dismissView(modal.viewController.modalWrapper, completion: completion)
    }
    
    
    func presentView(_ view:UIView, animated:Bool, completion:@escaping ()->() ) {
        if animated {
            view.alpha = 0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                view.alpha = 1
            })
            
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 18, options: [], animations: {
                view.transform.a = 1 // x
                }, completion: nil)
            UIView.animate(withDuration: 0.48, delay: 0.04, usingSpringWithDamping: 0.8, initialSpringVelocity: 18, options: [], animations: {
                view.transform.d = 1 // y
            }) { _ in
                completion()
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                view.transform = CGAffineTransform.identity
                view.alpha = 1
            })
        }
        else {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
            view.alpha = 1
            completion()
        }
    }
    
    func dismissView(_ view:UIView, completion:@escaping (()->())) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: { () -> Void in
            view.transform = CGAffineTransform(translationX: 0, y: -1000)
            view.alpha = 1
            }, completion: { _ in
                completion()
        })
    }
}



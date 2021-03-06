//
//  Modal.swift
//  Modality
//
//  Created by Chase Wasden on 9/27/16.
//  
//

import Foundation


public class Modal:ModalViewControllerDelegate, Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Modal, rhs: Modal) -> Bool {
        return lhs.viewController == rhs.viewController
    }
    
    
    public let contentView:UIView
    public let viewController = ModalViewController()
    public let settings:ModalSettings
    
    internal let presenter:ModalPresenter
    internal var buttonRows = [[ModalButton]]()
    
    //    public var modalView:UIView
    
    public init(contentView:UIView, settings:ModalSettingsMap = [], presenter:ModalPresenter = ModalPresenterCentered()) {
        self.settings = Modality.defaultSettings.withSettings(settings)
        self.contentView = contentView
        self.presenter = presenter
        viewController.delegate = self
        //        viewController.afterViewLoad = {
        //
        //        }
    }
    
    public func show(_ animated:Bool = true) {
        Modality.shared.showModal(self, animated:animated)
    }
    
    public func dismiss(animated:Bool = true, completion:(()->())? = nil) {
        Modality.shared.dismissModal(self, completion: completion)
    }
    
    @objc internal func dismiss() {
        dismiss(animated: false)
    }
    
    func removeFromWindow(animated:Bool = true, completion:(()->())? = nil) {
        if animated && settings.autoFadeContainer {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations:
                { () -> Void in
                    self.viewController.containerView.alpha = 0
            })
        }
        
        if animated {
            self.presenter.dismissModal(self) {
                self.viewController.removeFromParentViewController()
                self.viewController.view.removeFromSuperview()
                completion?()
            }
        }
        else {
            self.viewController.removeFromParentViewController()
            self.viewController.view.removeFromSuperview()
            completion?()
        }
    }
    
    internal func showInWindow(_ window:UIWindow, animated:Bool = true){
        window.addSubview(viewController.view)
        viewController.view.alPinEdgesToSuperviewEdges()
        
        if let rvc = window.rootViewController {
            rvc.addChildViewController(viewController)
        }
        else {
            window.rootViewController = viewController
        }
        
        if animated && settings.autoFadeContainer {
            viewController.containerView.alpha = 0
            
            UIView.animate(withDuration: 0.25, animations:
                { () -> Void in
                    self.viewController.containerView.alpha = 1
            })
        }
        
        presenter.presentModal(self, animated: animated) {}
    }
    
    public func addButton(_ type:ModalButtonType) {
        let modalButton = type.modalButton
        subscribeButtonTap(modalButton, completion: type.modalOnPressed)
        buttonRows.append([modalButton])
    }
    
    public func addButtonRow(_ types:[ModalButtonType]) {
        let modalButtons = types.map { $0.modalButton }
        for (i, button) in modalButtons.enumerated() {
            let onPressed = types[i].modalOnPressed
            subscribeButtonTap(button, completion:onPressed)
        }
        buttonRows.append(modalButtons)
    }
    
    public func setButtonRows(_ rows:[[ModalButtonType]]) {
        buttonRows = []
        for row in rows {
            addButtonRow(row)
        }
    }
    
    func subscribeButtonTap(_ button:ModalButton, completion:(()->())?) {
        button.modalButton.block_setAction { [weak self] in
            if let shouldDismiss = self?.settings.dismissOnButtonTap, shouldDismiss {
                self?.dismiss()
            }
            completion?()
        }
    }
    
    
    
}





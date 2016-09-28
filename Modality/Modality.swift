//
//  Modality.swift
//  Modality
//
//  Created by Chase Wasden on 9/26/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import UIKit

public class Modality {
    
    public static var defaultSettings = ModalSettings()
    public var defaultButtonBuilder:((String)->ModalButton) = { return DefaultButtonType(text:$0, modalOnPressed:nil).modalButton }
    
    private var mainWindow:UIWindow?
    private var modalWindow = UIWindow()
    private var modalStack = [Modal]()
    
    static func updateDefaultSettings(settings:ModalSettingsMap) {
        defaultSettings = defaultSettings.withSettings(settings)
    }
    
    static let shared = Modality()
    
    
    public class func showAlert(_ message:String, buttons:[ModalButtonType]) {
        let modal = ModalAlert(message: message)
        for button in buttons {
            modal.addButton(button)
        }
        modal.show()
    }
    
//    public class func showWithTitle(_ title:Strign, message:String, buttons:)
    
    //    public class func showTitle(_ title:String, message:String, buttons:[ButtonType]) {
    //        let dialog = DialogTitled()
    //        dialog.setMessageText(message)
    //        dialog.setTitleText(title)
    //        dialog.addButtonRow(buttons)
    //        Modality.shared.showDialog(dialog)
    //    }
    //
    //    public class func showSuccess(_ message:String, buttons:[String], handler:((Dialog, Int)->Void)? = nil) {
    //        let dialog = DialogSuccess()
    //        dialog.setMessageText(message)
    //        addButtonsToDialog(dialog, buttons: buttons, handler: handler)
    //        Modality.shared.showDialog(dialog)
    //    }
    
    
    
    
    internal func hideModalWindow() {
        if let mainWindow = mainWindow , modalStack.count == 0 {
            modalWindow.removeFromSuperview()
            modalWindow.windowLevel = mainWindow.windowLevel - 1
            modalWindow.rootViewController = nil
            
            mainWindow.makeKeyAndVisible()
        }
    }
    
    internal func showModal(_ modal:Modal, animated:Bool = true) {
        if !modalWindow.isKeyWindow {
            modalWindow.frame = (UIApplication.shared.keyWindow?.frame)!
            mainWindow = UIApplication.shared.keyWindow
            mainWindow?.endEditing(true)
            modalWindow.windowLevel = UIWindowLevelStatusBar + 1
            modalWindow.backgroundColor = UIColor.clear
            modalWindow.makeKeyAndVisible()
        }
        
        modal.showInWindow(modalWindow, animated:animated)
        modalStack.append(modal)
    }
    
    internal func dismissModal(_ modal:Modal, animated:Bool = true, completion:(()->())? = nil){
        if let index = modalStack.index(of: modal) {
            let modal = modalStack.remove(at: index)
            modal.removeFromWindow(animated:animated) {
                self.hideModalWindow()
                if self.modalWindow.rootViewController == modal.viewController {
                    self.modalWindow.rootViewController = nil
                }
                completion?()
            }
        }
    }
    
}



//
//  ModalStyles.swift
//  Modality
//
//  Created by Chase Wasden on 10/3/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import Foundation

public class ModalWithViewController: Modal {
    let subViewController:UIViewController
    public init(viewController:UIViewController, settings: ModalSettingsMap = [], presenter: ModalPresenter = ModalPresenterCentered()) {
        subViewController = viewController
        super.init(contentView: viewController.view, settings: settings, presenter: presenter)
        self.viewController.addChildViewController(viewController)
    }
}

public class ModalWithIconTitle: ModalWithMessage {
    internal let titleIcon:UIImage
    init(icon:UIImage, message: String, settings: ModalSettingsMap = []) {
        titleIcon = icon
        super.init(message: message, settings: settings)
    }
    override public func buildTitleView() -> UIView? {
        let titleView = UIImageView()
        titleView.image = titleIcon
        return titleView
    }
}

public class ModalAlert: ModalWithIconTitle {
    public init(message: String, settings: ModalSettingsMap = []) {
        super.init(icon:Modality.shared.alertImage, message: message, settings: settings)
    }
}

public class ModalSuccess: ModalWithIconTitle {
    public init(message: String, settings: ModalSettingsMap = []) {
        super.init(icon:Modality.shared.successImage, message: message, settings: settings)
    }
}

public class ModalTitleMessage: ModalWithMessage {
    internal var title = ""
    init(title:String, message: String, settings: ModalSettingsMap = []) {
        self.title = title
        super.init(message: message, settings: settings)
    }
    public override func buildTitleView() -> UIView? {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = title
        label.font = settings.fontSettings.titleFont
        label.textColor = settings.fontSettings.titleColor
        return label
    }
}

public class ModalWithMessage : Modal {
    
    public let messageLabel = UILabel()
    
    private let lrPadding:CGFloat = 20
    private let tbPadding:CGFloat = 40
    
    public init(message:String, settings: ModalSettingsMap = []) {
        super.init(contentView: UIView(), settings: settings)
        setMessage(message)
        setupContentView()
    }
    
    public func setMessage(_ text:String) {
        let style = defaultModalParagraphStyle()
        style.alignment = .center
        let attr = [NSParagraphStyleAttributeName:style]
        let font = settings.fontSettings.descriptionFont
        let color = settings.fontSettings.descriptionColor
        messageLabel.attributedText = NSAttributedString(string:text, font: font, color: color, attributes:attr)
    }
    
    func setupContentView() {
        setupMessageLabel()
        setupTitleView()
        
        viewController.modalView.backgroundColor = UIColor.white
    }
    
    func setupMessageLabel() {
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        contentView.addSubview(messageLabel)
        messageLabel.alPinEdgesToSuperviewEdges(withInsets: UIEdgeInsetsMake(0, lrPadding, tbPadding-5, lrPadding), excludingEdge: .top)
    }
    
    func setupTitleView() {
        if let titleView = buildTitleView() {
            contentView.addSubview(titleView)
            if let _ = titleView as? UIImageView {
                titleView.alPinEdge(toSuperviewEdge: .top, withInset:tbPadding)
                titleView.alSetDimensions(toSize: CGSize(width: 50, height: 50))
                titleView.alAlignAxis(toSuperviewAxis: .vertical)
            }
            else {
                titleView.alPinEdgesToSuperviewEdges(withInsets: UIEdgeInsetsMake(tbPadding, lrPadding, 0, lrPadding), excludingEdge: .bottom)
            }
            messageLabel.alPin(edge: .top, toEdge: .bottom, ofView: titleView, withOffset: 10)
        }
        else {
            messageLabel.alPinEdge(toSuperviewEdge: .top, withInset: tbPadding)
        }
    }
    
    public func buildTitleView() -> UIView? {
        return nil
    }
    
}


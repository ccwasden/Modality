//
//  ModalSettings.swift
//  Modality
//
//  Created by Chase Wasden on 9/27/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import Foundation

struct ModalShadowSettings {
    let opacity:CGFloat
    let radius:CGFloat
    let offset:CGSize
    let color:UIColor
}

struct ModalFontSettings {
    let titleFont:UIFont
    let titleColor:UIColor
    let descriptionFont:UIFont
    let descriptionColor:UIColor
}

private let defaultTitleFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)!
private let defaultDescriptionFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!

public typealias ModalSettingsMap = [ModalSetting:Any]

public enum ModalSetting:Int {
    case hideStatusBar
    case dismissOnBackgroundTap
    case dismissOnButtonTap
    case containerColor
    case modalColor
    case cornerRadius
    case shadowSettings
    case defaultButtonStyle
    case fontSettings
    case preferredModalSize
    case autoFadeContainer
}

public struct ModalSettings {
    
    var hideStatusBar:Bool = false
    var dismissOnBackgroundTap = true
    var dismissOnButtonTap = true
    var containerColor:UIColor = UIColor(white: 0.8, alpha: 0.7)
    var modalColor:UIColor? = .white
    var cornerRadius:CGFloat = 8
    var shadowSettings:ModalShadowSettings? = nil
    //    var defaultButtonStyle:ButtonType = DefaultButtonType(text:"asdf", )
    var fontSettings = ModalFontSettings(titleFont: defaultTitleFont,
                                         titleColor: .black,
                                         descriptionFont: defaultDescriptionFont,
                                         descriptionColor: .darkGray)
    var preferredModalSize = CGSize(width: 300, height: 400)
    var autoFadeContainer = true
    
    func withSettings(_ newSettings:ModalSettingsMap) -> ModalSettings {
        return ModalSettings(
            hideStatusBar: (newSettings[.hideStatusBar] as? Bool) ?? hideStatusBar,
            dismissOnBackgroundTap: (newSettings[.dismissOnBackgroundTap] as? Bool) ?? dismissOnBackgroundTap,
            dismissOnButtonTap: (newSettings[.dismissOnButtonTap] as? Bool) ?? dismissOnButtonTap,
            containerColor: (newSettings[.containerColor] as? UIColor) ?? containerColor,
            modalColor: (newSettings[.modalColor] as? UIColor) ?? modalColor,
            cornerRadius: (newSettings[.cornerRadius] as? CGFloat) ?? cornerRadius,
            shadowSettings: (newSettings[.shadowSettings] as? ModalShadowSettings) ?? shadowSettings,
            //:        defaultButtonStyle (newSettings[.defaultButtonStyle] as? ) ?? defaultButtonStyle,
            fontSettings: (newSettings[.fontSettings] as? ModalFontSettings) ?? fontSettings,
            preferredModalSize: (newSettings[.preferredModalSize] as? CGSize) ?? preferredModalSize,
            autoFadeContainer: (newSettings[.autoFadeContainer] as? Bool) ?? autoFadeContainer
        )
    }
    
}

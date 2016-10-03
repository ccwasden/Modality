//
//  ModalSettings.swift
//  Modality
//
//  Created by Chase Wasden on 9/27/16.
//  
//

import Foundation

public struct ModalShadowSettings {
    let opacity:Float
    let radius:CGFloat
    let offset:CGSize
    let color:UIColor
    public init(opacity:Float, radius:CGFloat, offset:CGSize, color:UIColor) {
        self.opacity = opacity
        self.radius = radius
        self.offset = offset
        self.color = color
    }
}

public struct ModalFontSettings {
    let titleFont:UIFont
    let titleColor:UIColor
    let descriptionFont:UIFont
    let descriptionColor:UIColor
    public init(titleFont:UIFont, titleColor:UIColor, descriptionFont:UIFont, descriptionColor:UIColor) {
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.descriptionFont = descriptionFont
        self.descriptionColor = descriptionColor
    }
}

private let defaultTitleFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)!
private let defaultDescriptionFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!

public typealias ModalSettingsMap = [ModalSetting]


public enum ModalSetting {
    case autoFadeContainer(Bool)
    case containerColor(UIColor)
    case cornerRadius(CGFloat)
    case dismissOnBackgroundTap(Bool)
    case dismissOnButtonTap(Bool)
    case fontSettings(ModalFontSettings)
    case hideStatusBar(Bool)
    case modalColor(UIColor?)
    case preferredModalSize(CGSize)
    case shadow(ModalShadowSettings?)
}

public struct ModalSettings {
    
    var autoFadeContainer:Bool = true
    var containerColor:UIColor = UIColor(white: 0.1, alpha: 0.6)
    var cornerRadius:CGFloat = 8
    var dismissOnBackgroundTap:Bool = true
    var dismissOnButtonTap:Bool = true
    var fontSettings:ModalFontSettings = ModalFontSettings(titleFont: defaultTitleFont,
                                                           titleColor: .black,
                                                           descriptionFont: defaultDescriptionFont,
                                                           descriptionColor: .darkGray)
    var hideStatusBar:Bool = false
    var modalColor:UIColor? = .white
    var preferredModalSize:CGSize = CGSize(width: 300, height: 400)
    var shadow:ModalShadowSettings? = ModalShadowSettings(opacity: 0.2,
                                                          radius: 4,
                                                          offset: CGSize(width:0,height:2),
                                                          color: .black)
    
    func withSettings(_ newSettings:ModalSettingsMap) -> ModalSettings {
        var mutable = self
        for setting in newSettings {
            switch setting {
            case .autoFadeContainer(let autoFadeContainer):
                mutable.autoFadeContainer = autoFadeContainer
            case .containerColor(let containerColor):
                mutable.containerColor = containerColor
            case .cornerRadius(let cornerRadius):
                mutable.cornerRadius = cornerRadius
            case .dismissOnBackgroundTap(let dismissOnBackgroundTap):
                mutable.dismissOnBackgroundTap = dismissOnBackgroundTap
            case .dismissOnButtonTap(let dismissOnButtonTap):
                mutable.dismissOnButtonTap = dismissOnButtonTap
            case .fontSettings(let fontSettings):
                mutable.fontSettings = fontSettings
            case .hideStatusBar(let hideStatusBar):
                mutable.hideStatusBar = hideStatusBar
            case .modalColor(let modalColor):
                mutable.modalColor = modalColor
            case .preferredModalSize(let preferredModalSize):
                mutable.preferredModalSize = preferredModalSize
            case .shadow(let shadow):
                mutable.shadow = shadow
            }
        }
        return mutable
    }
    
}


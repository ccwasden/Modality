//
//  FontsManager.swift
//  DialogManager
//
//  Created by Chase Wasden on 9/26/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import UIKit

enum FontWeight: String {
    //    case ExtraLight = "ExtraLight"
    //    case ExtraLightItalic = "ExtraLightItalic"
    case Light = "Light"
    case LightItalic = "LightItalic"
    case Regular = "Regular"
    case RegularItalic = "RegularItalic"
    case Medium = "Medium"
    case MediumItalic = "MediumItalic"
    case Bold = "Bold"
    case BoldItalic = "BoldItalic"
    case Heavy = "Heavy"
    case HeavyItalic = "HeavyItalic"
}

protocol FontNameMapper {
    func map(_ weight:FontWeight) -> String
}


extension FontWeight {
    var AppleSDSuffix:String {
        switch self {
        case .LightItalic, .RegularItalic, .MediumItalic, .BoldItalic, .HeavyItalic:
            return rawValue
        case .Light:
            return "Light"
        case .Regular:
            return "Regular"
        case .Medium:
            return "Medium"
        case .Bold:
            return "SemiBold"
        case .Heavy:
            return "Bold"
        }
    }
}

struct AppleSDMapper: FontNameMapper {
    func map(_ weight: FontWeight) -> String {
        return "AppleSDGothicNeo-\(weight.AppleSDSuffix)"
    }
}

struct IconFontMapper: FontNameMapper {
    func map(_ weight: FontWeight) -> String {
        return "FontAwesome"
    }
}

class FontsManager {
    
    static let shared = FontsManager()
    
    var primaryMapper:FontNameMapper = AppleSDMapper()
    var secondaryMapper:FontNameMapper = AppleSDMapper()
    var fontMapper:FontNameMapper = IconFontMapper()
    
    func primaryFont(_ weight:FontWeight, size:CGFloat) -> UIFont {
        return UIFont(name: primaryFontName(weight), size: size) ?? UIFont()
    }
    
    func secondaryFont(_ weight:FontWeight, size:CGFloat) -> UIFont {
        return UIFont(name: secondaryFontName(weight), size: size) ?? UIFont()
    }
    
    func primaryFontName(_ weight:FontWeight) -> String {
        return primaryMapper.map(weight)
    }
    
    func secondaryFontName(_ weight:FontWeight) -> String {
        return secondaryMapper.map(weight)
    }
    
}

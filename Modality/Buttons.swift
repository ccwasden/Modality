//
//  Buttons.swift
//  DialogManager
//
//  Created by Chase Wasden on 9/26/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import Foundation


public protocol ModalButtonType {
    var modalButton:ModalButton { get }
    var modalOnPressed:(()->())? { get }
}

public protocol ModalButton {
    var modalButtonView:UIView { get }
    var modalButton:UIButton { get }
}

extension UIButton:ModalButton {
    public var modalButtonView: UIView {
        return self
    }
    public var modalButton: UIButton {
        return self
    }
}

extension String:ModalButtonType {
    public var modalButton:ModalButton {
        return Modality.shared.defaultButtonBuilder(self)
    }
    public var modalOnPressed:(()->())? { return nil }
}







class MainButtonGray: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = DefaultsStyleKit.background
        layer.borderColor = DefaultsStyleKit.lightGray.cgColor
        layer.borderWidth = 0.5
        setTitleColor(DefaultsStyleKit.textColor, for: UIControlState())
        setTitleColor(DefaultsStyleKit.mediumTextColor, for: .highlighted)
        titleLabel?.font = Modality.defaultSettings.fontSettings.titleFont
    }
    
    override var intrinsicContentSize : CGSize {
        let hPadding = CGFloat(20)
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width + hPadding*2, height: 46)
    }
    
}

//public protocol ButtonType {
//    var callback:(()->Void)? { get }
//    var button:(UIView, UIButton) { get }
//}

struct DefaultButtonType: ModalButtonType {
    let text:String
    let modalOnPressed: (()->())?
    
    var modalButton: ModalButton {
        let button = MainButtonGray()
        button.setTitle(text, for: .normal)
        return button
    }
}

//struct RoundedButtonType: ButtonType {
//    let color:UIColor
//    let text:String
//    let callback: (() -> Void)?
//    //    let height:Int
//    var button:(UIView, UIButton) {
//        let button = RoundedButton()
//        button.setTitle(text, for: UIControlState())
//        button.setColor(color, forState: UIControlState())
//        button.setColor(color.mixDarker(), forState: .highlighted)
//        return (button, button)
//    }
//}
//
//struct CircleImageButtonType: ButtonType {
//    let image:UIImage
//    let callback: (() -> Void)?
//    
//    var button: (UIView, UIButton) {
//        let button = CircleImageButton()
//        button.setImage(image, for: UIControlState())
//        return (button, button)
//    }
//}

class CircleImageButton: UIButton {
    
    var height:CGFloat = 46
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    func setup() {
        //        backgroundColor = DefaultsStyleKit.background
        backgroundColor = UIColor.white
        setBackgroundImage(UIImage.fromColor(DefaultsStyleKit.background), for: .highlighted)
        layer.cornerRadius = height/2
        layer.borderColor = DefaultsStyleKit.lightGray.cgColor
        layer.borderWidth = 1
        
        clipsToBounds = true
    }
    
    override var intrinsicContentSize : CGSize {
        return CGSize(width: height, height: height)
    }
    
}


class RoundedButton: UIButton {
    
    var height:CGFloat = 46
    var hPadding:CGFloat = 35
    var fontSize:CGFloat = 15
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = DefaultsStyleKit.background
        layer.cornerRadius = height/2
       
        titleLabel?.font = Modality.defaultSettings.fontSettings.titleFont
        
        //        layer.borderColor = DefaultsStyleKit.lightGray.CGColor
        //        layer.borderWidth = 0.5
        setTitleColor(UIColor.white, for: UIControlState())
        //        setTitleColor(DefaultsStyleKit.mediumTextColor, forState: .Highlighted)
        //        titleLabel?.font = AvenirFont(14, weight: .Black)
        clipsToBounds = true
    }
    
    func setColor(_ color:UIColor, forState:UIControlState) {
        setBackgroundImage(UIImage.fromColor(color), for: forState)
    }
    
    func setColor(_ color:UIColor) {
        setColor(color, forState: UIControlState())
        setColor(color.mixDarker(), forState: .highlighted)
    }
    
    override var intrinsicContentSize : CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width + hPadding*2, height: height)
    }
    
}

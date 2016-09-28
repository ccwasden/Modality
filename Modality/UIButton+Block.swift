//
//  UIButton+Block.swift
//  KinjaDealsApp
//
//  Created by Chase Wasden on 2/4/16.
//  Copyright © 2016 Chase Wasden. All rights reserved.
//

//import UIKit
import ObjectiveC

var ActionBlockKey: UInt8 = 0

// a type for our action block closure
typealias BlockButtonActionBlock = () -> Void

class ActionBlockWrapper : NSObject {
    var block : BlockButtonActionBlock
    init(block: @escaping BlockButtonActionBlock) {
        self.block = block
    }
}

extension UIButton {
    func block_setAction(_ block: BlockButtonActionBlock?) {
        guard let block = block else { return }
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(block_handleAction), for: .touchUpInside)
    }
    
    func block_handleAction(_ sender: UIButton) {
        let wrapper = objc_getAssociatedObject(self, &ActionBlockKey) as! ActionBlockWrapper
        wrapper.block()
    }
}

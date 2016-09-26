//
//  Utilities.swift
//  DialogManager
//
//  Created by Chase Wasden on 9/26/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import Foundation

enum LayoutEdge {
    case left
    case right
    case top
    case bottom
    case leading
    case trailing
    
    var attribute:NSLayoutAttribute {
        switch self {
        case .left:
            return .left
        case .right:
            return .right
        case .top:
            return .top
        case .bottom:
            return .bottom
        case.leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

enum LayoutDimension {
    case width
    case height
    
    var attribute:NSLayoutAttribute {
        switch self {
        case .width:
            return .width
        case .height:
            return .height
        }
    }
}

enum LayoutAxis {
    case vertical
    case horizontal
    case baseline
    case firstBaseline
    case lastBaseline
    
    var attribute:NSLayoutAttribute {
        switch self {
        case .vertical:
            return .centerX
        case .horizontal:
            return .centerY
        case .baseline:
            return .lastBaseline
        case .lastBaseline:
            return .lastBaseline
        case .firstBaseline:
            return .firstBaseline
        }
    }
}

enum LayoutMargin {
    case left
    case right
    case top
    case bottom
    case leading
    case trailing
    
    var attribute:NSLayoutAttribute {
        switch self {
        case .left:
            return .leftMargin
        case .right:
            return .rightMargin
        case .top:
            return .topMargin
        case .bottom:
            return .bottomMargin
        case .leading:
            return .leadingMargin
        case .trailing:
            return .trailingMargin
        }
    }
}

enum LayoutMarginAxis {
    case vertical
    case horizontal
    var attribute:NSLayoutAttribute {
        switch self {
        case .vertical:
            return .centerXWithinMargins
        case .horizontal:
            return .centerYWithinMargins
        }
    }
}

//enum LayoutAttribute {
//    case left
//    case right
//    case top
//    case bottom
//    case leading
//    case trailing
//    case width
//    case height
//    case vertical
//    case horizontal
//    case baseline
//    case lastbaseline
//    case firstBaseline
//    case marginLeft
//    case marginRight
//    case marginTop
//    case marginBottom
//    case marginLeading
//    case marginTrailing
//    case marginAxisVertical
//    case marginAxisHorizontal
//
//    var attribute:NSLayoutAttribute {
//        switch self {
//        case .left:
//            return LayoutEdge.left.attribute
//        case .right:
//            return LayoutEdge.right.attribute
//        case .top:
//            return LayoutEdge.top.attribute
//        case .bottom:
//            return LayoutEdge.bottom.attribute
//        case .leading:
//            return LayoutEdge.leading.attribute
//        case .trailing:
//            return LayoutEdge.trailing.attribute
//        case .width:
//            return LayoutDimension.width.attribute
//        case .height:
//            return LayoutDimension.height.attribute
//        case .vertical:
//            return LayoutAxis.centerX.attribute
//        case .horizontal:
//            return LayoutAxis.centerY.attribute
//        case .baseline:
//            return LayoutAxis.baseline.attribute
//        case .lastbaseline:
//            return LayoutAxis.lastBaseline.attribute
//        case .firstBaseline:
//            return LayoutAxis.firstBaseline.attribute
//        case .marginLeft:
//            return LayoutMargin.left.attribute
//        case .marginRight:
//            return LayoutMargin.right.attribute
//        case .marginTop:
//            return LayoutMargin.top.attribute
//        case .marginBottom:
//            return LayoutMargin.bottom.attribute
//        case .marginLeading:
//            return LayoutMargin.leading.attribute
//        case .marginTrailing:
//            return LayoutMargin.trailing.attribute
//        case .marginAxisVertical:
//            return LayoutMarginAxis.vertical.attribute
//        case .marginAxisHorizontal:
//            return LayoutMarginAxis.horizontal.attribute
//        }
//    }
//}
//

extension UIView {
    
    /**
     Sets the view to a specific size.
     
     @param size The size to set this view's dimensions to.
     @return An array of constraints added.
     */
    @discardableResult func autoSetDimensions(toSize:CGSize,
                                    relation:NSLayoutRelation? = nil) -> [NSLayoutConstraint] {
        return [
            autoSet(dimension: .width, toSize: toSize.width),
            autoSet(dimension: .height, toSize: toSize.height),
        ]
    }
    
    /**
     Sets the given dimension of the view to a specific size.
     
     @param dimension The dimension of this view to set.
     @param size The size to set the given dimension to.
     @return The constraint added.
     */
    @discardableResult func autoSet(dimension:LayoutDimension,
                                    toSize size:CGFloat,
                                    relation:NSLayoutRelation? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: dimension.attribute,
                                            relatedBy: relation ?? .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: size)
        constraint.autoInstall()
        return constraint
    }
    
    /**
     Constrains an attribute of the view to a given attribute of another view.
     This method can be used to constrain different types of attributes across two views.
     
     @param attribute Any attribute of this view to constrain.
     @param toAttribute Any attribute of the other view to constrain to.
     @param otherView The other view to constrain to. Must be in the same view hierarchy as this view.
     @return The constraint added.
     */
    @discardableResult func autoConstrain(attribute:NSLayoutAttribute,
                                          toAttribute otherAttribute:NSLayoutAttribute,
                                          ofView view:UIView) -> NSLayoutConstraint {
        return autoConstrain(attribute: attribute, toAttribute: otherAttribute, ofView: view, withOffset: 0)
    }
    
    /**
     Constrains an attribute of the view to a given attribute of another view with an offset as a maximum or minimum.
     This method can be used to constrain different types of attributes across two views.
     
     @param attribute Any attribute of this view to constrain.
     @param toAttribute Any attribute of the other view to constrain to.
     @param otherView The other view to constrain to. Must be in the same view hierarchy as this view.
     @param offset The offset between the attribute of this view and the attribute of the other view.
     @param relation Whether the offset should be at least, at most, or exactly equal to the given value.
     @return The constraint added.
     */
    @discardableResult func autoConstrain(attribute:NSLayoutAttribute,
                                          toAttribute otherAttribute:NSLayoutAttribute,
                                          ofView view:UIView,
                                          withOffset offset:CGFloat = 0,
                                          relation:NSLayoutRelation? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: relation ?? .equal,
                                            toItem: view,
                                            attribute: otherAttribute,
                                            multiplier: 1,
                                            constant: offset)
        constraint.autoInstall()
        return constraint
    }
    
    /**
     Constrains an attribute of the view to a given attribute of another view with a multiplier as a maximum or minimum.
     This method can be used to constrain different types of attributes across two views.
     
     @param attribute Any attribute of this view to constrain.
     @param toAttribute Any attribute of the other view to constrain to.
     @param otherView The other view to constrain to. Must be in the same view hierarchy as this view.
     @param multiplier The multiplier between the attribute of this view and the attribute of the other view.
     @param relation Whether the multiplier should be at least, at most, or exactly equal to the given value.
     @return The constraint added.
     */
    @discardableResult func autoConstrain(attribute:NSLayoutAttribute,
                                          toAttribute otherAttribute:NSLayoutAttribute,
                                          ofView view:UIView,
                                          withMultiplier multiplier:CGFloat = 0,
                                          relation:NSLayoutRelation? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: relation ?? .equal,
                                            toItem: view,
                                            attribute: otherAttribute,
                                            multiplier: multiplier,
                                            constant: 0)
        constraint.autoInstall()
        return constraint
    }

    /**
     Aligns an axis of the view to the same axis of another view with a multiplier.
     
     @param axis The axis of this view and the other view to align.
     @param otherView The other view to align to. Must be in the same view hierarchy as this view.
     @param multiplier The multiplier between the axis of this view and the axis of the other view.
     @return The constraint added.
     */
    @discardableResult func autoAlignAxis(toSuperviewAxis axis:LayoutAxis) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { fatalError("View's superview must not be nil.\nView: \(self)") }
        return autoConstrain(attribute: axis.attribute, toAttribute: axis.attribute, ofView: superview)
    }
    
    /**
     Centers the view in its superview.
     
     @return An array of constraints added.
     */
    @discardableResult func autoCenter() -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        return [
            autoAlignAxis(toSuperviewAxis: .vertical),
            autoAlignAxis(toSuperviewAxis: .horizontal)
        ]
    }
    
    /**
     Pins the given edge of the view to the same edge of its superview with an inset as a maximum or minimum.
     
     @param edge The edge of this view and its superview to pin.
     @param inset The amount to inset this view's edge from the superview's edge.
     @param relation Whether the inset should be at least, at most, or exactly equal to the given value.
     @return The constraint added.
     */
    @discardableResult func autoPinEdge(toSuperviewEdge edge:LayoutEdge,
                                        withInset inset:CGFloat = 0,
                                        relation:NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { fatalError("View's superview must not be nil.\nView: \(self)") }
        var inset = inset
        var relation = relation
        if edge == .bottom || edge == .right || edge == .trailing {
            // The bottom, right, and trailing insets (and relations, if an inequality) are inverted to become offsets
            inset = -inset
            if relation == .lessThanOrEqual {
                relation = .greaterThanOrEqual
            }
            if relation == .greaterThanOrEqual {
                relation = .lessThanOrEqual
            }
        }
        return autoPin(edge: edge, toEdge: edge, ofView: superview, withOffset: inset, relation: relation)
    }
    
    /**
     Pins an edge of the view to a given edge of another view with an offset as a maximum or minimum.
     
     @param edge The edge of this view to pin.
     @param toEdge The edge of the other view to pin to.
     @param otherView The other view to pin to. Must be in the same view hierarchy as this view.
     @param offset The offset between the edge of this view and the edge of the other view.
     @param relation Whether the offset should be at least, at most, or exactly equal to the given value.
     @return The constraint added.
     */
    @discardableResult func autoPin(edge:LayoutEdge,
                                    toEdge:LayoutEdge,
                                    ofView otherView:UIView,
                                    withOffset offset:CGFloat = 0,
                                    relation:NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        return autoConstrain(attribute: edge.attribute,
                      toAttribute: toEdge.attribute,
                      ofView: otherView,
                      withOffset: offset,
                      relation: relation)
    }
    
    /**
     Pins 3 of the 4 edges of the view to the edges of its superview with the given edge insets, excluding one edge.
     The insets.left corresponds to a leading edge constraint, and insets.right corresponds to a trailing edge constraint.
     
     @param insets The insets for this view's edges from its superview's edges. The inset corresponding to the excluded edge
     will be ignored.
     @param edge The edge of this view to exclude in pinning to its superview; this method will not apply any constraint to it.
     @return An array of constraints added.
     */
    @discardableResult func autoPinEdgesToSuperviewEdges(withInsets insets:UIEdgeInsets = .zero,
                                                         excludingEdge edge:LayoutEdge? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        if edge != .top {
            constraints.append(autoPinEdge(toSuperviewEdge: .top, withInset: insets.top))
        }
        if edge != .leading && edge != .left {
            constraints.append(autoPinEdge(toSuperviewEdge: .leading, withInset: insets.left))
        }
        if edge != .bottom {
            constraints.append(autoPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom))
        }
        if edge != .trailing && edge != .right {
            constraints.append(autoPinEdge(toSuperviewEdge: .trailing, withInset: insets.right))
        }
        return constraints
    }

    
}

class ConstraintsManager {
    static let shared = ConstraintsManager()
    
    var identifierStack = [String]()
    var currentIdentifier:String? {
        return identifierStack.last
    }
    
    var priorityStack = [UILayoutPriority]()
    var currentPriority:UILayoutPriority? {
        return priorityStack.last
    }
    
//    var preventAutoInstall = false
    
}

extension NSLayoutConstraint {
    
    static func autoSet(priority:UILayoutPriority, forConstraints actions:(()->())) {
        ConstraintsManager.shared.priorityStack.append(priority)
        actions()
        ConstraintsManager.shared.priorityStack.removeLast()
    }
    
    static func applyGlobalStateToConstraint(constraint:NSLayoutConstraint) {
        let manager = ConstraintsManager.shared
        
        if let priority = manager.currentPriority {
            constraint.priority = priority
        }
        
        if let id = manager.currentIdentifier {
            constraint.identifier = id
        }
    }
    
//    static func autoCreateWithoutInstalling(createConstraints:(()->())) {
//    
//    }
    
    func autoInstall() {
        NSLayoutConstraint.applyGlobalStateToConstraint(constraint: self)
//        if !ConstraintsManager.shared.preventAutoInstall {
        isActive = true
//        }
//        else {
//            add to array of created constraints...
//        }
    }
   
 
}




















extension UIColor {
    
    func mixLighter (_ amount: CGFloat = 0.25) -> UIColor {
        return mixWithColor(UIColor.white, amount: amount)
    }
    
    func mixDarker (_ amount: CGFloat = 0.25) -> UIColor {
        return mixWithColor(UIColor.black, amount: amount)
    }
    
    func mixWithColor(_ color: UIColor, amount: CGFloat = 0.25) -> UIColor {
        var r1     : CGFloat = 0
        var g1     : CGFloat = 0
        var b1     : CGFloat = 0
        var alpha1 : CGFloat = 0
        var r2     : CGFloat = 0
        var g2     : CGFloat = 0
        var b2     : CGFloat = 0
        var alpha2 : CGFloat = 0
        
        self.getRed (&r1, green: &g1, blue: &b1, alpha: &alpha1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &alpha2)
        return UIColor( red:r1*(1.0-amount)+r2*amount,
                        green:g1*(1.0-amount)+g2*amount,
                        blue:b1*(1.0-amount)+b2*amount,
                        alpha: alpha1 )
    }
}

extension UIImage {
    static func fromColor(_ color: UIColor, size:CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension NSAttributedString {
    convenience init(string:String, font:UIFont, color:UIColor? = nil, attributes:[String:AnyObject]? = nil) {
        var attr = [String:AnyObject]()
        if let a = attributes {
            for (k,v) in a {
                attr[k] = v
            }
        }
        if let c = color {
            attr[NSForegroundColorAttributeName] = c
        }
        attr[NSFontAttributeName] = font
        
        self.init(string:string, attributes:attr)
    }
}

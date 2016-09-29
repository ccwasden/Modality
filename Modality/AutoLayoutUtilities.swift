//
//  AutoLayoutUtilities.swift
//  Modality
//
//  Created by Chase Wasden on 9/26/16.
//  
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

extension UIView {
    
    /**
     Sets the view to a specific size.
     
     @param size The size to set this view's dimensions to.
     @return An array of constraints added.
     */
    @discardableResult
    func alSetDimensions(toSize:CGSize,
                             relation:NSLayoutRelation? = nil) -> [NSLayoutConstraint] {
        return [
            alSetDimension(.width, toSize: toSize.width),
            alSetDimension(.height, toSize: toSize.height),
        ]
    }
    
    /**
     Sets the given dimension of the view to a specific size.
     
     @param dimension The dimension of this view to set.
     @param size The size to set the given dimension to.
     @return The constraint added.
     */
    @discardableResult
    func alSetDimension(_ dimension:LayoutDimension,
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
    @discardableResult
    func alConstrain(attribute:NSLayoutAttribute,
                       toAttribute otherAttribute:NSLayoutAttribute,
                       ofView view:UIView) -> NSLayoutConstraint {
        return alConstrain(attribute: attribute, toAttribute: otherAttribute, ofView: view, withOffset: 0)
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
    @discardableResult
    func alConstrain(attribute:NSLayoutAttribute,
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
    @discardableResult
    func alConstrain(attribute:NSLayoutAttribute,
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
    @discardableResult
    func alAlignAxis(toSuperviewAxis axis:LayoutAxis) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else { fatalError("View's superview must not be nil.\nView: \(self)") }
        return alConstrain(attribute: axis.attribute, toAttribute: axis.attribute, ofView: superview)
    }
    
    /**
     Centers the view in its superview.
     
     @return An array of constraints added.
     */
    @discardableResult
    func alCenterInSuperview() -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        return [
            alAlignAxis(toSuperviewAxis: .vertical),
            alAlignAxis(toSuperviewAxis: .horizontal)
        ]
    }
    
    /**
     Pins the given edge of the view to the same edge of its superview with an inset as a maximum or minimum.
     
     @param edge The edge of this view and its superview to pin.
     @param inset The amount to inset this view's edge from the superview's edge.
     @param relation Whether the inset should be at least, at most, or exactly equal to the given value.
     @return The constraint added.
     */
    @discardableResult
    func alPinEdge(toSuperviewEdge edge:LayoutEdge,
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
        return alPin(edge: edge, toEdge: edge, ofView: superview, withOffset: inset, relation: relation)
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
    @discardableResult
    func alPin(edge:LayoutEdge,
                   toEdge:LayoutEdge,
                   ofView otherView:UIView,
                   withOffset offset:CGFloat = 0,
                   relation:NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        return alConstrain(attribute: edge.attribute,
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
    @discardableResult func alPinEdgesToSuperviewEdges(withInsets insets:UIEdgeInsets = .zero,
                                                         excludingEdge edge:LayoutEdge? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        if edge != .top {
            constraints.append(alPinEdge(toSuperviewEdge: .top, withInset: insets.top))
        }
        if edge != .leading && edge != .left {
            constraints.append(alPinEdge(toSuperviewEdge: .leading, withInset: insets.left))
        }
        if edge != .bottom {
            constraints.append(alPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom))
        }
        if edge != .trailing && edge != .right {
            constraints.append(alPinEdge(toSuperviewEdge: .trailing, withInset: insets.right))
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
    
    static func alSetPriority(_ priority:UILayoutPriority, forConstraints actions:(()->())) {
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


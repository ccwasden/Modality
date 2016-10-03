//
//  ModalViewController.swift
//  Modality
//
//  Created by Chase Wasden on 9/27/16.
//  
//

import Foundation

protocol ModalViewControllerDelegate: class {
    var settings:ModalSettings { get }
    var contentView:UIView { get }
    var buttonRows:[[ModalButton]] { get }
    func dismiss()
}


public class ModalViewController:UIViewController {
    
    public let containerView:UIView = UIView()
    public let modalWrapper:UIView = UIView()
    public let modalView:UIView = UIView()
    
//    var afterViewLoad:(()->Void)?
    weak var delegate:ModalViewControllerDelegate?
    
    var settings:ModalSettings {
        return delegate?.settings ?? Modality.defaultSettings
    }
    
    var contentView:UIView {
        if let contentView = delegate?.contentView {
            return contentView
        }
        fatalError("No contentView provided for Modal")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addTapRecognizer()
        setupContainer()
        setupModalWrapper()
        setupContentView()
        setupButtons()
        
//        afterViewLoad?()
    }
    
    func setupContainer() {
        view.addSubview(containerView)
        containerView.isUserInteractionEnabled = false
        containerView.backgroundColor = settings.containerColor
        containerView.alPinEdgesToSuperviewEdges()
        
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupModalWrapper() {
        modalWrapper.backgroundColor = settings.modalColor
        
        if let shadow = settings.shadow {
            modalWrapper.layer.shadowColor = shadow.color.cgColor
            modalWrapper.layer.shadowOffset = shadow.offset
            modalWrapper.layer.shadowRadius = shadow.radius
            modalWrapper.layer.shadowOpacity = shadow.opacity
        }
        
        let cornerRadius = settings.cornerRadius
        if cornerRadius == 0 {
            modalView.clipsToBounds = false
        }
        else {
            modalView.clipsToBounds = true
            modalView.layer.cornerRadius = cornerRadius
            modalWrapper.layer.cornerRadius = cornerRadius
        }
        
        view.addSubview(modalWrapper)
    }
    
    func setupContentView() {
        modalWrapper.addSubview(modalView)
        modalView.alPinEdgesToSuperviewEdges()
        
        modalView.addSubview(contentView)
        contentView.alPinEdgesToSuperviewEdges(withInsets: .zero, excludingEdge: .bottom)
    }
    
    func setupButtons() {
        let buttonRows = delegate?.buttonRows ?? []
        if buttonRows.count > 0 {
            let rows:[UIStackView] = buttonRows.map { buttons in
                let views = buttons.map { $0.modalButtonView }
                let stack = UIStackView(arrangedSubviews: views)
                stack.axis = .horizontal
                stack.spacing = 15
                //                stack.alignment = .Center
                //                stack.distribution = .EqualSpacing
                return stack
            }
            let stackView = UIStackView(arrangedSubviews: rows)
            stackView.axis = .vertical
            stackView.spacing = 15
            stackView.alignment = .center
            modalView.addSubview(stackView)
            stackView.alPin(edge:.top, toEdge: .bottom, ofView: contentView)
            stackView.alPinEdgesToSuperviewEdges(withInsets: UIEdgeInsetsMake(20, 20, 30, 20), excludingEdge: .top)
        }
        else {
            contentView.alPinEdge(toSuperviewEdge: .bottom)
        }
    }
    
    func onContainerTapped() {
        delegate?.dismiss()
    }
    
    fileprivate func addTapRecognizer() {
        if settings.dismissOnBackgroundTap {
            let tapRec = UITapGestureRecognizer(target: self, action: #selector(onContainerTapped))
            let subView = UIView()
            view.insertSubview(subView, at: 0)
            subView.alPinEdgesToSuperviewEdges(withInsets: UIEdgeInsets.zero)
            subView.addGestureRecognizer(tapRec)
        }
    }
    
    
}



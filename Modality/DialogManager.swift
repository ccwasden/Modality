//
//  Modality.swift
//  Modality
//
//  Created by Chase Wasden on 9/26/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import UIKit


@objc protocol DialogPresenter {
    func presentDialog(_ dialog:Dialog, animated:Bool)
    func setInitialModalWrapperConstraints(_ dialog:Dialog)
    func dismissDialogAnimated(_ dialog:Dialog, completion:@escaping (Void)->Void )
}

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

//class DialogPresenterFullScreenModal : NSObject, DialogPresenter {
//    var beforePresent:(()->Void)?
//    var afterPresent:(()->Void)?
//    func setInitialModalWrapperConstraints(_ dialog:Dialog) {
//        dialog.modalWrapper.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
//        NSLayoutConstraint.autoSetPriority(999) { () -> Void in
//            dialog.preferredModalWidthConstraint = dialog.modalWrapper.autoSetDimension(.width, toSize: CGFloat(dialog.preferredModalWidth))
//        }
//        dialog.modalWrapper.autoCenterInSuperview()
//        dialog.view.superview?.setNeedsLayout()
//        dialog.view.superview?.layoutIfNeeded()
//    }
//    func presentDialog(_ dialog: Dialog, animated: Bool) {
//        beforePresent?()
//        dialog.view.superview?.layoutIfNeeded()
//        dialog.modalWrapper.transform = CGAffineTransform(translationX: 0, y: dialog.modalWrapper.frame.size.height)
//        UIView.animate(withDuration: 0.2, animations: { () -> Void in
//            dialog.modalWrapper.transform = CGAffineTransform.identity
//            self.afterPresent?()
//        })
//    }
//    func dismissDialogAnimated(_ dialog: Dialog, completion:@escaping (()->())) {
//        dialog.modalWrapper.transform = CGAffineTransform.identity
//        UIView.animate(withDuration: 0.2, animations: { () -> Void in
//            dialog.modalWrapper.transform = CGAffineTransform(translationX: 0, y: dialog.modalWrapper.frame.size.height)
//            }, completion: { (success) -> Void in
//                completion()
//        })
//    }
//}

class DialogPresenterCentered : NSObject, DialogPresenter {
    
    var beforePresent:(()->Void)?
    internal func setInitialModalWrapperConstraints(_ dialog:Dialog) {
        
        NSLayoutConstraint.autoSet(priority: 999) {
            dialog.preferredModalWidthConstraint = dialog.modalWrapper.autoSet(dimension: .width, toSize: dialog.preferredModalWidth)
        }
        NSLayoutConstraint.autoSet(priority: 998) {
            dialog.modalWrapper.autoCenterInSuperview()
        }
        dialog.modalWrapper.autoPinEdge(toSuperviewEdge: .top, withInset: 20, relation: NSLayoutRelation.greaterThanOrEqual)
        
        
        //        let constraint = NSLayoutConstraint(item: dialog.modalWrapper,
        //                                            attribute: .width,
        //                                            relatedBy: .equal,
        //                                            toItem: nil,
        //                                            attribute: .notAnAttribute,
        //                                            multiplier: 1,
        //                                            constant: CGFloat(dialog.preferredModalWidth))
        //        constraint.priority = 999
        //        dialog.modalWrapper.addConstraint(constraint)
        
        //        let constraintX = NSLayoutConstraint(item: dialog.modalWrapper,
        //                                             attribute: .centerX,
        //                                             relatedBy: .equal,
        //                                             toItem: dialog.modalWrapper.superview!,
        //                                             attribute: .centerX,
        //                                             multiplier: 1,
        //                                             constant: 0)
        //        constraintX.priority = 998
        //        dialog.modalWrapper.superview!.addConstraint(constraintX)
        //
        //        let constraintY = NSLayoutConstraint(item: dialog.modalWrapper,
        //                                             attribute: .centerY,
        //                                             relatedBy: .equal,
        //                                             toItem: dialog.modalWrapper.superview!,
        //                                             attribute: .centerY,
        //                                             multiplier: 1,
        //                                             constant: 0)
        //        constraintY.priority = 998
        //        dialog.modalWrapper.superview!.addConstraint(constraintY)
        //
        //        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=20)-[mw]",
        //                                                         options: [],
        //                                                         metrics: nil,
        //                                                         views: ["mw":dialog.modalWrapper])
        //        dialog.modalWrapper.superview!.addConstraints(constraints)

        
        
        beforePresent?()
    }
    
    internal func presentDialog(_ dialog: Dialog, animated: Bool) {
        presentView(dialog.modalWrapper, animated: animated)
    }
    
    internal func dismissDialogAnimated(_ dialog: Dialog, completion: @escaping (Void)->Void) {
        dismissView(dialog.modalWrapper, completion: completion)
    }
    
    func presentView(_ view:UIView, animated:Bool) {
        if animated {
            view.alpha = 0
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                view.alpha = 1
            })
            
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 18, options: [], animations: { () -> Void in
                view.transform.a = 1 // x
                }, completion: nil)
            UIView.animate(withDuration: 0.48, delay: 0.04, usingSpringWithDamping: 0.8, initialSpringVelocity: 18, options: [], animations: { () -> Void in
                view.transform.d = 1 // y
                }, completion: nil)
            
            UIView.animate(withDuration: 0.2, animations: {
                view.transform = CGAffineTransform.identity
                view.alpha = 1
            })
        }
        else {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
            view.alpha = 1
        }
    }
    
    func dismissView(_ view:UIView, completion:@escaping (()->())) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: { () -> Void in
            view.transform = CGAffineTransform(translationX: 0, y: -1000)
            view.alpha = 1
            }, completion: { _ in
                completion()
        })
    }
}

class DialogPresenterRightEdge : NSObject, DialogPresenter {
    internal func setInitialModalWrapperConstraints(_ dialog: Dialog) {
        dialog.modalWrapper.autoSet(dimension: .width, toSize: dialog.preferredModalWidth)
        dialog.modalWrapper.autoPinEdgesToSuperviewEdges(withInsets: .zero, excludingEdge: .left)
    }
    
    internal func presentDialog(_ dialog: Dialog, animated: Bool) {
        
        if animated {
            dialog.modalWrapper.transform = CGAffineTransform(translationX: CGFloat(dialog.preferredModalWidth), y: 0)
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                dialog.modalWrapper.transform = CGAffineTransform.identity
            })
        }
        else {
            dialog.modalWrapper.transform = CGAffineTransform.identity
        }
    }
    
    internal func dismissDialogAnimated(_ dialog: Dialog, completion: @escaping (Void)->Void) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            dialog.modalWrapper.transform = CGAffineTransform(translationX: CGFloat(dialog.preferredModalWidth), y: 0)
            }, completion: { (success) -> Void in
                completion()
        })
    }
}

class DialogPresenterLeftEdge : NSObject, DialogPresenter {
    func setInitialModalWrapperConstraints(_ dialog: Dialog) {
        dialog.modalWrapper.autoSet(dimension: .width, toSize: dialog.preferredModalWidth)
        dialog.modalWrapper.autoPinEdgesToSuperviewEdges(withInsets: .zero, excludingEdge: .right)
    }
    func presentDialog(_ dialog: Dialog, animated: Bool) {
        
        if animated {
            dialog.modalWrapper.transform = CGAffineTransform(translationX: -CGFloat(dialog.preferredModalWidth), y: 0)
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                dialog.modalWrapper.transform = CGAffineTransform.identity
            })
        }
        else {
            dialog.modalWrapper.transform = CGAffineTransform.identity
        }
    }
    
    func dismissDialogAnimated(_ dialog: Dialog, completion:@escaping (()->())) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            dialog.modalWrapper.transform = CGAffineTransform(translationX: -CGFloat(dialog.preferredModalWidth), y: 0)
            }, completion: { (success) -> Void in
                completion()
        })
    }
}

public class Dialog: UIViewController {
    
    let modalWrapper = UIView()
    let modalView = UIView()
    var contentView:UIView!
    
    //    var whiteCover:UIView!
    //    var effectView:UIView?
    var grayView:UIView!
    
    var presenter:DialogPresenter = DialogPresenterCentered()
    
    var preferredModalWidth:CGFloat = 0
    var preferredModalWidthConstraint:NSLayoutConstraint?
    var roundedCornersWithShadow = false
    
    //    var hideStatusBar = false
    //    var statusBarWasHidden = false
    
    var dismissOnBackgroundTap = false
    var autoDismiss = true
    fileprivate var dismissed = false
    var autoUppercase = true
    var topEdgeContentInset:CGFloat = 0
    
    var buttonRows:[[UIView]] = [[UIView]]()
    
    var onShow:(()->Void)?
    var onDismiss:(()->Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonString(_ str:String) -> String {
        return autoUppercase ? str.uppercased() : str
    }
    
    func buttonCallback(_ callback:(()->Void)?) -> ()->Void {
        return { [weak self] in
            if let self_ = self , self_.autoDismiss {
                self_.dismiss()
            }
            if let cb = callback {
                cb()
            }
        }
    }
    
    let buttonHeight = CGFloat(46)
    
    func addKeyButton(_ title:String,callback:(()->Void)?) {
        let btn = MainButtonGray()
        btn.setTitle(title, for: UIControlState())
        btn.autoSet(dimension:.height, toSize: buttonHeight)
        btn.block_setAction(buttonCallback(callback))
        btn.setBackgroundImage(nil, for: UIControlState())
        addButton(btn)
    }
    
    func addButton(_ title:String,callback:(()->Void)?) {
        let btn = MainButtonGray()
        btn.setTitle(title, for: UIControlState())
        btn.autoSet(dimension:.height, toSize: buttonHeight)
        btn.block_setAction(buttonCallback(callback))
        addButton(btn)
    }
    
    func addButtonRow(_ row:[ButtonType]) {
        let buttons:[UIView] = row.map {
            let (view, btn) = $0.button
            btn.block_setAction(buttonCallback($0.callback))
            //            btn.autoSetDimension(.Height, toSize: buttonHeight)
            return view
        }
        buttonRows.append(buttons)
    }
    
    override public var prefersStatusBarHidden : Bool {
        return Modality.shared.dialogsPreferStatusHidden
    }
    
    func addButton(_ button:UIButton){
        buttonRows.append([button])
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        grayView = UIView()
        grayView.isUserInteractionEnabled = false
        self.view.addSubview(grayView)
        grayView.autoPinEdgesToSuperviewEdges()
        view.backgroundColor = UIColor.clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        grayView.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        
        modalWrapper.backgroundColor = UIColor(white: 1, alpha: 1)
        
        view.addSubview(modalWrapper)
        
        
        //        modalWrapper.autoSetDimension(.Height, toSize: 350)
        presenter.setInitialModalWrapperConstraints(self)
        
        modalWrapper.addSubview(modalView)
        modalView.autoPinEdgesToSuperviewEdges()
        
        //        whiteCover = UIView.newAutoLayoutView()
        //        whiteCover.backgroundColor = UIColor(white: 1, alpha: 0.9)
        //        modalWrapper.addSubview(whiteCover)
        //        whiteCover.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
        
        //        let activity = LoadingView()
        //        whiteCover.addSubview(activity)
        //        activity.autoCenterInSuperview()
        //        whiteCover.alpha = 0
        
        
        if contentView == nil {
            contentView = buildContentView()
            contentView.isUserInteractionEnabled = true
        }
        modalView.addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges(withInsets: UIEdgeInsetsMake(topEdgeContentInset, 0, 0, 0), excludingEdge: .bottom)
        if buttonRows.count > 0 {
            let rows:[UIStackView] = buttonRows.map {
                let stack = UIStackView(arrangedSubviews: $0)
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
            stackView.autoPin(edge:.top, toEdge: .bottom, ofView: contentView)
            stackView.autoPinEdgesToSuperviewEdges(withInsets: UIEdgeInsetsMake(20, 20, 30, 20), excludingEdge: .top)
        }
        else {
            contentView.autoPinEdge(toSuperviewEdge: .bottom)
        }
        
        if roundedCornersWithShadow {
            modalView.backgroundColor = UIColor.white
            modalWrapper.backgroundColor = UIColor.clear
            modalWrapper.layer.cornerRadius = 10
            modalView.layer.cornerRadius = 10
            modalView.clipsToBounds = true
            //            applyShadow(modalWrapper)
        }
        
    }
    
    fileprivate func addRecognizer() {
        if dismissOnBackgroundTap {
            let tapRec = UITapGestureRecognizer(target: self, action: #selector(Dialog.onBackgroundTap))
            let subView = UIView()
            view.insertSubview(subView, at: 0)
            subView.autoPinEdgesToSuperviewEdges(withInsets: UIEdgeInsets.zero)
            subView.addGestureRecognizer(tapRec)
        }
    }
    
    func onBackgroundTap() {
        self.dismiss()
    }
    
    var bottomConstraint:NSLayoutConstraint?
    
    internal func showInWindow(_ window:UIWindow, animated:Bool = true){
        //        let rootVC:UIViewController = UIApplication.sharedApplication().keyWindow?.subviews[0].nextResponder() as UIViewController
        if let show = onShow {
            show()
        }
        
        if preferredModalWidth == 0{
            preferredModalWidth = 300
        }
        let maxWidth = CGFloat((Int(window.frame.size.width-20)/10) * 10);
        preferredModalWidth = min(preferredModalWidth, maxWidth)
        if let c = self.preferredModalWidthConstraint {
            c.constant = preferredModalWidth
        }
        
        
        
        
        //        if controller is UINavigationController {
        //            //            let navc = controller as UINavigationController
        //            //            if let visible = navc.visibleViewController {
        //            //                visible.addChildViewController(self)
        //            //            }
        //        }
        //        else {
        //            controller.addChildViewController(self)
        //        }
        
        //        let superview = window
        
        //        if let navC = controller.navigationController
        
        window.addSubview(view)
        if window.rootViewController == nil {
            window.rootViewController = self
        }
        
        //        NSLayoutConstraint.autoSetPriority(999) {
        self.bottomConstraint = self.view.autoPinEdgesToSuperviewEdges(withInsets: UIEdgeInsets.zero)[2]
        //        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //        if hideStatusBar {
        //            statusBarWasHidden = UIApplication.sharedApplication().statusBarHidden
        //            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: animated ? .Slide : .None)
        ////            UIApplication.sharedApplication().setStatusHidden(true)
        //        }
        
        
        if animated {
            grayView.alpha = 0
            
            UIView.animate(withDuration: 0.25, animations:
                { () -> Void in
                    self.grayView.alpha = 1
                }, completion: { _ in
                    self.addRecognizer()
            })
        }
        else {
            grayView.alpha = 1
            modalWrapper.alpha = 1
        }
        
        presenter.presentDialog(self, animated: animated)
        
    }
    
    func keyboardShown(_ notification:Notification) {
        if let userInfo = (notification as NSNotification).userInfo, let size = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint?.constant = -size.height
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.layoutSubviews()
            })
        }
    }
    
    func keyboardHidden(_ notification:Notification) {
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutSubviews()
        })
    }
    
    func dismiss(_ completion:(()->())? = nil) {
        Modality.shared.dismissDialog(self, completion: completion)
    }
    
    func show() {
        show(true)
    }
    
    func show(_ animated:Bool) {
        Modality.shared.showDialog(self, animated:animated)
    }
    
    func dismissAnimated(_ animated:Bool, completion:@escaping (Void)->Void) {
        if dismissed { return }
        
        dismissed = true
        
        if let dismiss = onDismiss {
            dismiss()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations:
                { () -> Void in
                    self.view.alpha = 0
            }) { _ in
                self.remove()
            }
            
            //                self.bk_performBlock(
            //                    { (bself) -> Void in
            //                        self.view.userInteractionEnabled = false
            //                        let aAnim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            //                        aAnim.toValue = 0
            //                        aAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            //                        aAnim.duration = 0.3
            //                        aAnim.completionBlock = { (anim, success) in
            //                            self.remove()
            //                        }
            //                        self.view.pop_addAnimation(aAnim, forKey: "aAnim")
            //                    }, afterDelay: 0.2)
            self.presenter.dismissDialogAnimated(self, completion: completion)
        }
        else {
            self.remove()
        }
        
    }
    
    fileprivate func remove() {
        self.view.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    func buildContentView() -> UIView {
        let view = UIView()
        return view;
    }
    
}


class DialogMessage: Dialog {
    
    var titleView:UIView?
    
    var attributedMessage:NSAttributedString = NSAttributedString(string: "No Message", font: FontsManager.shared.primaryFont(.Bold, size:14), color: DefaultsStyleKit.textColor)
    func setMessageText(_ text:String, color:UIColor? = nil, font:UIFont? = nil){
        let paraStyle = defaultParaStyle()
        paraStyle.alignment = .center
        let attr = [NSParagraphStyleAttributeName:paraStyle]
        let messageFont = font ?? FontsManager.shared.primaryFont(.Regular, size:13)
        let messageColor = color ?? DefaultsStyleKit.lightTextColor
        attributedMessage = NSAttributedString(string:text, font: messageFont, color: messageColor, attributes:attr)
    }
    
    override func buildContentView() -> UIView {
        roundedCornersWithShadow = true
        let contentView = UIView()
        let lrPadding:CGFloat = 20
        let tbPadding:CGFloat = 40
        
        let messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.attributedText = attributedMessage
        contentView.addSubview(messageLabel)
        messageLabel.autoPinEdgesToSuperviewEdges(withInsets: UIEdgeInsetsMake(0, lrPadding, tbPadding-5, lrPadding), excludingEdge: .top)
        
        if let titleView = titleView {
            contentView.addSubview(titleView)
            if let _ = titleView as? UIImageView {
                titleView.autoPinEdge(toSuperviewEdge: .top, withInset:tbPadding)
                titleView.autoSetDimensions(toSize: CGSize(width: 50, height: 50))
                titleView.autoAlignAxis(toSuperviewAxis: .vertical)
            }
            else {
                titleView.autoPinEdgesToSuperviewEdges(withInsets: UIEdgeInsetsMake(tbPadding, lrPadding, 0, lrPadding), excludingEdge: .bottom)
            }
            messageLabel.autoPin(edge: .top, toEdge: .bottom, ofView: titleView, withOffset: 10)
        }
        else {
            messageLabel.autoPinEdge(toSuperviewEdge: .top, withInset: tbPadding)
        }
        
        modalView.backgroundColor = UIColor.white
        return contentView;
    }
}

var messageLineSpacing = 5.0
func defaultParaStyle() -> NSMutableParagraphStyle {
    let paraStyle = NSMutableParagraphStyle()
    paraStyle.lineSpacing = CGFloat(messageLineSpacing)
    return paraStyle
}


class DialogIconTitle: DialogMessage {
    var titleIcon = DefaultsStyleKit.imageOfAlertIcon
    override func buildContentView() -> UIView {
        roundedCornersWithShadow = true
        let titleView = UIImageView()
        titleView.image = titleIcon
        self.titleView = titleView
        return super.buildContentView()
    }
}

class DialogSuccess: DialogIconTitle {
    override func buildContentView() -> UIView {
        titleIcon = DefaultsStyleKit.imageOfSuccessIcon
        return super.buildContentView()
    }
}

class DialogAlert: DialogIconTitle {
    override func buildContentView() -> UIView {
        titleIcon = DefaultsStyleKit.imageOfAlertIcon
        return super.buildContentView()
    }
}

class DialogTitled: DialogMessage {
    func setAttributedTitleText(_ text:NSAttributedString) {
        let titleLabel = UILabel()
        titleLabel.attributedText = text
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleView = titleLabel
    }
    
    func setTitleText(_ text:String) {
        setAttributedTitleText(NSAttributedString(string:text, font: FontsManager.shared.primaryFont(.Regular, size:15), color: DefaultsStyleKit.textColor))
    }
}

class DialogWithViewController: Dialog {
    var subViewController:UIViewController!
    var preferredContentHeight:Float = 0
    override func buildContentView() -> UIView {
        var isAdding: Bool = false
        if subViewController.parent != self {
            self.addChildViewController(subViewController)
            isAdding = true
        }
        if preferredContentHeight > 0 {
            subViewController.view.autoSet(dimension:.height, toSize: CGFloat(preferredContentHeight))
        }
        if isAdding {
            subViewController.didMove(toParentViewController: self)
        }
        return subViewController.view
    }
}

class DialogWithView: Dialog {
    var subView:UIView!
    var preferredContentHeight:Float = 0
    override func buildContentView() -> UIView {
        if preferredContentHeight > 0 {
            subView.autoSet(dimension:.height, toSize: CGFloat(preferredContentHeight))
        }
        return subView
    }
}

class DialogWeb: Dialog, UIWebViewDelegate {
    var html:String?
    var url:String?
    var webView = UIWebView()
    var openLinksInSafari = true
    var webViewHeight:CGFloat = 150.0
    var webViewScroll = false
    override func buildContentView() -> UIView {
        webView.delegate = self
        webView.autoSet(dimension:.height, toSize: webViewHeight)
        if let h = html {
            webView.loadHTMLString(h, baseURL: nil)
        }
        else if let u = url {
            if let urlObj = URL(string: u) {
                webView.loadRequest(URLRequest(url: urlObj))
            }
        }
        return webView
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .linkClicked && openLinksInSafari {
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.scrollView.isScrollEnabled = webViewScroll
        webView.scrollView.bounces = webViewScroll
    }
}

class DialogNavigation: Dialog {
    var navController:UINavigationController?
    var preferredContentHeight:Float = 0
    var contentController:UIViewController?
    override func buildContentView() -> UIView {
        if let controller = contentController {
            //            self.view.addSubview(controller.view)
            //            self.addChildViewController(controller)
            //            controller.view.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero)
            navController = UINavigationController(rootViewController: controller)
            if preferredContentHeight > 0 {
                NSLayoutConstraint.autoSet(priority:999) {
                    self.navController!.view.autoSet(dimension:.height, toSize: CGFloat(self.preferredContentHeight))
                }
            }
            navController!.view.layer.masksToBounds = true
            return navController!.view
        }
        return super.buildContentView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

public class Modality: NSObject {
    
    var mainWindow:UIWindow?
    var window = UIWindow()
    var stack = [Dialog]()
    
    var dialogsPreferStatusHidden = false
    
    static let shared = Modality()
    
    //    override init() {
    //        super.init()
    //    }
    
    func showDialog(_ dialog:Dialog){
        showDialog(dialog, animated: true)
    }
    
    func showDialog(_ dialog:Dialog, animated:Bool){
        if !window.isKeyWindow {
            window.frame = (UIApplication.shared.keyWindow?.frame)!
            mainWindow = UIApplication.shared.keyWindow
            mainWindow?.endEditing(true)
            window.windowLevel = UIWindowLevelStatusBar + 1
            window.backgroundColor = UIColor.clear
            window.makeKeyAndVisible()
        }
        
        dialog.showInWindow(window)
        //            dialog.showInViewController(vc, animated:animated)
        stack.append(dialog)
    }
    
    func dismissAllDialogs() {
        while stack.count > 0 {
            dismissTopDialog()
        }
    }
    
    func hideDialogWindow() {
        if let mainWindow = mainWindow , stack.count == 0 {
            window.removeFromSuperview()
            window.windowLevel = mainWindow.windowLevel - 1
            window.rootViewController = nil
            
            //            mainWindow.windowLevel = 1
            mainWindow.makeKeyAndVisible()
            //            window.removeFromSuperview()
        }
    }
    
    public func dismissTopDialog(_ completion:(()->Void)? = nil) {
        if !stack.isEmpty {
            stack.removeLast().dismissAnimated(true) {
                self.hideDialogWindow()
                completion?()
            }
        }
    }
    
    func dismissDialog(_ dialog:Dialog, completion:(()->())? = nil){
        if let index = stack.index(of: dialog) {
            let dialog = stack.remove(at: index)
            dialog.dismissAnimated(true) {
                self.hideDialogWindow()
                if self.window.rootViewController == dialog {
                    self.window.rootViewController = nil
                }
                completion?()
            }
        }
    }
    
    func dialogIsVisible(_ dialog:Dialog) -> Bool{
        return stack.index(of: dialog) != nil
    }
    
    func rootVC() -> UIViewController? {
        if let vc = UIApplication.shared.keyWindow?.visibleViewController {
            return vc
        }
        return nil
        //        let vc = APPDELEGATE().rootViewController()
        //        let vc = APPDELEGATE().visibleViewController()
        //        let vc = UIApplication.sharedApplication().window
    }
    
    public class func showAlertDialog(_ message:String, buttons:[String], handler:((Dialog, Int)->Void)? = nil) {
        let dialog = DialogAlert()
        dialog.setMessageText(message)
        addButtonsToDialog(dialog, buttons: buttons, handler: handler)
        Modality.shared.showDialog(dialog)
    }
    
    class func addButtonsToDialog(_ dialog:Dialog, buttons:[String],handler:((Dialog, Int)->Void)?){
        for i in 0..<buttons.count {
            let str = buttons[i]
            let cb = handler == nil ? nil : { handler!(dialog, i) } as (()->Void)?
            if i == buttons.count-1 {
                dialog.addKeyButton(str, callback: cb)
            }
            else {
                dialog.addButton(str, callback: cb)
            }
        }
    }
    
    public class func showTitleDialog(_ title:String, message:String, buttons:[ButtonType]) {
        let dialog = DialogTitled()
        dialog.setMessageText(message)
        dialog.setTitleText(title)
        dialog.addButtonRow(buttons)
        Modality.shared.showDialog(dialog)
    }
    
    public class func showSuccessDialog(_ message:String, buttons:[String], handler:((Dialog, Int)->Void)? = nil) {
        let dialog = DialogSuccess()
        dialog.setMessageText(message)
        addButtonsToDialog(dialog, buttons: buttons, handler: handler)
        Modality.shared.showDialog(dialog)
    }
    
}

//
//  ViewController.swift
//  ModalityTestApp
//
//  Created by Chase Wasden on 9/26/16.
//  
//

import UIKit
import Modality

class ViewController: UIViewController {

    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var titleMessageButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var successButton: UIButton!
    
    @IBOutlet weak var presenterSegments: UISegmentedControl!
    @IBOutlet weak var styleSegments: UISegmentedControl!
    @IBOutlet weak var buttonsSegments: UISegmentedControl!
    @IBOutlet weak var showCustomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        messageButton.addTarget(self, action: #selector(messagePressed), for: .touchUpInside)
        titleMessageButton.addTarget(self, action: #selector(titleMessagePressed), for: .touchUpInside)
        alertButton.addTarget(self, action: #selector(alertPressed), for: .touchUpInside)
        successButton.addTarget(self, action: #selector(successPressed), for: .touchUpInside)
        showCustomButton.addTarget(self, action: #selector(customPressed), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func messagePressed() {
        Modality.showMessage(title:nil, message:"A little message in a modal.", buttons:["Got it"])
    }
    
    func titleMessagePressed() {
        Modality.showMessage(title:"Read This Title", message:"here is an important message", buttons:["OK"])
    }
    
    func alertPressed() {
        Modality.showAlert("This is an alert", buttons: ["Alright"])
    }
    
    func successPressed() {
        Modality.showSuccess("This is a success modal", buttons: ["Gotcha"])
    }
    
    func customPressed() {
        let vc = CustomModalViewController(nibName: "CustomModalViewController", bundle: nil)
        let modal = ModalWithViewController(viewController: vc, settings: selectedSettings(), presenter: selectedPresenter())
        vc.onClosePressed = { [weak modal] in // weak so to not create a reference cycle
            modal?.dismiss()
        }
        addSelectedButtons(to: modal)
        modal.show()
    }
    
    func selectedPresenter() -> ModalPresenter {
        switch presenterSegments.selectedSegmentIndex {
        case 0:
            return ModalPresenterCentered()
        case 1:
            return ModalPresenterLeftEdge()
        default:
            return ModalPresenterRightEdge()
        }
    }
    
    func selectedSettings() -> ModalSettingsMap {
        switch styleSegments.selectedSegmentIndex {
        case 0:
            return [
                .containerColor(UIColor(white: 0.5, alpha: 0.9)),
                .cornerRadius(0)
            ]
        case 1:
            return [
                .containerColor(UIColor(white: 0.5, alpha: 0.4)),
                .cornerRadius(15),
                .shadow(ModalShadowSettings(opacity: 0.4, radius: 0, offset: CGSize(width:8, height:8), color: .black)),
                .dismissOnBackgroundTap(false),
                .preferredModalSize(CGSize(width: 150, height: 500))
            ]
        default:
            return [
                .modalColor(.black),
                .shadow(nil),
                .containerColor(UIColor(white: 0, alpha: 0.5)),
                .cornerRadius(3)
            ]
        }
    }
    
    func addSelectedButtons(to modal:Modal) {
        switch buttonsSegments.selectedSegmentIndex {
        case 0: break
        case 1: modal.setButtonRows([["Yes", "No"], ["Maybe So"]])
        case 2: modal.addButtonRow(["Hmm"])
        default:break
        }
    }
    
//    func modalCustomAlert() {
//        let settings:ModalSettingsMap = [
//            .containerColor: UIColor(white: 0.5, alpha: 0.9),
//            .cornerRadius: CGFloat(0)
//        ]
//        let modal = ModalAlert(message:"Another alert being displayed here", settings:settings)
//        
//        modal.addButton("Go Away")
//        modal.show()
//    }
    
}


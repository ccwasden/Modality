//
//  ViewController.swift
//  ModalityTestApp
//
//  Created by Chase Wasden on 9/26/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import UIKit
import Modality

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func centerPressed(_ sender: AnyObject) {
        if let customView = Bundle.main.loadNibNamed("TestModalView", owner: nil, options: nil)?[0] as? UIView {
            let settings:ModalSettingsMap = [
                ModalSetting.containerColor: UIColor(white: 0.5, alpha: 0.9)
            ]
            let modal = Modal(contentView: customView, settings: settings, presenter: ModalPresenterRightEdge())
            modal.show()
        }
        
//        let settings:ModalSettingsMap = [
//            ModalSetting.containerColor: UIColor(white: 0.5, alpha: 0.9)
//        ]
//        let modal = ModalAlert(message:"Hey", settings:settings)
//        
//        modal.addButton("Go Away")
//        modal.show()
        
//        Modality.showAlert("Uh Oh", buttons: ["OK"])
    }

}


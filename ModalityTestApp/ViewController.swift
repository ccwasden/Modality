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
        Modality.showAlertDialog("Uh Oh, issue", buttons: ["OK"])
    }

}


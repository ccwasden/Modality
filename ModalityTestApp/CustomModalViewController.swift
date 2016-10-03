//
//  CustomModalViewController.swift
//  Modality
//
//  Created by Chase Wasden on 10/3/16.
//  Copyright © 2016 Wasdesign. All rights reserved.
//

import UIKit

class CustomModalViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    var onClosePressed:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    func closePressed() {
        onClosePressed?()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

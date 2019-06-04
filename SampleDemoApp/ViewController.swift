//
//  ViewController.swift
//  SampleDemoApp
//
//  Created by Nitesh Meshram on 02/06/19.
//  Copyright © 2019 Nitesh Meshram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        DataManager.sharedInstance().factsAPI()
        
        DataManager.sharedInstance().readLocalJson()
        
        
        
        
        // Do any additional setup after loading the view.
    }


}


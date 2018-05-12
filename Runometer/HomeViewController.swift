//
//  HomeViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-05-12.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Runometer"
        startButton.backgroundColor = Colors.green
    }
    
}

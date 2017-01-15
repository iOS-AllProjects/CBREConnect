//
//  ViewController.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/16/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cbreLabel: UILabel!
    @IBOutlet weak var connectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //dissapear the labels from view
        cbreLabel.center.x -= view.bounds.width
        connectLabel.center.x += view.bounds.width
        
        //animate views
        cbreLabel.animateLabel(x: view.frame.size.width/2, y: view.frame.size.height/3)
        connectLabel.animateLabel(x: cbreLabel.center.x + 60, y: cbreLabel.center.y + 26)
    }

}


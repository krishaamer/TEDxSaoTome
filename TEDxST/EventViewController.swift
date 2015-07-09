//
//  EventViewController.swift
//  TEDxST
//
//  Created by Kris Haamer on 08.07.15.
//  Copyright © 2015 Kris Haamer. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        
        self.scrollView.contentSize.height=1000
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
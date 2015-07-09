//
//  TeamDetailViewController.swift
//  TEDxST
//
//  Created by Kris Haamer on 08.07.15.
//  Copyright © 2015 Kris Haamer. All rights reserved.
//

import UIKit
import Bolts
import Parse
import ParseUI

class TeamDetailViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var bio: UILabel!
    
    var currentObject: PFObject!
    
    override func viewDidLoad() {
        
        if let obj = currentObject {
            
            if let name:String = obj["name"] as? String {
                self.name.text = name
            }
            
            if let bio:String = obj["desc"] as? String {
                self.bio.text = bio
            }
            
            if let role:String = obj["role"] as? String {
                self.role.text = role
            }
        }

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        super.viewDidLoad()
    }
    
    func handlePan(sender: UIPanGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.Ended){
            self.dismissViewControllerAnimated(true , completion: nil);
        }
    }

    override func viewWillAppear(animated: Bool) {
        // Do Something
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


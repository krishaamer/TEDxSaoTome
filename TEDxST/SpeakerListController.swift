//
//  SpeakerListController.swift
//  Y
//
//  Created by Kris Haamer on 04.06.15.
//  Copyright (c) 2015 HAAM. All rights reserved.
//

import UIKit
import Bolts
import Parse
import ParseUI

class SpeakerListController: PFQueryTableViewController, UIViewControllerTransitioningDelegate {
    
    let cellIdentifier:String = "SpeakerCell"
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 30
        self.parseClassName = "Speakers"
    }
    
    override func viewDidLoad() {
        
        tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.rowHeight = 130
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
        self.tableView.backgroundView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        super.viewDidLoad()
    }
    
    override func queryForTable() -> PFQuery {
        let query:PFQuery = PFQuery(className: self.parseClassName!)
        if (objects!.count == 0){
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        query.whereKey("published", equalTo:true)
        query.orderByAscending("priority")
        return query
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> SpeakerCell {
        
        var cell:SpeakerCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? SpeakerCell
        
        if(cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed("SpeakerCell", owner: self, options: nil)[0] as? SpeakerCell
        }
        
        cell?.parseObject = object
        if let pfObject = object {
            
            let img:PFImageView = (cell?.speakerImageSmall)!
            
            img.layer.cornerRadius = img.frame.size.width / 2
            img.layer.frame = CGRectInset(img.layer.frame, 20, 20)
            img.layer.borderColor = UIColor(hex: 0xefefef).CGColor
            img.layer.borderWidth = 2.0
            img.clipsToBounds = true
            
            

            if let f = pfObject["img"] as? PFFile {
                
                img.file = f
                f.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                        if let imageData = imageData {
                            img.image = UIImage(data:imageData)
                        }
                    }
                }
            } else {

                print("no file")
            }
            
            if let name:String = pfObject["name"] as? String {
                 cell?.speakerName?.text = name
            }

            if let title:String = pfObject["talk_title"] as? String {
                 cell?.talkTitle?.text = title
            }
            
            if let time:String = pfObject["start_time_str"] as? String {
                cell?.talkStartTime?.text = time
            }
        
            if(indexPath.row % 2 == 0) {
                cell?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            } else {
            
                cell?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
                cell?.speakerName.textColor = UIColor.whiteColor()
                cell?.talkTitle.textColor = UIColor.whiteColor()
            }

        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.performSegueWithIdentifier("speakers", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "speakers") {

            if let controller = segue.destinationViewController as? SpeakerDetailViewController {
                
                let indexPath = tableView.indexPathForSelectedRow();
                let selectedCell = tableView.cellForRowAtIndexPath(indexPath!) as! SpeakerCell!
                
                controller.transitioningDelegate = self
                controller.currentObject = selectedCell.parseObject
            }
        }
    }
}

//
//  subscriberlist.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 2/1/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit

class subscriberlist: UITableViewController {

    var folusernames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var followque = PFQuery(className: "subs")
        followque.whereKey("follower", equalTo: PFUser.currentUser().username)
        followque.orderByAscending("createdAt")
        followque.findObjectsInBackgroundWithBlock{
            
            (objects:[AnyObject]!, folError:NSError!) -> Void in
            
            
            if folError == nil {
                
                
                for object in objects{
                    
                    self.folusernames.append(object["following"] as String)
                    //change "following" to "subscribers" and "follower" to "Subscribed to"
                    
                    self.tableView.reloadData()
                    
                    
                }
                
            }
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      
         return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return folusernames.count

    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FollowCell = self.tableView.dequeueReusableCellWithIdentifier("cell3") as FollowCell
        
        cell.username.text = folusernames[indexPath.row]
        
        return cell
        
    }

 

}
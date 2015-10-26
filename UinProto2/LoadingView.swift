//
//  LoadingView.swift
//  Uin
//
//  Created by Kareem Dasilva on 3/16/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
import Parse

class LoadingView: UIViewController {

    
 
    override func viewDidLoad() {
        super.viewDidLoad()
      //PFUser.logOut()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
      
        
    
        if PFUser.currentUser() == nil {
            let storyboard = UIStoryboard(name: "EventFlowSB", bundle: nil)
            let poop:UIViewController = storyboard.instantiateInitialViewController()!
            
            self.presentViewController(poop, animated: true, completion: nil)
        } else {
            self.performSegueWithIdentifier("login", sender: self)
        }
        
       

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

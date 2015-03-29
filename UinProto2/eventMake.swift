//
//  eventMake.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/9/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit
import MapKit

class eventMake: UIViewController, UITextFieldDelegate {
    var dateTime = String()
    var dateStr = String()
    var orderDate = NSDate()
    var endDate = NSDate()
    var startTime = String()
    var endTime = String()
    var eventTitlePass = (String)()
    var eventLocation = ""
    var eventID = (String)()
    var userId = (String)()
    var eventDisplay = (String)()
    var lat = (CLLocationDegrees)()
    var long = (CLLocationDegrees)()
    var locations = CLLocation()
    var address = ""
    
    @IBOutlet var eventAddress: UIButton!
    
    @IBOutlet var eventLocationDescription: UIButton!

   
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    

    
    @IBOutlet var oncampusSegement: UISegmentedControl!
    @IBOutlet var freeSegment: UISegmentedControl!
    @IBOutlet var foodSegement: UISegmentedControl!
    @IBOutlet var publicSegment: UISegmentedControl!
    @IBOutlet weak var eventTitle: UITextField!
    
    @IBAction func startAction(sender: AnyObject) {
        self.performSegueWithIdentifier("sendtodate", sender: self)
    }
    
    @IBAction func endAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("sendtodate", sender: self)
    }
    @IBOutlet var start: UIButton!
    @IBOutlet var onCampus: UISegmentedControl!
    @IBOutlet var end: UIButton!
    var eventPublic:Bool = true
    var onsite:Bool = true
    var food:Bool = true
    var paid:Bool = true
    
    @IBAction func createLocation(sender: AnyObject) {
       textFieldShouldReturn(eventTitle)
        self.performSegueWithIdentifier("toLocation", sender: self)
   
    }
    
 
    @IBAction func publicEvent(sender: UISegmentedControl) {
        
        println(eventPublic)
        switch sender.selectedSegmentIndex {
        case 0:
            eventPublic = true
        case 1:
            eventPublic = false
            
        default:
            eventPublic = true
            break;
        }  //Switch
    }
    
    @IBAction func location(sender: UISegmentedControl) {
        println(onsite)
        switch sender.selectedSegmentIndex {
        case 0:
            onsite = true
        case 1:
            onsite = false
            
        default:
            onsite = true
            break;
        }  //Switch
        
    }
    
    @IBAction func isFood(sender: UISegmentedControl) {
        println(food)
        switch sender.selectedSegmentIndex {
        case 0:
            food = true
        case 1:
            food = false
            
        default:
            food = true
            break;
        }  //Switch
    }
    
    @IBAction func isPaid(sender: UISegmentedControl) {
        println(paid)
        switch sender.selectedSegmentIndex {
        case 0:
            paid = true
        case 1:
            paid = false
            
        default:
            paid = true
            break;
        }  //Switch
        
    }
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.Default
        }
        
    }
    // Creates the event and adds to the calendar
    
    @IBAction func makeEvent(sender: AnyObject) {
        
       var geopoint = PFGeoPoint(location: locations)
        var userFollowers = [String]()
        var allError = ""
        
        if eventTitle.text == "" {
            
            allError = "Enter a Title for your Event"
            println(allError)
            
        }
        if orderDate2.earlierDate(orderDate1) == true {
            allError = "Your enddate is before your start date"
        }
        
        if eventLocation == ""{
            
            allError = "Enter a location for your Event"
            println(allError)
        }
        if address == ""{
            allError = "Please enter in an address"
        }
        //if locations == "" {
          //Find a  no value for NSobject
        //}
        
        if dateTime1 == "" {
            
            allError = "Enter a Start Time"
            
        }
        
        if dateTime2 == ""{
            allError = "Enter a End Time"
        }
        println(allError)

        if allError == "" {
            //If the user is editing the event
            if editing == true {
                var eventQue = PFQuery(className: "Event")
                eventQue.getObjectInBackgroundWithId(eventID, block: {
                    
                    (eventItem:PFObject!, error:NSError!) -> Void in
                    
                    if error == nil {
                        eventItem["address"] = self.address
                        eventItem["locationGeopoint"] = geopoint
                        eventItem["start"] = orderDate1
                        eventItem["end"] = orderDate2
                        eventItem["isPublic"] = self.eventPublic
                        eventItem["hasFood"] = self.food
                        eventItem["isFree"] = self.paid
                        eventItem["onCampus"] = self.onsite
                        eventItem["location"] = self.eventLocation
                        eventItem["title"] = self.eventTitle.text
                        eventItem["author"] = PFUser.currentUser().username
                        eventItem["authorID"] = PFUser.currentUser().objectId
                        eventItem["isDeleted"] = false
                        eventItem.saveInBackgroundWithBlock({
                            (success:Bool!, error:NSError!) -> Void in
                            
                            if error == nil {
                                orderDate1 = NSDate()
                                orderDate2 = NSDate()
                                dateTime1 = String()
                                dateTime2 = String()
                                dateStr1 = String()
                                dateStr2 = String()
                                startString = String()
                                endString = String()
                          
                            }
                                self.performSegueWithIdentifier("eventback", sender: self)
                        })
                        //Queries al the people who added this event to calendar
                        var findPeople = PFQuery(className: "UserCalendar")
                        var collectedPeople = [String]()
                        findPeople.whereKey("eventID", equalTo:self.eventID )
                        findPeople.whereKey("user", notEqualTo: PFUser.currentUser().username)
                        findPeople.findObjectsInBackgroundWithBlock({
                            (results:[AnyObject]!, Error:NSError!) -> Void in
                            
                            for object in results {
                                collectedPeople.append(object["user"] as String)
                            }
                            var push =  PFPush()
                            let data = [
                                "alert" : "\(PFUser.currentUser().username) has edited the event '\(self.eventTitle.text)'",
                                "badge" : "Increment",
                                "sound" : "default"
                            ]
                            var pfque = PFInstallation.query()
                            println()
                            println(collectedPeople)
                            println()
                            pfque.whereKey("user", containedIn: collectedPeople) //Adds all the people who added your event
                            push.setQuery(pfque)
                            push.setData(data)
                            push.sendPushInBackgroundWithBlock({
                                // Notifies the people you edited your event
                                (success: Bool!, pushError: NSError!) -> Void in
                                if pushError == nil {
                                    println("the push was sent")
                                } else {
                                    println("push was not sent")
                                }
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("Edited Event (EM)")
                            })
                        })
                
                    }
                })
            }
            else {
                var event = PFObject(className: "Event")
                event["address"] = address
                event["locationGeopoint"] = geopoint
                event["start"] = orderDate1
                event["end"] = orderDate2
                event["isPublic"] = self.eventPublic
                event["hasFood"] = self.food
                event["isFree"] = self.paid
                event["onCampus"] = self.onsite
                event["location"] = self.eventLocation
                event["title"] = self.eventTitle.text
                event["author"] = PFUser.currentUser().username
                event["authorID"] = PFUser.currentUser().objectId
                event["isDeleted"] = false
                event.saveInBackgroundWithBlock{
                    
                    (success:Bool!,eventError:NSError!) -> Void in
                    
                    if (eventError == nil){
                            var push =  PFPush()
                            let data = [
                                "alert" : "\(PFUser.currentUser().username) has created an event '\(self.eventTitle.text)'",
                                "badge" : "Increment",
                                "sound" : "default"
                            ]
                            push.setChannel(PFUser.currentUser().objectId)
                            push.setData(data)
                            push.sendPushInBackgroundWithBlock({
                            
                                (success: Bool!, pushError: NSError!) -> Void in
                                if pushError == nil {
                                    
                                    println("the push was sent")
                                    
                                }
                                
                                var theMix = Mixpanel.sharedInstance()
                                theMix.track("Created Event (EM)")
                                
                            })
                            
                        
             
                        var notify = PFObject(className: "Notification")
                        notify["senderID"] = PFUser.currentUser().objectId
                        notify["receiverID"] = PFUser.currentUser().objectId
                        notify["sender"] = PFUser.currentUser().username
                        notify["receiver"] = PFUser.currentUser().username
                        notify["type"] =  "event"
                        notify.saveInBackgroundWithBlock({
                            (success:Bool!, notifyError: NSError!) -> Void in
                            if notifyError == nil {
                                println("notifcation has been saved")
                            }
                            else {
                                println("fail")
                            }
                        })
                        orderDate1 = NSDate()
                        orderDate2 = NSDate()
                        dateTime1 = String()
                        dateTime2 = String()
                        dateStr1 = String()
                        dateStr2 = String()
                        startString = String()
                        endString = String()
                        self.performSegueWithIdentifier("eventback", sender: self)
                        println("it worked")
                        
                    }
                }
            }
        }
        else {
            displayAlert("Error", error: allError)
        }
    }
    
    @IBAction func deleteEvent(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Are you sure", message: "Do you want to delete this event", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { action in
            switch action.style{
            case .Destructive:
                var eventQue = PFQuery(className: "Event")
                eventQue.getObjectInBackgroundWithId(self.eventID, block: {
                    
                    (eventItem:PFObject!, error:NSError!) -> Void in
                    
                    if error == nil {
                        
                        var theMix = Mixpanel.sharedInstance()
                        theMix.track("Deleted Event (EM)")
                        var name = PFUser.currentUser().username
                        eventItem["isDeleted"] = true
                        eventItem.save()
                        var findPeople = PFQuery(className: "UserCalendar")
                        var collectedPeople = [String]()
                        findPeople.whereKey("eventID", equalTo:self.eventID )
                        findPeople.whereKey("user", notEqualTo: PFUser.currentUser().username)
                        findPeople.findObjectsInBackgroundWithBlock({
                            (results:[AnyObject]!, Error:NSError!) -> Void in
                            
                            for object in results {
                                collectedPeople.append(object["user"] as String)
                            }
                            var push =  PFPush()
                            let data = [
                                "alert" : "\(PFUser.currentUser().username) has cancelled the event '\(self.eventTitle.text)'",
                                "badge" : "Increment",
                                "sound" : "default"
                            ]
                            var pfque = PFInstallation.query()
                            println()
                            println(collectedPeople)
                            println()
                            pfque.whereKey("user", containedIn: collectedPeople) //Adds all the people who added your event
                            push.setQuery(pfque)
                            push.setData(data)
                            push.sendPushInBackgroundWithBlock({
                                // Notifies the people you edited your event
                                (success: Bool!, pushError: NSError!) -> Void in
                                if pushError == nil {
                                    println("the push was sent")
                                } else {
                                    println("push was not sent")
                                }
                              
                            })
                        })
                      
                        self.performSegueWithIdentifier("eventback", sender: self)
                        
                    }
                })
            case .Cancel:
                println("cancel")
                
            case .Default:
                println("destructive")
            }
        }))
        
    }
    override func viewDidAppear(animated: Bool) {
        if eventLocation == "" {
            eventLocationDescription.setTitle("Location", forState: UIControlState.Normal)
        } else {
            eventLocationDescription.setTitle(eventLocation, forState: UIControlState.Normal)
            
        }
        if address == "" {
            eventAddress.setTitle("Address", forState: UIControlState.Normal)
        } else {
            eventAddress.setTitle(address, forState: UIControlState.Normal)
        }
        if (startString == ""){
            start.setTitle("Start Time", forState: UIControlState.Normal)
        }
        else {
            start.setTitle(startString, forState: UIControlState.Normal)
        }
        if (endString == "") {
            end.setTitle("End Time", forState: UIControlState.Normal)
        }
        else {
            end.setTitle(endString, forState: UIControlState.Normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var theMix = Mixpanel.sharedInstance()
        theMix.track("Create Event Opened")
        theMix.flush()
        self.tabBarController?.navigationItem.hidesBackButton = false
        self.tabBarController?.tabBar.hidden = true
        if editing == false {
            
            self.navigationItem.rightBarButtonItem = nil
        }
        else {
            eventTitle.text = eventTitlePass
            eventLocationDescription.setTitle(eventLocation, forState: UIControlState.Normal)
            var checkPublicStatus = PFQuery(className: "Event")
            var status = checkPublicStatus.getObjectWithId(eventID)
            if status["isPublic"] as Bool == true {
                publicSegment.selectedSegmentIndex = 0
            } else {
                publicSegment.selectedSegmentIndex = 1
            }
        }
   
        if food == true {
            println("OK IT WOKRS")
            foodSegement.selectedSegmentIndex = 0
        }
        else {
            println("FOOD IS NOT TRUE")
            foodSegement.selectedSegmentIndex = 1
        }
        if paid == true {
            println("OK IT WOKRS")
            freeSegment.selectedSegmentIndex = 0
        }
        else {
            println("PAID IS NOT TRUE")
            freeSegment.selectedSegmentIndex = 1
        }
        if onsite == true {
            println("OK IT WOKRS")
            oncampusSegement.selectedSegmentIndex = 0
        }
        else {
            println("ONSITE is true")
            oncampusSegement.selectedSegmentIndex = 1
        }
        
        if PFUser.currentUser() == nil{
            
            self.performSegueWithIdentifier("register", sender: self)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelToPlayersViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func savePlayerDetail(segue:UIStoryboardSegue) {
    
    }
  
}

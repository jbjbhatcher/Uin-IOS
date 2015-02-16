//
//  eventCell.swift
//  UinProto2
//
//  Created by Kareem Dasilva on 1/9/15.
//  Copyright (c) 2015 Kareem Dasilva. All rights reserved.
//

import UIKit



class eventCell: UITableViewCell {

    @IBOutlet weak var foodText: UILabel!
    
    @IBOutlet weak var costText: UILabel!
    
    @IBOutlet weak var onCampusText: UILabel!
    
    @IBOutlet weak var eventName: UILabel!
    
   
    @IBOutlet weak var onCampusIcon: UIImageView!

 
    @IBOutlet weak var freeIcon: UIImageView!
    

    @IBOutlet weak var foodIcon: UIImageView!
    
    

    @IBOutlet weak var poop: UIButton!
    

    
    @IBOutlet weak var people: UILabel!
    
    
    @IBOutlet weak var time: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//
//  Activity.swift
//  Nutshell
//
//  Created by Brian King on 9/15/15.
//  Copyright © 2015 Tidepool. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class Activity: CommonData {

    override class func fromJSON(json: JSON, moc: NSManagedObjectContext) -> Activity? {
        if let entityDescription = NSEntityDescription.entityForName("Activity", inManagedObjectContext: moc) {
            let me = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: nil) as! Activity
            
            me.subType = json["subType"].string
            me.duration = json["duration"].number
            me.intensityMet = NSDecimalNumber(string: json["intensityMet"].string)
            me.intensityBorg = NSDecimalNumber(string: json["intensityBorg"].string)
            me.intensityHr = NSDecimalNumber(string: json["intensityHr"].string)
            me.intensityWatts = NSDecimalNumber(string: json["intensityWatts"].string)
            me.location = json["location"].string
            
            return me
        }
        
        return nil
    }

}

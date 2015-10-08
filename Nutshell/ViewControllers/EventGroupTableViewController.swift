/*
* Copyright (c) 2015, Tidepool Project
*
* This program is free software; you can redistribute it and/or modify it under
* the terms of the associated License, which is identical to the BSD 2-Clause
* License as published by the Open Source Initiative at opensource.org.
*
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the License for more details.
*
* You should have received a copy of the License along with this program; if
* not, you can obtain one from Tidepool Project at tidepool.org.
*/

import UIKit

class EventGroupTableViewController: BaseUITableViewController {

    var eventGroup = NutEvent()
    @IBOutlet weak var titleTextField: NutshellUITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.titleTextField.text = eventGroup.title
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if eventGroup.itemArray.count == 0 {
            self.performSegueWithIdentifier("unwindSequeToEventList", sender: self)
            return
        }
        eventGroup.sortEvents()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //
    // MARK: - Title editing
    //

    @IBAction func titleEditingDidBegin(sender: AnyObject) {
    }
    
    @IBAction func titleEditingDidEnd(sender: AnyObject) {
        titleTextField.resignFirstResponder()
        if let newTitle = titleTextField.text {
            if newTitle == "" {
                titleTextField.text = eventGroup.title
            } else if eventGroup.title != titleTextField.text {
                eventGroup.title = newTitle
                let ad = UIApplication.sharedApplication().delegate as! AppDelegate
                let moc = ad.managedObjectContext
                for eventItem in eventGroup.itemArray {
                    eventItem.title = newTitle
                    if let mealItem = eventItem as? NutMeal {
                        mealItem.meal.title = newTitle
                        moc.refreshObject(mealItem.meal, mergeChanges: true)
                    } else if let workoutItem = eventItem as? NutWorkout {
                        workoutItem.workout.title = newTitle
                        moc.refreshObject(workoutItem.workout, mergeChanges: true)
                    }
                }
                // Save the database
                do {
                    try moc.save()
                    print("EventGroup: Database saved!")
                } catch let error as NSError {
                    // TO DO: error message!
                    print("Failed to save MOC: \(error)")
                }
            }
        }
    }

    //
    // MARK: - Table view data source
    //

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventGroup.itemArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("eventItemCell", forIndexPath: indexPath) as! EventGroupTableViewCell
        
        // Configure the cell...
        if indexPath.item < eventGroup.itemArray.count {
            let eventItem = eventGroup.itemArray[indexPath.item]
            cell.configureCell(eventItem)
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "EventItemDetailSegue" {
            let cell = sender as! EventGroupTableViewCell
            let eventItemVC = segue.destinationViewController as! EventDetailViewController
            eventItemVC.eventItem = cell.eventItem
            eventItemVC.eventGroup = eventGroup
            eventItemVC.title = self.title
        } else if segue.identifier == "EventItemAddSegue" {
            let eventItemVC = segue.destinationViewController as! EventDetailViewController
            // no existing item to pass along...
            eventItemVC.eventGroup = eventGroup
            eventItemVC.eventTitleString = eventGroup.title
        }
    }

    @IBAction func done(segue: UIStoryboardSegue) {
        print("unwind segue to eventGroup done")
    }

    @IBAction func cancel(segue: UIStoryboardSegue) {
        print("unwind segue to eventGroup cancel")
    }
    
}



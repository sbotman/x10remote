//
//  RootTableViewController.swift
//  x10remote
//
//  Created by Sander Botman on 12/7/15.
//  Copyright © 2015 Botman Inc. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {
    
    var cellContent = [X10Device]()
    var refresher: UIRefreshControl!
    var url = NSURL(string: "http://10.0.1.190:8080/device")!
    
    
    func refresh() {
        
        reloadTableViewData(url)
        
        self.refresher.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Device list"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to update device list")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.addSubview(refresher)
        
        reloadTableViewData(url)
    }

    
    func reloadTableViewData(url: NSURL) {
        
        // clear table
        self.cellContent.removeAll()
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            // This will happen when the session loading is done.
            
            if let urlContent = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    
                    for var i = 0 ; i < json.count ; i++ {
                        let title = json[i]["title"] as? String
                        let id = json[i]["id"] as? Int
                        let module = X10Device.init(deviceId: id!, deviceName: title!)
                        self.cellContent.append(module)
                    }
                    self.reloadTableView()
                    
                } catch {
                    
                    self.cellContent.append(X10Device.init(deviceId: 0, deviceName: "cannot serialize json"))
                    self.cellContent.append(X10Device.init(deviceId: 0, deviceName: "please try again"))
                    self.reloadTableView()
                }
                
            } else {
                self.cellContent.append(X10Device.init(deviceId: 0, deviceName: "connection error"))
                self.cellContent.append(X10Device.init(deviceId: 0, deviceName: "please try again"))
                self.reloadTableView()
            }
        }
        
        task.resume()
        
    }
    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.cellContent.sortInPlace() { $0.deviceName > $1.deviceName }
            self.cellContent = self.cellContent.reverse()
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellContent.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = cellContent[indexPath.row].deviceName
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if segue.identifier == deviceSegueIdentifier {
            if let destination = segue.destinationViewController as? DeviceViewController {
                // let indexPath = NSIndexPath(forRow: tableView.indexPathForSelectedRow!.row, inSection: 0)
                //let cell = self.tableView.cellForRowAtIndexPath(tableView.indexPathForSelectedRow!)
                destination.device = cellContent[(tableView.indexPathForSelectedRow?.row)!]
                
       }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == blogSegueIdentifier {
            if let destination = segue.destinationViewController as? BlogViewController {
                if let blogIndex = tableView.indexPathForSelectedRow()?.row {
                    destination.blogName = swiftBlogs[blogIndex]
                }
            }
        }
    }
    */
    

}

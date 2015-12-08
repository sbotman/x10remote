//
//  ViewController.swift
//  x10remote
//
//  Created by Sander Botman on 12/6/15.
//  Copyright © 2015 Botman Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var cellContent = [""]
    var refresher: UIRefreshControl!
    var url = NSURL(string: "http://localhost:8080/device")!
    
    func refresh() {
        
        reloadTableViewData(url)
        
        self.refresher.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        if let title = json[i]["title"] as? String {
                            self.cellContent.append(title)
                        }
                    }
                    self.reloadTableView()
                    
                } catch {
                    self.cellContent.append("error serializing data")
                    self.cellContent.append("please try again")
                    self.reloadTableView()
                }
                
            } else {
                self.cellContent.append("connection error")
                self.cellContent.append("please try again")
                self.reloadTableView()
            }
        }
            
        task.resume()
    
    }
    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }

    // Selecting one of the devices

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        NSLog("did select and the text is \(cell?.textLabel?.text)")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = cellContent[indexPath.row]
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


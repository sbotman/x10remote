//
//  DeviceViewController.swift
//  x10remote
//
//  Created by Sander Botman on 12/7/15.
//  Copyright © 2015 Botman Inc. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {
    
    @IBOutlet weak var deviceName: UILabel!
    
    @IBOutlet weak var deviceID: UILabel!
   
    @IBOutlet weak var deviceRoom: UILabel!
    
    
    @IBOutlet weak var deviceCode: UILabel!
    
    
   
    @IBAction func onButton(sender: AnyObject) {
        postAction("on", code: self.deviceCode.text!)
    }

    @IBAction func offButton(sender: AnyObject) {
        postAction("off", code: self.deviceCode.text!)
    }
    
    @IBAction func brightButton(sender: AnyObject) {
        postAction("bright", code: self.deviceCode.text!)
    }
    
    @IBAction func dimButton(sender: AnyObject) {
        postAction("dim", code: self.deviceCode.text!)
    }

    
    var baseUrl = "http://10.0.1.190:8080"
    
    var device = X10Device.init(deviceId: 0, deviceName: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "\(device.deviceId)"
        self.title = "Device details"
        
        let deviceUrl = NSURL(string: baseUrl + "/device/\(device.deviceId)")!
        fetchDeviceData(deviceUrl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func postAction(state: String, code: String) {
    
        let url:String = baseUrl + "/action"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonString = "{\"state\":\"\(state)\",\"code\":\"\(code)\"}"

        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // print("response = \(response)")
            
            // let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            // print("responseString = \(responseString)")
        }
        task.resume()
     }


    func fetchDeviceData(url: NSURL) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let urlContent = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let id = json["id"] as? Int
                        let title = json["title"] as? String
                        let code = json["code"] as? String
                        let room = json["room"] as? String
                   
                        self.deviceName.text = "\(title!)"
                        self.deviceRoom.text = "\(room!)"
                        self.deviceID.text = "\(id!)"
                        self.deviceCode.text = "\(code!)"
                    }
                    
                } catch {
                    // show error
                }

            }
        }
        task.resume()
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

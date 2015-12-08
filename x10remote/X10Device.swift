//
//  X10Device.swift
//  x10remote
//
//  Created by Sander Botman on 12/7/15.
//  Copyright © 2015 Botman Inc. All rights reserved.
//

class X10Device {
    var deviceName: String
    var deviceId: Int
    
    init(deviceId: Int, deviceName: String) {
        self.deviceId = deviceId
        self.deviceName = deviceName
    }
}

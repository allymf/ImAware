//
//  HardwareContext.swift
//  Aware
//
//  Created by Yuri Saboia Felix Frota on 28/08/17.
//  Copyright © 2017 Taskr. All rights reserved.
//

import Foundation
import UIKit
import ExternalAccessory
import AVFoundation

enum State : String{
    case on = "On"
    case off = "Off"
}

class HardwareContext : Context {
    
    internal var contextType : ContextType = .Hardware
    
    //Getting Screen Brightness
    var screenBrightness : Float {
        get {
            return Float(UIScreen.main.brightness * 100)
        }
    }
    
    //Getting Battery level in percentage
    var batteryLevel : Float? {
        get {
            let device = UIDevice.current
            device.isBatteryMonitoringEnabled = true
            
            return device.batteryLevel > 0 ? device.batteryLevel * 100 : nil
        }
    }
    
    //Getting available disk space in percentage
    var availableSpace : Float {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value ?? 0
                let totalSpace = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value ?? 0
                
                return totalSpace >= 0 ? Float(freeSpace * 100) / Float(totalSpace) : 0
            } catch {
                return 0
            }
        }
    }
    
    //Getting PowerMode Status
    var powerModeEnabled : Bool {
        get {
            if #available(iOS 9.0, *) {
                return ProcessInfo.processInfo.isLowPowerModeEnabled
            } else {
                // Fallback on earlier versions
                return false
            }
        }
    }
    
    //Getting Headphone status
    //Credits to Antonio E., this code is coming from this SO answer : http://stackoverflow.com/a/21382748/588967
    var headphonetPluggedIn : Bool {
        get {
            let route = AVAudioSession.sharedInstance().currentRoute
            
            for desc in route.outputs {
                if desc.portType == AVAudioSessionPortHeadphones {
                    return true
                }
            }
            
            return false
        }
    }
    
    //Getting connected Acessories list
    var connectedAcessories : [String] {
        get {
            var acessories : [String] = []
            
            for access in EAAccessoryManager.shared().connectedAccessories {
                acessories.append(access.name)
            }
            
            return acessories
        }
    }
}

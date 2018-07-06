//
//  XCNotificationCenterExtension.swift
//  XCSwiftKit
//
//  Created by zhangxuchuan on 2018/7/6.
//  Copyright © 2018年 zhangxuchuan. All rights reserved.
//

import Foundation

extension NotificationCenter {
    
    public func postOnMainThread(name : NSNotification.Name , object : Any? , userInfo : [AnyHashable:Any]?)  {
        if pthread_main_np() != 0{
            self.post(name: name, object: object, userInfo: userInfo)
        }
        
        var info = [String:Any]()
        info["name"] = name
        info["object"] = object
        info["userInfo"] = userInfo
        self.perform(#selector(_xcPost(info:)), on: Thread.main, with: info, waitUntilDone: false)
        
    }
    public func postOnMainThread(name : NSNotification.Name , object : Any?){
        if pthread_main_np() != 0 {
            self.post(name: name, object: object)
        }
        var info = [String:Any]()
        info["name"] = name
        info["object"] = object
        
        self.perform(#selector(_xcPost(info:)), on: Thread.main, with: info, waitUntilDone: false)
        
    }
    public func postOnMainThread(_ notification : Notification) {
        if pthread_main_np() != 0 {
            self.post(notification)
        }
        self.perform(#selector(_xcPost(_:)), on: Thread.main, with: notification, waitUntilDone: false)
    }

    @objc func _xcPost(info : [String : Any])  {
        let name = info["name"]
        let object = info["object"]
        var userInfo : [AnyHashable:Any] = [:]
        if (info.has("userInfo")){
            userInfo = info["userInfo"] as! [AnyHashable : Any]
        }
        self.post(name: name as! NSNotification.Name, object: object, userInfo: userInfo)
        
    }
    

    @objc func _xcPost(_ notification : Notification ){
        self.post(notification)
    }
    
}

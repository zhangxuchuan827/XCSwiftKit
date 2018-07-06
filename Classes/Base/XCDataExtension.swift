//
//  XCDataExtension.swift
//  XCSwiftKitDemo
//
//  Created by zhangxuchuan on 2018/7/1.
//  Copyright © 2018年 zhangxuchuan. All rights reserved.
//

import Foundation

extension Data {
    
    public func UTF8String() -> String {
        if self.count > 0 {
            return String.init(data: self, encoding: String.Encoding.utf8) ?? ""
        }
        return ""

    }
    
}

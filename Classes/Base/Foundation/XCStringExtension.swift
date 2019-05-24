//
//  XCStringExtension.swift
//  XCSwiftKitDemo
//
//  Created by zhangxuchuan on 2018/7/1.
//  Copyright © 2018年 zhangxuchuan. All rights reserved.
//

import Foundation

extension String {
    
    //MARK:- 校验
    
    ///通过正则表达式验证
    public func validate(regex : String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let state = predicate.evaluate(with: self)
        return state
    }
    ///判断是否是URL
    public func isURLString() -> Bool {
        let regex = "[a-zA-z]+://[^\\s]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let state = predicate.evaluate(with: self)
        return state
    }
    
    func isInt() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    func isFloat() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Float = 0
        return scan.scanFloat(&val) && scan.isAtEnd
    }


    
    //MARK:- 截取
    
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    
    public func substring(from : Int ,length : Int) ->String {
        if self.count > from && self.count <= from + length {
            return self.substring(from: from)
        }else{
            let startIndex = self.index(self.startIndex, offsetBy: from)
            let endIndex = self.index(startIndex, offsetBy: length)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        }
    }

}

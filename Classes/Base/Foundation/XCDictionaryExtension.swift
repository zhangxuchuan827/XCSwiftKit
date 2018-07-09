//
//  XCDictionaryExtension.swift
//  XCSwiftKitDemo
//
//  Created by zhangxuchuan on 2018/7/1.
//  Copyright © 2018年 zhangxuchuan. All rights reserved.
//

import Foundation

/// EZSE: Combines the first dictionary with the second and returns single dictionary
public func += <KeyType, ValueType> (left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

extension Dictionary {
    /// 返回随机的key-value
    public func random() -> Value? {
        return Array(values).random()
    }
    
    /// 合并两个字典
    public func union(_ dictionaries: Dictionary...) -> Dictionary {
        var result = self
        dictionaries.forEach { (dictionary) -> Void in
            dictionary.forEach { (arg) -> Void in
                
                let (key, value) = arg
                result[key] = value
            }
        }
        return result
    }
    
    /// 判断key是否存在
    public func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    //MARK:- PList
    
    static func dictionaryFrom(plistData : Data) -> Dictionary {
        var target : [Key:Value] = [:]
        let dic = try? PropertyListSerialization.propertyList(from: plistData, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil)
        if dic is Dictionary {
            target = dic as! Dictionary<Key, Value>
        }
        return target
    }
    
    static func dictionaryFrom(plistString : String) -> Dictionary {
        let data = plistString.data(using: String.Encoding.utf8)
        return self.dictionaryFrom(plistData: data!)
    }

    func plstData() -> Data? {
        let data = try? PropertyListSerialization.data(fromPropertyList: self, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
        return data
    }
    func plistString() -> String? {
        let XMLData = try? PropertyListSerialization.data(fromPropertyList: self, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
        let string = XMLData?.UTF8String()
        return string
    }
    
    //MARK:- XML
    static func dictionaryFrom(xml : String) -> Dictionary? {
        ///XML解析过后在写
        return nil
    }
   

}





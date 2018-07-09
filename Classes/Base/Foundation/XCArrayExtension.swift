//
//  XCArrayExtension.swift
//  XCSwiftKitDemo
//
//  Created by zhangxuchuan on 2018/7/1.
//  Copyright © 2018年 zhangxuchuan. All rights reserved.
//

import Foundation
import UIKit

public func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case let (lhs?, rhs?):
        return lhs == rhs
    case (.none, .none):
        return true
    default:
        return false
    }
}

extension Array {
    
    //MARK:- 转换
    
    func arrayWithPlistData(_ data : Data?) -> Array<Any>? {
        if data == nil {
            return nil
        }
        let array = try? PropertyListSerialization.propertyList(from: data!, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil)
        if array is Array{
            return array as? Array<Any>
        }
        return nil
    }
    
    func arrWithPlistString(_ plistString : String) -> Array<Any>? {
        let data = plistString.data(using: String.Encoding.utf8)
        return self.arrayWithPlistData(data)
    }
    
    func plistData() -> Data? {
        let data = try? PropertyListSerialization.data(fromPropertyList: self, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
        return data
    }
    
    func plistString() -> String? {
        let xmlData = try? PropertyListSerialization.data(fromPropertyList: self, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
        if xmlData != nil {
            return xmlData?.UTF8String()
        }
        return nil
    }
    

    //MARK:- 内容操作
    
    /// 获取一部分元素
    public func object(at range: ClosedRange<Int>) -> Array {
        let halfOpenClampedRange = Range(range).clamped(to: Range(indices))
        return Array(self[halfOpenClampedRange])
    }
    
    /// 获取某元素
    public func object(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
    /// Checks if array contains at least 1 item which type is same with given element's type
    public func containsType<T>(of element: T) -> Bool {
        let elementType = type(of: element)
        return contains { type(of: $0) == elementType}
    }
    
    /// 遍历器
    public func forEachEnumerated(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        enumerated().forEach(body)
    }
    
    /// 插入元素
    public mutating func insertAtFirst(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    
    /// 合并数组
    public mutating func append(array : [Element]) {
        self = [self,array].flatMap { (obj) -> [Element] in
            return obj
        }
    }
    
    /// 打乱数组顺序
    public mutating func shuffle() {
        guard count > 1 else { return }
        var j: Int
        for i in 0..<(count-2) {
            j = Int(arc4random_uniform(UInt32(count - i)))
            if i != i+j { self.swapAt(i, i+j) }
        }
    }
    
    ///  返回一个随机元素
    public func random() -> Element? {
        guard count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(count)))
        return self[index]
    }
    

}



//
//  XCNSObjectExtension.swift
//  XCSwiftKit
//
//  Created by zhangxuchuan on 2018/7/1.
//  Copyright © 2018年 zhangxuchuan. All rights reserved.
//

import Foundation

typealias blockType_simple = ()->()

extension NSObject{
    
    //MARK:- Method Exchange
    
    ///  Swap two instance method's implementation in one class. Dangerous, be careful.
    ///
    /// - Parameters:
    ///   - originalSel: Selector 1
    ///   - newSel: Selector 2
    /// - Returns: YES if swizzling succeed; otherwise, NO.
    public func swizzleInstanceMethod(originalSel : Selector , newSel : Selector) -> Bool {
        let mthO = method(for: originalSel)
        let mthN = method(for: newSel)
        if mthN == nil || mthO == nil {
            return false
        }
        method_exchangeImplementations(mthO!, mthN!)
        return true
    }
    
    /// Swap two class method's implementation in one class. Dangerous, be careful.
    ///
    /// - Parameters:
    ///   - originalSel: Selector 1
    ///   - newSel: Selector 2
    /// - Returns: Returns: YES if swizzling succeed; otherwise, NO.
    public func swizzleClassMethod(originalSel : Selector , newSel : Selector) -> Bool {
        let mthO = method(for: originalSel)
        let mthN = method(for: newSel)
        if mthN == nil || mthO == nil {
            return false
        }
        method_exchangeImplementations(mthO!, mthN!)
        return true
    }
    
    //MARK:- KVO
    
    
    /// Registers a block to receive KVO notifications for the specified key-path relative to the receiver.
    ///
    /// - Parameters:
    ///   - keyPath: The key path, relative to the receiver, of the property to observe. This value must not be nil.
    ///   - block: The block to register for KVO notifications.
    public func addObserverBlockForKeyPath(keyPath : String , block : @escaping (_ obj : Any , _ oldValue : Any, _ newValue : Any)->()){
        let target = _XCNSObjectKVOBlockTarget.init(block: block)
        var arr = self._XC_AllNSObjectObserverBlocks[keyPath]
        if arr == nil {
            arr = []
            self._XC_AllNSObjectObserverBlocks[keyPath] = arr
        }
        arr?.append(target)
        self.addObserver(target, forKeyPath: keyPath, options: [.new,.old], context: nil)
        
    }
    
    /// Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
    /// receiving change notifications for the property specified by a given key-path
    /// relative to the receiver, and release these blocks.
    ///
    /// - Parameter keyPath: A key-path, relative to the receiver, for which blocks is registered to receive KVO change notifications.
    public func removeObserverBlocksForKeyPath(keyPath : String) {
        if keyPath.isEmpty{
            return
        }
        let arr = self._XC_AllNSObjectObserverBlocks[keyPath]
        for (_ , item) in (arr?.enumerated())!{
            self.removeObserver(item, forKeyPath: keyPath)
        }
        self._XC_AllNSObjectObserverBlocks.removeValue(forKey: keyPath)
    }
    
    ///  Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
    ///  receiving change notifications, and release these blocks.
    func removeObserverBlocks() {
        for (_,value) in self._XC_AllNSObjectObserverBlocks.enumerated(){
            for (_ , item) in (value.value.enumerated()){
                self.removeObserver(item, forKeyPath: value.key)
            }
        }
    }
    
    
    private struct RuntimeKey {
        static let XC_AllNSObjectObserverBlocks_key = UnsafeRawPointer.init(bitPattern: "XC_AllNSObjectObserverBlocks_key".hashValue)
    }
    
    private var _XC_AllNSObjectObserverBlocks: [String:Array<_XCNSObjectKVOBlockTarget>] {
        set {
            objc_setAssociatedObject(self, RuntimeKey.XC_AllNSObjectObserverBlocks_key!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, ViewController.RuntimeKey.XC_AllNSObjectObserverBlocks_key!) as! [String : Any] as! [String : Array<_XCNSObjectKVOBlockTarget>]
        }
    }
}


private class _XCNSObjectKVOBlockTarget: NSObject {
    
    public var blockDo : ((_ obj : Any , _ oldValue : Any, _ newValue : Any)->())?
    
    convenience init(block : @escaping (_ obj : Any ,_ oldValue : Any, _ newValue : Any)->()) {
        self.init()
        self.blockDo = block
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.blockDo == nil {
            return
        }
        let changeKind : Bool = (change![NSKeyValueChangeKey.notificationIsPriorKey] != nil)
        if changeKind != true {
            return
        }
        var oldValue = change![NSKeyValueChangeKey.oldKey]
        if oldValue is NSNull {
            oldValue = nil
        }
        var newValue = change![NSKeyValueChangeKey.newKey]
        if newValue is NSNull {
            newValue = nil
        }
        self.blockDo!(object!,oldValue!,newValue!)
    }
}



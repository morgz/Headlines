//
//  Manager.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class Manager: NSObject {
    
    //All managers share the same realm
    var realm: Realm!
    
    override init() {
        super.init()
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.realm = delegate.uiRealm
    }
    
}


// Methods we use when updating our local articles from remote. We create a whitelist of the attribute we'll let the managers update
extension Object {
    func updateAttributes() -> [String: AnyObject] {
        var attributes = [String: AnyObject]()
        
        //Create a hash of all the updateable attributes
        for attribute in self.dynamicType.allowedAttributes() {
            let value = self.valueForKeyPath(attribute)
            
            if value != nil {
                attributes[attribute] = value
            }
        }
        
        return attributes
    }
    
    class func allowedAttributes() -> [String] {
        return [String]()
    }
}
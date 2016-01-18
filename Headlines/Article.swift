//
//  Article.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import Foundation
import RealmSwift

final class Article: Object, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    dynamic var id = ""
    dynamic var title = ""
    dynamic var bodyText = ""
    
    dynamic var publishDate:NSDate?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    

    //Mark: Creating a representation from the API
    convenience required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.init()
        //self.username = response.URL!.lastPathComponent!
        self.id = representation.valueForKeyPath("id") as! String
        self.title = representation.valueForKeyPath("webTitle") as! String
        
    }
    
    //Creates multiple representations of an object
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Article] {
        var remoteObjects: [Article] = []
        
        if let representation = representation as? [[String: AnyObject]] {
            for eventRepresentation in representation {
                if let report = Article(response: response, representation: eventRepresentation) {
                    remoteObjects.append(report)
                }
            }
        }
        
        return remoteObjects
    }

}

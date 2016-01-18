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
    dynamic var webUrl = ""
    dynamic var apiUrl = ""
    dynamic var sectionId = ""
    dynamic var sectionName = ""
    dynamic var imageUrl = ""
    dynamic var imageCaption = ""

    dynamic var publishDate:NSDate?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    
    //TODO: Make this safer by checking for the return value before force unwrapping
    //Mark: Creating a representation from the API
    convenience required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.init()
        //self.username = response.URL!.lastPathComponent!
        self.id = representation.valueForKeyPath("id") as! String
        self.title = representation.valueForKeyPath("webTitle") as! String
        self.bodyText = representation.valueForKeyPath("fields")?.valueForKeyPath("body") as! String
        self.sectionName = representation.valueForKeyPath("sectionName") as! String
        self.sectionId = representation.valueForKeyPath("sectionId") as! String
        self.webUrl = representation.valueForKeyPath("webUrl") as! String
        
        //Date
        
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


// MARK: Controls the params that can updated via remote
extension Article {
    //Whitelists the params we're allowed to update from remote
    override class func allowedAttributes() -> [String] {
        return ["id","title","bodyText","publishDate"]
    }
}
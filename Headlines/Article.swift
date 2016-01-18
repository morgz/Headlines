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
    dynamic var imageUrlString = ""
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
        

        //Image URl
        let mainString = representation.valueForKeyPath("fields")?.valueForKeyPath("main") as! String
        let imageUrl = mainString.extractURLString()
        self.imageUrlString = imageUrl!.URLString
        
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
        return ["id","title","bodyText","publishDate","sectionName","sectionId","webUrl","imageUrlString"]
    }
}

extension String {
    func extractURLString() -> NSURL? {
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingType.Link.rawValue)
            let matches = detector.matchesInString(self, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, self.characters.count))
            
            for match in matches {
                if match.resultType == NSTextCheckingType.Link {
                    return match.URL
                }
            }
            
            return nil
        } catch _ {
            return nil
        }
    }
}
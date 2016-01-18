//
//  Article.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDate

final class Article: Object, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    dynamic var id = ""
    dynamic var title = ""
    dynamic var bodyText = ""
    dynamic var htmlBodyText = ""
    dynamic var webUrl = ""
    dynamic var apiUrl = ""
    dynamic var sectionId = ""
    dynamic var sectionName = ""
    dynamic var imageUrlString: String?
    dynamic var imageCaption = ""
    dynamic var isFavourite = false

    dynamic var publishDate:NSDate?
    dynamic var favouritedDate:NSDate?
    
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
        
        if let object = representation.valueForKeyPath("id") as? String {
            self.id = object
        }
        
        if let object = representation.valueForKeyPath("webTitle") as? String {
            self.title = object
        }
        
        if let object = representation.valueForKeyPath("fields")?.valueForKeyPath("body") as? String {
            self.htmlBodyText = object
            //Also store a clean body Text without the HTML
            self.bodyText = object.removeHTMLTags()
        }
        
        if let object = representation.valueForKeyPath("sectionName") as? String {
            self.sectionName = object
        }
        
        if let object = representation.valueForKeyPath("sectionId") as? String {
            self.sectionId = object
        }
        
        if let object = representation.valueForKeyPath("webUrl") as? String {
            self.webUrl = object
        }
        
        //Date
        if let dateString = representation.valueForKeyPath("webPublicationDate") as? String, date = dateString.toDate(DateFormat.ISO8601)  {
            self.publishDate = date
        }
        
        //Image URL
        if let object = representation.valueForKeyPath("fields")?.valueForKeyPath("main") as? String {
            //Image URl
            if let imageUrl = object.extractURLString() {
                self.imageUrlString = imageUrl.URLString
            }
        }
        
    }
    
    //MARK Dynamic Properties
    
    // Creates a HTML Attributed string from the html we get from guardian.
    // Unfortunately this method is just too slow.
    
    func bodyTextAsHtmlAttributedString() -> NSAttributedString? {
        
        do {
            let attrs = [ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding]
            let attributedString = try NSAttributedString(data: self.bodyText.dataUsingEncoding(NSUTF8StringEncoding)!, options: attrs as! [String : AnyObject], documentAttributes: nil)
            
            return attributedString
        }
        catch {
            return nil
        }
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
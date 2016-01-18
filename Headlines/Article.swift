//
//  Article.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import Foundation
import RealmSwift

final class Article: Object {
    
    dynamic var id = ""
    dynamic var title = ""
    dynamic var bodyText = ""
    
    dynamic var publishDate:NSDate?
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

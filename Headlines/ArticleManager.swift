//
//  ArticleManager.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import Foundation
import UIKit

class ArticleManager: NSObject {
    
    
    class var sharedInstance:ArticleManager {
        return ArticleManagerSharedInstance
    }
    
    override init() {
        super.init()
    }
    
    //Can add pagination and parameters later
    func getArticles() {
        GuardianAPIManager.sharedInstance.getFinTechArticles()
    }
    
}


let ArticleManagerSharedInstance = ArticleManager()
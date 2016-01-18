//
//  ArticleManager.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ArticleManager: NSObject {
    
    
    class var sharedInstance:ArticleManager {
        return ArticleManagerSharedInstance
    }
    
    override init() {
        super.init()
    }
    
    //Can add pagination and parameters later
    func getRemoteArticles() {
        
        GuardianAPIManager.sharedInstance.getFinTechArticles().responseCollection { (response: Response<[Article], NSError>) in
            
            switch response.result {
            case .Success(let fetchedArticles):
                print(fetchedArticles)
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
}


let ArticleManagerSharedInstance = ArticleManager()
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
import RealmSwift

class ArticleManager: Manager {
    
    
    class var sharedInstance:ArticleManager {
        return ArticleManagerSharedInstance
    }
    
    override init() {
        super.init()
    }

    //MARK: Object Creation
    func createLocalArticles(remoteArticles:[Article]) {
        try! self.realm.write {
            for article in remoteArticles {
                let attributes = article.updateAttributes() //Get the attributes we're allowed to update
                self.realm.create(Article.self,value:attributes,update:true)
            }
        }
    }
    
    
    //MARK: Guardian API Remote Methods
    //Can add pagination and parameters later
    func getRemoteArticles() {
        
        GuardianAPIManager.sharedInstance.getFinTechArticles().responseCollection { (response: Response<[Article], NSError>) in
            
            switch response.result {
            case .Success(let remoteArticles):
                //Take the remote results and persist local ones.
                self.createLocalArticles(remoteArticles)
                
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    //Favouriting
    
    func addRemoveFromFavourites(article article:Article) {
        try! self.realm.write {
            article.isFavourite = !article.isFavourite
        }
    }
    
    
    
}


let ArticleManagerSharedInstance = ArticleManager()
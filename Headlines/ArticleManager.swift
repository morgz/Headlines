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

enum ArticlesMode: Int {
    case All = 0
    case Favourites
}

class ArticleManager: Manager {
    
    var articles : Results<Article>?
    var favouriteArticles : Results<Article>?
    var articleMode = ArticlesMode.All
    
    var articlesToDisplay : Results<Article>? {
        get {
            if self.articleMode == ArticlesMode.Favourites {
                return self.favouriteArticles
            }
            else {
                return self.articles
            }
        }
    }
    
    class var sharedInstance:ArticleManager {
        return ArticleManagerSharedInstance
    }
    
    override init() {
        super.init()
        
        self.articles = self.realm.objects(Article).sorted("publishDate", ascending: false)
        self.favouriteArticles = self.realm.objects(Article).filter("isFavourite == 1").sorted("favouritedDate", ascending: false)
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
    func getRemoteArticles(completion: (response: Response<[Article], NSError>) -> Void) {
        
        GuardianAPIManager.sharedInstance.getFinTechArticles().responseCollection { (response: Response<[Article], NSError>) in
            
            switch response.result {
            case .Success(let remoteArticles):
                //Take the remote results and persist local ones.
                self.createLocalArticles(remoteArticles)
                
            case .Failure(let error):
                print(error)
            }
            
            completion(response: response)
        }
    }
    
    //Favouriting
    
    func addRemoveFromFavourites(article article:Article) {
        try! self.realm.write {
            article.isFavourite = !article.isFavourite
            article.favouritedDate = NSDate()
        }
    }
    
    
    
}


let ArticleManagerSharedInstance = ArticleManager()
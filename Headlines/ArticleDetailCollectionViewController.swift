//
//  ArticleDetailCollectionViewController.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import UIKit
import RealmSwift
import TUSafariActivity

private let reuseIdentifier = "ArticleDetailCell"

class ArticleDetailCollectionViewController: UICollectionViewController {
    
    var initialIndexPath:NSIndexPath?
    
    var currentIndexPath:NSIndexPath? {
        didSet {
            if let articles = ArticleManager.sharedInstance.articlesToDisplay, indexPath = self.currentIndexPath {
                self.currentArticle = articles[indexPath.item]
            }
            else {
                self.currentArticle = nil
            }
            
            //Format the button for the new current article
            self.formatFavouriteButton()
        }
    }

    var currentArticle: Article?

    @IBOutlet weak var favButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        //Set the title
        self.title = ArticleManager.sharedInstance.articleMode == .All ? NSLocalizedString("Most Recent Articles", comment: "Most Recent Articles") :
                                                                         NSLocalizedString("Favourites", comment: "Favourites")

        // Do any additional setup after loading the view.
        self.reloadData()
    }
    
    func reloadData() {
        self.collectionView?.reloadData()
        
        if let indexPath = self.initialIndexPath {
            self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
            self.initialIndexPath = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Sharing
    @IBAction func shareButtonClicked(sender: UIBarButtonItem) {
        
        if let shareUrlString = self.currentArticle?.webUrl, shareUrl = NSURL(string: shareUrlString) {
            let safariActivity = TUSafariActivity()
            let activityVC = UIActivityViewController(activityItems: [shareUrl], applicationActivities: [safariActivity])
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    //MARK: Favouriting
    
    @IBAction func addRemoveFavourite(sender:UIBarButtonItem) {

        if let articles = ArticleManager.sharedInstance.articlesToDisplay, indexPath = self.currentIndexPath {
            let article = articles[indexPath.item]
            
            //Will I let them add an article???? hmmmm
            if (self.canAddArticle(article)) {
                
                let isDelete = article.isFavourite == true
                
                //Add or remove the fav from our datasource
                ArticleManager.sharedInstance.addRemoveFromFavourites(article: article)
                
                /**
                *  If it is an 'unfavouriting' and in favs mode then we remove the cell
                */
                if isDelete && ArticleManager.sharedInstance.articleMode == .Favourites {
                    
                    //The current path is now invalide as it's not longer part of the collection. It will get reset in cellForRow: if we have more.
                    self.currentIndexPath = nil
                    
                    // Stop any interaction while our datasource doesn't match the collection view
                    self.collectionView?.userInteractionEnabled = false
                    self.favButton.enabled = false
                    
                    // A short delay so the user can see the star change state
                    delay(0.25, closure: { () -> () in
                        self.collectionView?.performBatchUpdates({ () -> Void in
                            self.collectionView?.deleteItemsAtIndexPaths([indexPath])
                            }, completion: { (success) -> Void in
                                //renable interaction. Fav button is taking care of when in new cellForRow:
                                self.collectionView?.userInteractionEnabled = true
                        })
                    })
                }
                else {
                    // If we're not in favourite mode we just need to format the button.
                    self.formatFavouriteButton()
                }
            }
            else {
                let alert = UIAlertController(title: "Hire Me", message: "You can only have 4 favourites. To unlock unlimited favourites you have to hire me.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "You've got the job", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func canAddArticle(article:Article) -> Bool {
        if article.isFavourite == false && ArticleManager.sharedInstance.favouriteArticles?.count == 4 {
            return false
        }
        else {
            return true
        }
    }
    
    func formatFavouriteButton() {
        
        if let article = self.currentArticle {
            self.favButton.enabled = true
            self.favButton.image = article.isFavourite ? UIImage(named: "favIcon") : UIImage(named: "noFavIcon")
        }
        else {
            self.favButton.enabled = false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        guard let articles = ArticleManager.sharedInstance.articlesToDisplay else {
            return 0
        }
        
        return articles.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ArticleDetailCollectionViewCell
        
        //Set the current Index Path
        self.currentIndexPath = indexPath
        
        // Configure the cell
        guard let articles = ArticleManager.sharedInstance.articlesToDisplay else {
            return cell
        }
        
        let article = articles[indexPath.item]
        
        // Configure the cell...
        cell.formatWith(article: article)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.collectionView!.frame.size.width, self.collectionView!.frame.size.height)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView?.collectionViewLayout.invalidateLayout()
        
        //To force the colelction view to refresh, just need to give it a nudge
        if let indexPath = self.currentIndexPath {
            self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: false)
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

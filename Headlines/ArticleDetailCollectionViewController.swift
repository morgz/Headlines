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
                self.formatFavouriteButton()
            }
        }
    }

    var currentArticle: Article?

    @IBOutlet weak var favButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the title
        self.title = ArticleManager.sharedInstance.articleMode == .All ? NSLocalizedString("Most Recent Articles", comment: "Most Recent Articles") :
                                                                         NSLocalizedString("Favourites", comment: "Favourites")

        // Do any additional setup after loading the view.
        self.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Our overview may hide the bars so make sure there not hidden here
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBarHidden = false
        navigationController?.setToolbarHidden(false, animated: false)
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
                ArticleManager.sharedInstance.addRemoveFromFavourites(article: article)
                self.formatFavouriteButton()
            }
            else {
                let alert = UIAlertController(title: "Hire Me", message: "You can only have 3 favourites. To unlock unlimited favourites you have to hire me.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "You've got the job", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func canAddArticle(article:Article) -> Bool {
        if article.isFavourite == false && ArticleManager.sharedInstance.favouriteArticles?.count == 3 {
            return false
        }
        else {
            return true
        }
    }
    
    func formatFavouriteButton() {
        
        if let article = self.currentArticle {
            self.favButton.image = article.isFavourite ? UIImage(named: "favIcon") : UIImage(named: "noFavIcon")
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

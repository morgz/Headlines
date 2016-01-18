//
//  ArticlesTableViewController.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "ArticleCell"

class ArticlesTableViewController: UITableViewController {
    
    enum ArticlesMode: Int {
        case All = 0
        case Favourites
    }
    
    var articles : Results<Article>?
    var favouriteArticles : Results<Article>?
    
    var articlesToDisplay : Results<Article>? {
        get {
            if self.segmentedControl.selectedSegmentIndex == ArticlesMode.Favourites.rawValue {
                return self.favouriteArticles
            }
            else {
                return self.articles
            }
        }
    }
    
    var realmNotification:NotificationToken! //Keep an eye on when our data has changed
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.reloadData()
        
        //If our data changes then reload it.
        self.realmNotification = self.uiRealm.addNotificationBlock { notification, realm in
            self.reloadData()
        }
    }
    
    func reloadData() {
        self.articles = uiRealm.objects(Article).sorted("publishDate", ascending: false)
        self.favouriteArticles = uiRealm.objects(Article).filter("isFavourite == 1")
        
        //Set the title of the segmentedControl to show no. favs
        if let favouriteArticles = self.favouriteArticles {
            self.segmentedControl.setTitle("\(favouriteArticles.count) Favourites", forSegmentAtIndex: ArticlesMode.Favourites.rawValue)
        }
        
        
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func toggleFavourites(sender:UISegmentedControl) {
        self.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let articlesToDisplay = self.articlesToDisplay else {
            return 0
        }
        
        return articlesToDisplay.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ArticleTableViewCell
        
        guard let articlesToDisplay = self.articlesToDisplay else {
            return cell
        }
        
        let article = articlesToDisplay[indexPath.item]
        
        // Configure the cell...
        cell.formatWith(article: article)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 125.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

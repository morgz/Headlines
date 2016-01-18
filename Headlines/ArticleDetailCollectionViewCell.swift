//
//  ArticleDetailCollectionViewCell.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import UIKit

class ArticleDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func formatWith(article article:Article) {
        self.titleLabel.text = article.title
        self.bodyLabel.text = article.bodyText
        //self.categoryLabel.text = article.sectionName
        
//        if let date = article.publishDate {
//            self.dateLabel.text = date.toRelativeString(fromDate: NSDate(), abbreviated: false, maxUnits:2)
//        }
        
        if let urlString = article.imageUrlString {
            self.articleImageView.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
        }
        
    }
    
}

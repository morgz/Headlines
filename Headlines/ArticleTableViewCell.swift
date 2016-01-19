//
//  ArticleTableViewCell.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import UIKit
import SwiftDate
import Kingfisher

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var mainLabel: TopAlignedLabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.categoryLabel.textColor = HeadlineStyleKit.orange()
        self.dateLabel.textColor = HeadlineStyleKit.grey()
        
        //Set our custom fonts
        self.mainLabel.font = HeadlineStyleKit.articleOverviewTitleFont()
        self.categoryLabel.font = HeadlineStyleKit.articleOverviewCategoryFont()
        self.dateLabel.font = HeadlineStyleKit.articleOverviewDateFont()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatWith(article article:Article) {
        
        self.mainLabel.text = article.title
        self.categoryLabel.text = article.sectionName
        
        if let date = article.publishDate, dateString = date.toRelativeString(fromDate: NSDate(), abbreviated: false, maxUnits:2) {
            self.dateLabel.text = dateString + NSLocalizedString(" ago", comment: " ago")
        }
        
        if let urlString = article.imageUrlString {
            self.articleImageView.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
        }
       
    }

}

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
        self.categoryLabel.textColor = UIColor(hexString: "F77600")
        self.dateLabel.textColor = UIColor(hexString: "818B8E")
        
        //Set our custom fonts
        self.mainLabel.font = UIFont(name: "Lato-Regular", size: 16.0)
        self.categoryLabel.font = UIFont(name: "Merriweather-Light", size: 12.0)
        self.dateLabel.font = UIFont(name: "Merriweather-Light", size: 11.0)

        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatWith(article article:Article) {
        
        self.mainLabel.text = article.title
        self.categoryLabel.text = article.sectionName
        
        if let date = article.publishDate {
            self.dateLabel.text = date.toRelativeString(fromDate: NSDate(), abbreviated: false, maxUnits:2)
        }
        
        if let urlString = article.imageUrlString {
            self.articleImageView.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
        }
       
    }

}

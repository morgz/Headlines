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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        
        // Automatically adjusting the insets only works if scrollview is at index 0 of controller :(
        // Not quite right... but will have to do for now.
        let insets = UIEdgeInsets(top: 44.0, left: 0, bottom: 44.0, right: 0)
        self.scrollView.contentInset = insets
        self.scrollView.scrollIndicatorInsets = insets
        
        /**
        Style some shizzle
        */
        self.titleLabel.font = HeadlineStyleKit.articleDetailTitleFont()
        self.bodyLabel.font = HeadlineStyleKit.articleDetailBodyFont()
        
        self.categoryLabel.font = HeadlineStyleKit.articleDetailSubtitleFont()
        self.categoryLabel.textColor = HeadlineStyleKit.orange()

        self.dateLabel.font = HeadlineStyleKit.articleDetailSubtitleFont()
        self.dateLabel.textColor = HeadlineStyleKit.grey()

    }
    
    override func prepareForReuse() {
        self.scrollView.setContentOffset(CGPointMake(0, -self.scrollView.contentInset.top), animated: false)
    }
    
    func formatWith(article article:Article) {
        
        self.titleLabel.text = article.title
        
        // Unfortunately this was too slow
        //self.bodyLabel.attributedText = article.bodyTextAsHtmlAttributedString()
        
        /// 
        //
        //  Set the Body label. Increase the line spacing to make it more readable.
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.5
        
        let attrString = NSMutableAttributedString(string: article.bodyText)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        self.bodyLabel.attributedText = attrString
        
        
        //
        // Now set the other details
        //
        self.categoryLabel.text = article.sectionName
        
        let readTime = "\(Int(round(article.bodyText.readingTime()))) \(NSLocalizedString("mins read", comment: "Time it takes to read in mins"))"

        if let date = article.publishDate, dateString = date.toString(.Custom("EEEE dd/MM/YYYY")) {
            self.dateLabel.text = dateString + "  |  " + readTime
        }
        else {
            self.dateLabel.text = readTime
        }
        
        if let urlString = article.imageUrlString {
            self.articleImageView.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: nil)
        }
        
        
    }
    
}

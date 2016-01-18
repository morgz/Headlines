//
//  HeadlineStyleKit.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import UIKit

class HeadlineStyleKit {
    
    
    /*

    App Colors

    */
    class func orange() -> UIColor {
        return UIColor(hexString: "F77600")
    }
    
    class func grey() -> UIColor {
        return UIColor(hexString: "818B8E")
    }
    
    /*
     Fonts for Article Detail Pages
     
     - returns: fonts
     */
    class func articleDetailTitleFont() -> UIFont? {
        return UIFont(name: "Lato-Regular", size: 25.0)
    }
    
    class func articleDetailBodyFont() -> UIFont? {
        return UIFont(name: "Merriweather-Light", size: 16.0)
    }
    
    class func articleDetailSubtitleFont() -> UIFont? {
        return UIFont(name: "Merriweather-Light", size: 12.0)
    }
    
    
    
    
    /*
    Fonts for Article List Overview
    
    - returns: fonts
    */
    class func articleOverviewTitleFont() -> UIFont? {
        return UIFont(name: "Lato-Regular", size: 16.0)
    }
    
    class func articleOverviewCategoryFont() -> UIFont? {
        return UIFont(name: "Merriweather-Light", size: 12.0)
    }
    
    class func articleOverviewDateFont() -> UIFont? {
        return UIFont(name: "Merriweather-Light", size: 11.0)
    }
    
    
}



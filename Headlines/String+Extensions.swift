//
//  String+Extensions.swift
//  Headlines
//
//  Created by Daniel Morgz on 18/01/2016.
//  Copyright © 2016 Daniel Morgan. All rights reserved.
//

import Foundation

extension String {
    
    func removeHTMLTags(keepParagraphs: Bool = true) -> String {
        
        var string = self
        
        if keepParagraphs {
            string = self.stringByReplacingOccurrencesOfString("</p>", withString: "\n\n")
        }
        
        //Strip all html tags
        return string.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
    
    //Average readers are the majority and only reach around 200 wpm with a typical comprehension of 60%.
    func readingTime() -> Float {
        let words = self.componentsSeparatedByString(" ")
        return max(0.5,Float(words.count)/200.0)
    }
}

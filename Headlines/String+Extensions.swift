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
            string = self.stringByReplacingOccurrencesOfString("</p> <p>", withString: "\n\n")
        }
        
        return string.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
}

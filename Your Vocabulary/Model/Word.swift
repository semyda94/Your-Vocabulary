//
//  Word.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 4/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import Foundation

struct Word {
    
    // MARK: - Vars, lets, outlets
    
    var word: String
    
    var translation: String?
    var definition: String?
    var extraInfo: String?
    var synonym: String?
    var example: String?
    
    // MARK: - initialization
    
    init(_ word: String, withTranslation trans: String?, withDefinition def: String?) {
        self.word = word
        
        if let t = trans {
            self.translation = t
        }
        
        if let d = def {
            self.definition = d
        }
    }
}

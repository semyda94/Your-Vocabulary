//
//  Dictionary.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 4/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import Foundation

struct Dictionary {
    
    // MARK: - Vars, lets, outlets
    
    var name: String
    
    var countOfWords = 0
    var countOfLearnedWords = 0
    
    var words = [Word]()
    
    // MARK: - initialization
    
    init(_ name: String) {
        self.name = name
        
        self.words += [Word("test1", withTranslation: "Translation1", withDefinition: nil),
        Word("test2", withTranslation: "Translation2", withDefinition: nil),
        Word("test3", withTranslation: nil, withDefinition: "Definition3")]
    }
    
}

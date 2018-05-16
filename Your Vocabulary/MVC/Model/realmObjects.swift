//
//  realmObjects.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 16/05/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWord: Object {
    
    @objc dynamic var isLearned = false
    
    //Properties content
    @objc dynamic var word = NSLocalizedString("Unknown", comment: "Name of word during init")
    
    let translations = List<String?>()
    let definitions = List<String?>()
    let extraInfos = List<String?>()
    let synonyms = List<String?>()
    let examples = List<String?>()
    
    //Dates
    @objc dynamic var dateOfCreation = Date()
    @objc dynamic var dateOfLastChanges = Date()
    
}

class RealmDictionary: Object {
    @objc dynamic var name = NSLocalizedString("Unknown", comment: "Name of dictionary during init")
    
    let words = List<RealmWord>()
    @objc dynamic var numberOfLearnedWords = 0
    
    // Dates
    @objc dynamic var dateOfCreation = Date()
    @objc dynamic var dateOfLastChanges = Date()
    
    //Flags of setted properties
    
    @objc dynamic var isTranslation = false
    @objc dynamic var isDefinition = false
    @objc dynamic var isExtraInfo = false
    @objc dynamic var isSynonym = false
    @objc dynamic var isExample = false
    
}

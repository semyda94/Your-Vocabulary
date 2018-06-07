//
//  realmObjects.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 16/05/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Implementation of realm object for "Dictionary"

/***************************************************************
 ******** Implementation of realm object for "Dictionary" ******
 ***************************************************************/
class RealmDictionary: Object {
    @objc dynamic var name = NSLocalizedString("Unknown", comment: "Name of dictionary during init")
    
    //List of words associated with dictionary object
    var words = List<RealmWord>()
    
    //List of infos about quizzes associated with dictionary object
    var quizesInfo = List<RealmQuizInfo>()
    
    /****************************************************************************************
    **********************Number of words that user learned for dictionary*******************
    *****This property was entered for save time of calculation of number learned words.*****
    *****Otherwise we should walk through whole list of words for dictionary and check ******
    ************************* his "isLearned" property. *************************************
    */
    @objc dynamic var numberOfLearnedWords = 0
    
    // Date of creation dictionary and date of last changes at dictionary(include words associated with dictionary).
    @objc dynamic var dateOfCreation = Date()
    @objc dynamic var dateOfLastChanges = Date()
    
   
   // Properties type of boolean that show turned on properties for dictionary
    @objc dynamic var isTranslation = false
    @objc dynamic var isDefinition = false
    @objc dynamic var isExtraInfo = false
    @objc dynamic var isSynonym = false
    @objc dynamic var isExample = false
    
}

// MARK: - Implementation of realm object for "Word"

/*********************************************************
 ******** Implementation of realm object for "Word" ******
 *********************************************************/

class RealmWord: Object {
    
    // Property that keep state of word is learned or not)
    @objc dynamic var isLearned = false
    
    //Below presented properties of word
    
    //Word
    @objc dynamic var word = NSLocalizedString("Unknown", comment: "Name of word during init")
    
    //List of properties for word. Each of property contains list of associated properties.
    let translations = List<String?>()
    let definitions = List<String?>()
    let extraInfos = List<String?>()
    let synonyms = List<String?>()
    let examples = List<String?>()
    
    //Date of creation word and date of last changes at word
    @objc dynamic var dateOfCreation = Date()
    @objc dynamic var dateOfLastChanges = Date()
    
}

// MARK: -Implementation of realm object for "Quiz tests"
/***************************************************************
 ******** Implementation of realm object for "Quiz tests" ******
 ***************************************************************/
class RealmQuizInfo: Object {
    // Present number of answers for quiz
    @objc dynamic var numberOfAnswers = 0
    
    // Present number of correct answers for quiz
    @objc dynamic var numberOfCorrectAnswers = 0
    
    //Property present date of property
    @objc dynamic var dateOfCreation = Date()
}

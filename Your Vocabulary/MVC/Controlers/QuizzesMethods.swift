//
//  QuizzesMethods.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 27/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import Foundation

protocol QuizzesMethods {
}

extension QuizzesMethods {
    
    func getElement(baseOn typeElement: DictionaryElements, forWord word: RealmWord) -> String?{
        switch typeElement {
        case .word:
            return word.word
        case .translation:
            for translation in word.translations {
                guard let element = translation else { break }
                return element
            }
            return nil
            
        case .definition:
            for definition in word.definitions {
                guard let element = definition else { break }
                return element
            }
            return nil
            
        case .extraInfo:
            for extraInfo in word.extraInfos {
                guard let element = extraInfo else { break }
                return element
            }
            return nil
            
        case .synonym:
            for synonym in word.synonyms {
                guard let element = synonym else { break }
                return element
            }
            return nil
            
        case .example:
            
            for example in word.examples {
                guard let element = example else { break }
                return element
            }
            return nil
        }
    }
}

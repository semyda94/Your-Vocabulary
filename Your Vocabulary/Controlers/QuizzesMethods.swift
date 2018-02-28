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
    func getElement(baseOn typeElement: DictionaryElements, forWord word: Word) -> String?{
        switch typeElement {
        case .word:
            return word.word
        case .translation:
            guard let translations = word.translations?.allObjects as? [Translation] else { return nil}
            
            for translation in translations {
                guard let element = translation.text else { break }
                return element
            }
            return nil
            
        case .definition:
            guard let definitions = word.definitions?.allObjects as? [Definition] else { return nil}
            
            for definition in definitions {
                guard let element = definition.text else { break }
                return element
            }
            return nil
            
        case .extraInfo:
            guard let extraInfos = word.extraInfos?.allObjects as? [ExtraInfo] else { return nil}
            
            for extraInfo in extraInfos {
                guard let element = extraInfo.text else { break }
                return element
            }
            return nil
            
        case .synonym:
            guard let synonyms = word.synonyms?.allObjects as? [Synonym] else { return nil}
            
            for synonym in synonyms {
                guard let element = synonym.text else { break }
                return element
            }
            return nil
            
        case .example:
            guard let examples = word.examples?.allObjects as? [Example] else { return nil}
            
            for example in examples {
                guard let element = example.text else { break }
                return element
            }
            return nil
        }
    }
}

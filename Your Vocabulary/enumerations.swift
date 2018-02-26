//
//  enumerations.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 26/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import Foundation

// MARK: - Dictionary elements
enum DictionaryElements:String {
    case word = "Word"
    case translation = "Translation"
    case definition = "Definition"
    case extraInfo = "Extra information"
    case synonym = "Synonym"
    case example = "Example"
}

// MARK: - Types of quizzes
enum QuizzesTypes:String {
    case seeking = "Seeking"
    case seekingByTime = "Seeking by time"
    case matching = "Matching"
    case matchingByTime = "Matching by time"
    case spelling = "Spelling"
    case spellingByTime = "Spelling by time"
    case none = "none"
}

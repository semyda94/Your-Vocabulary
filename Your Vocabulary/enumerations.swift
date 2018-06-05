//
//  enumerations.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 26/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import Foundation
import UIKit

struct LocalizedString: ExpressibleByStringLiteral, Equatable {
    
    let v: String
    
    init(key: String) {
        self.v = NSLocalizedString(key, comment: "")
    }
    init(localized: String) {
        self.v = localized
    }
    init(stringLiteral value:String) {
        self.init(key: value)
    }
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(key: value)
    }
    init(unicodeScalarLiteral value: String) {
        self.init(key: value)
    }
}

func ==(lhs:LocalizedString, rhs:LocalizedString) -> Bool {
    return lhs.v == rhs.v
}

// MARK: - Dictionary elements
enum DictionaryElements: LocalizedString {
    case word = "Word"
    case translation = "Translation"
    case definition = "Definition"
    case extraInfo = "Extra information"
    case synonym = "Synonym"
    case example = "Example"
    
    var localizedString: String {
        return self.rawValue.v
    }
    
    init?(localizedString: String) {
        self.init(rawValue: LocalizedString(localized: localizedString))
    }
}

// MARK: - Types of quizzes
enum QuizzesTypes: LocalizedString {
    case seeking = "Seeking"
    case seekingByTime = "Seeking by time"
    case matching = "Matching"
    case matchingByTime = "Matching by time"
    case spelling = "Spelling"
    case spellingByTime = "Spelling by time"
    case none = "none"
    
    var localizedString: String {
        return self.rawValue.v
    }
    
    init?(localizedString: String) {
        self.init(rawValue: LocalizedString(localized: localizedString))
    }
}

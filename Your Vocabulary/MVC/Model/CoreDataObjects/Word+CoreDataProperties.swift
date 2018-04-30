//
//  Word+CoreDataProperties.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 8/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var dateCreation: NSDate?
    @NSManaged public var isLearned: Bool
    @NSManaged public var word: String?
    @NSManaged public var dateOfLastChanges: NSDate?
    @NSManaged public var definitions: NSSet?
    @NSManaged public var dictionary: Dictionary?
    @NSManaged public var examples: NSSet?
    @NSManaged public var extraInfos: NSSet?
    @NSManaged public var synonyms: NSSet?
    @NSManaged public var translations: NSSet?

}

// MARK: Generated accessors for definitions
extension Word {

    @objc(addDefinitionsObject:)
    @NSManaged public func addToDefinitions(_ value: Definition)

    @objc(removeDefinitionsObject:)
    @NSManaged public func removeFromDefinitions(_ value: Definition)

    @objc(addDefinitions:)
    @NSManaged public func addToDefinitions(_ values: NSSet)

    @objc(removeDefinitions:)
    @NSManaged public func removeFromDefinitions(_ values: NSSet)

}

// MARK: Generated accessors for examples
extension Word {

    @objc(addExamplesObject:)
    @NSManaged public func addToExamples(_ value: Example)

    @objc(removeExamplesObject:)
    @NSManaged public func removeFromExamples(_ value: Example)

    @objc(addExamples:)
    @NSManaged public func addToExamples(_ values: NSSet)

    @objc(removeExamples:)
    @NSManaged public func removeFromExamples(_ values: NSSet)

}

// MARK: Generated accessors for extraInfos
extension Word {

    @objc(addExtraInfosObject:)
    @NSManaged public func addToExtraInfos(_ value: ExtraInfo)

    @objc(removeExtraInfosObject:)
    @NSManaged public func removeFromExtraInfos(_ value: ExtraInfo)

    @objc(addExtraInfos:)
    @NSManaged public func addToExtraInfos(_ values: NSSet)

    @objc(removeExtraInfos:)
    @NSManaged public func removeFromExtraInfos(_ values: NSSet)

}

// MARK: Generated accessors for synonyms
extension Word {

    @objc(addSynonymsObject:)
    @NSManaged public func addToSynonyms(_ value: Synonym)

    @objc(removeSynonymsObject:)
    @NSManaged public func removeFromSynonyms(_ value: Synonym)

    @objc(addSynonyms:)
    @NSManaged public func addToSynonyms(_ values: NSSet)

    @objc(removeSynonyms:)
    @NSManaged public func removeFromSynonyms(_ values: NSSet)

}

// MARK: Generated accessors for translations
extension Word {

    @objc(addTranslationsObject:)
    @NSManaged public func addToTranslations(_ value: Translation)

    @objc(removeTranslationsObject:)
    @NSManaged public func removeFromTranslations(_ value: Translation)

    @objc(addTranslations:)
    @NSManaged public func addToTranslations(_ values: NSSet)

    @objc(removeTranslations:)
    @NSManaged public func removeFromTranslations(_ values: NSSet)

}

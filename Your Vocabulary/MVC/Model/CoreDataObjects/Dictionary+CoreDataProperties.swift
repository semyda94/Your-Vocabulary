//
//  Dictionary+CoreDataProperties.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 20/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//
//

import Foundation
import CoreData


extension Dictionary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dictionary> {
        return NSFetchRequest<Dictionary>(entityName: "Dictionary")
    }

    @NSManaged public var dateOfCreation: NSDate?
    @NSManaged public var dateOfLastChanges: NSDate?
    @NSManaged public var isDefinition: Bool
    @NSManaged public var isExample: Bool
    @NSManaged public var isExtraInfo: Bool
    @NSManaged public var isSynonym: Bool
    @NSManaged public var isTranslation: Bool
    @NSManaged public var name: String?
    @NSManaged public var numberofLearned: Int32
    @NSManaged public var numberOfWords: Int32
    @NSManaged public var words: NSOrderedSet?
    @NSManaged public var tests: NSOrderedSet?

}

// MARK: Generated accessors for words
extension Dictionary {

    @objc(insertObject:inWordsAtIndex:)
    @NSManaged public func insertIntoWords(_ value: Word, at idx: Int)

    @objc(removeObjectFromWordsAtIndex:)
    @NSManaged public func removeFromWords(at idx: Int)

    @objc(insertWords:atIndexes:)
    @NSManaged public func insertIntoWords(_ values: [Word], at indexes: NSIndexSet)

    @objc(removeWordsAtIndexes:)
    @NSManaged public func removeFromWords(at indexes: NSIndexSet)

    @objc(replaceObjectInWordsAtIndex:withObject:)
    @NSManaged public func replaceWords(at idx: Int, with value: Word)

    @objc(replaceWordsAtIndexes:withWords:)
    @NSManaged public func replaceWords(at indexes: NSIndexSet, with values: [Word])

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: Word)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: Word)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSOrderedSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSOrderedSet)

}

// MARK: Generated accessors for tests
extension Dictionary {

    @objc(insertObject:inTestsAtIndex:)
    @NSManaged public func insertIntoTests(_ value: TestInfo, at idx: Int)

    @objc(removeObjectFromTestsAtIndex:)
    @NSManaged public func removeFromTests(at idx: Int)

    @objc(insertTests:atIndexes:)
    @NSManaged public func insertIntoTests(_ values: [TestInfo], at indexes: NSIndexSet)

    @objc(removeTestsAtIndexes:)
    @NSManaged public func removeFromTests(at indexes: NSIndexSet)

    @objc(replaceObjectInTestsAtIndex:withObject:)
    @NSManaged public func replaceTests(at idx: Int, with value: TestInfo)

    @objc(replaceTestsAtIndexes:withTests:)
    @NSManaged public func replaceTests(at indexes: NSIndexSet, with values: [TestInfo])

    @objc(addTestsObject:)
    @NSManaged public func addToTests(_ value: TestInfo)

    @objc(removeTestsObject:)
    @NSManaged public func removeFromTests(_ value: TestInfo)

    @objc(addTests:)
    @NSManaged public func addToTests(_ values: NSOrderedSet)

    @objc(removeTests:)
    @NSManaged public func removeFromTests(_ values: NSOrderedSet)

}

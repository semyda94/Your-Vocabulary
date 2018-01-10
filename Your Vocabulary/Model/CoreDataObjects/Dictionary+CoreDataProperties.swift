//
//  Dictionary+CoreDataProperties.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 8/01/18.
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
    @NSManaged public var name: String?
    @NSManaged public var numberofLearned: Int32
    @NSManaged public var numberOfWords: Int32
    @NSManaged public var words: NSSet?

}

// MARK: Generated accessors for words
extension Dictionary {

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: Word)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: Word)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)

}

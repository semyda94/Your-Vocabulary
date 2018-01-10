//
//  Word+CoreDataProperties.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 8/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var dataCreation: NSDate?
    @NSManaged public var definition: String?
    @NSManaged public var example: String?
    @NSManaged public var extraInfo: String?
    @NSManaged public var isLearned: Bool
    @NSManaged public var synonym: String?
    @NSManaged public var translation: String?
    @NSManaged public var word: String?
    @NSManaged public var dictionary: Dictionary?

}

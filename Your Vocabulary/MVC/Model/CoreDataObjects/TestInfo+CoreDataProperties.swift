//
//  TestInfo+CoreDataProperties.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 20/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//
//

import Foundation
import CoreData


extension TestInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestInfo> {
        return NSFetchRequest<TestInfo>(entityName: "TestInfo")
    }

    @NSManaged public var dateOfCreation: NSDate?
    @NSManaged public var numberOfAnswers: Int32
    @NSManaged public var numberOfCorrectAnswers: Int32
    @NSManaged public var dictonary: Dictionary?

}

//
//  ExtraInfo+CoreDataProperties.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 2/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//
//

import Foundation
import CoreData


extension ExtraInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExtraInfo> {
        return NSFetchRequest<ExtraInfo>(entityName: "ExtraInfo")
    }

    @NSManaged public var text: String?
    @NSManaged public var word: Word?

}

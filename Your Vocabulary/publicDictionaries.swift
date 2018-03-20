//
//  publicDictionaries.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 21/03/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import Foundation
import CoreData

let entities : [String : NSFetchRequest<NSFetchRequestResult>] = [ "Dictionary" : NSFetchRequest(entityName: "Dictionary"),
                                                                   "Definition" : NSFetchRequest(entityName: "Definition"),
                                                                   "Example" : NSFetchRequest(entityName: "Example"),
                                                                   "ExtraInfo" : NSFetchRequest(entityName: "ExtraInfo"),
                                                                   "Synonym" : NSFetchRequest(entityName: "Synonym"),
                                                                   "TestInfo" : NSFetchRequest(entityName: "TestInfo"),
                                                                   "Translation" : NSFetchRequest(entityName: "Translation"),
                                                                   "Word" : NSFetchRequest(entityName: "Word")]

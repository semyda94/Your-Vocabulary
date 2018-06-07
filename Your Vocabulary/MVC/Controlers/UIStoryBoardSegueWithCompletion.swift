//
//  UIStoryBoardSegueWithCompletion.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 23/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import Foundation

/**********************************************************************************************************************
 ****** Class inhireted from UIStoryboardSegue that provide opportunity to have completion function after segue. ******
 **********************************************************************************************************************/
class UIStoryboardSegueWithCompletion: UIStoryboardSegue {
    var completion: (() -> Void)?
    
    override func perform() {
        super.perform()
        if let completion = completion {
            completion()
        }
    }
}

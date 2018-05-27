//
//  DayOfWeekButton.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 25/05/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

class DayOfWeekButton: UIButton {

    
    var isChosen = false {
        didSet {
            if isChosen {
                self.setBackgroundImage(#imageLiteral(resourceName: "active_d"), for: .normal)
                self.tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
            } else {
                self.setBackgroundImage(#imageLiteral(resourceName: "inactive_d"), for: .normal)
                self.tintColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.4588235294, alpha: 1)
            }
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

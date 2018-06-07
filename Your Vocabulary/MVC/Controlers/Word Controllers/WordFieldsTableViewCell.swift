//
//  WordFieldsTableViewCell.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 2/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

class WordFieldsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // when cell was appeared then set visual properties for view.
        textView.layer.borderColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 0.5)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        // Initialization code
    }
    
}

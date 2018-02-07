//
//  WordSaveCancelButtonsTableViewCell.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 3/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

protocol SaveCancelWordTableContentDelegate: class {
    func saveContent()
    func cancelChanges()
}

class WordSaveCancelButtonsTableViewCell: UITableViewCell {

    weak var delegate: SaveCancelWordTableContentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func saveContent(_ sender: UIButton) {
        delegate?.saveContent()
    }
    
    @IBAction func cancelChanges(_ sender: Any) {
        delegate?.cancelChanges()
    }
    
    
}

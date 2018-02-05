//
//  WordAddFieldButtonTableViewCell.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 3/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

//
protocol AddNewFieldDelegate: class {
    func addFieldBeforeRow(_ row: UITableViewCell)
}

class WordAddFieldButtonTableViewCell: UITableViewCell {

    weak var delegate: AddNewFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    @IBAction func addNewField(_ sender: UIButton) {
        delegate?.addFieldBeforeRow(self)
    }
}

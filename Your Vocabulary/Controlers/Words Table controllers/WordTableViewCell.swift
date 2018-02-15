//
//  WordTableViewCell.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 16/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var word: Word? {
        didSet {
            guard let w = word else { return }
            
            wordLabel.text = w.word
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var stackOfSubProperties: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var learnedCheckBox: BEMCheckBox!
    
    
    // MARK: - Life cycle
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  StatisticTableViewCell.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 12/03/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

class StatisticTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
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

//
//  DictionaryTableViewCell.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 14/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

class DictionaryTableViewCell: UITableViewCell {

    // MARK: - Poperties
    
    var dictionary: Dictionary? {
        didSet {
            guard let currentDictionary = dictionary else { return }
            
            titleLabel.text = currentDictionary.name
          //  thumbnailLabel.text = String(currentDictionary.name!.first!).uppercased()
            numberOfWordsLabel.text = "Count of words: \( currentDictionary.numberOfWords)"
            numberOfLearnedWordsLabel.text = "learned words: \(currentDictionary.numberofLearned)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM"
            dataOfCreationLabel.text = "\(dateFormatter.string(from: currentDictionary.dateOfLastChanges! as Date))"
        }
    }
    
    fileprivate let thumbnailLabel = UILabel()
    
    // MARK: - Outlets
    
    @IBOutlet weak var thumbnailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataOfCreationLabel: UILabel!
    @IBOutlet weak var numberOfWordsLabel: UILabel!
    @IBOutlet weak var numberOfLearnedWordsLabel: UILabel!
    
    
    // MARK: - Life cycle of view
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        thumbnailLabel.textAlignment = .center
        thumbnailLabel.bounds = thumbnailView.bounds
        thumbnailLabel.layer.cornerRadius = 0.5 * thumbnailLabel.bounds.size.width
        thumbnailLabel.layer.borderWidth = 1.0
        
        thumbnailLabel.textColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
        thumbnailLabel.font = UIFont.systemFont(ofSize: 30)
      //  thumbnailLabel.attributedText = NSAttributedString.
        thumbnailLabel.layer.borderColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
        thumbnailLabel.center = thumbnailView.center
        
        thumbnailView.addSubview(thumbnailLabel)
        thumbnailView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

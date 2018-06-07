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
    
    /**************************************************************************
     ****** After setting of dictionary properties set cell information  ******
     **************************************************************************/
    var dictionary: RealmDictionary? {
        didSet {
            guard let dictionary = dictionary else { return }
            
            let formatNumberOfWords = NSLocalizedString("Count of words: %d", comment: "Show count of words for dictionary")
            let formatNumberOfLearnedWords = NSLocalizedString("Learned words: %d", comment: "Show count of learned words for dictionary")
            
            thumbnailLabel.text = String(dictionary.name.first!).uppercased()
            titleLabel.text = dictionary.name
            
            
           numberOfWordsLabel.text = String.localizedStringWithFormat(formatNumberOfWords, dictionary.words.count)
            numberOfLearnedWordsLabel.text = String.localizedStringWithFormat(formatNumberOfLearnedWords, dictionary.numberOfLearnedWords)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM"
            dataOfCreationLabel.text = "\(dateFormatter.string(from: dictionary.dateOfLastChanges))"
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
        
        titleLabel.text = NSLocalizedString("Unknown", comment: "Name for dictionary when user didn't set name")
        
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


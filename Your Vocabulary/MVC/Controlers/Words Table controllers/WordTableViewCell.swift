//
//  WordTableViewCell.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 16/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift

class WordTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    /***************************
     ****** Word for cell ******
     ***************************/
    var currentWord: RealmWord? {
        didSet {
            guard let currentWord = currentWord else { return }
            
            wordLabel.text = currentWord.word
            learnedCheckBox.on = currentWord.isLearned
            
            for translation in currentWord.translations {
                guard let text = translation else { break }
                descriptionLabel.text = "\t \(text)"
                return
            }
            
            for definition in currentWord.definitions {
                guard let text = definition else { break }
                descriptionLabel.text = "\t \(text)"
                return
            }
            
        }
    }
    
    var currentDictionary: RealmDictionary?
    
    let realm = try! Realm()
 
    
    // MARK: - Outlets
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var learnedCheckBox: BEMCheckBox!
    
    // MARK: - IBActions
    
    /*************************************************
     ****** Changing of isLearned flag for word ******
     *************************************************/
    @IBAction func wasTappedLearnedMark(_ sender: BEMCheckBox) {
       
        guard let currentWord = currentWord else { return }

        try! realm.write {
            currentWord.isLearned = sender.on
            if currentWord.isLearned {
                currentDictionary?.numberOfLearnedWords += 1
            } else {
                currentDictionary?.numberOfLearnedWords -= 1
            }
        }
    }
    
    
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

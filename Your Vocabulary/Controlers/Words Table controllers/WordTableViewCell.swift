//
//  WordTableViewCell.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 16/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class WordTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var currentWord: Word? {
        didSet {
            guard let w = currentWord else { return }
            
            wordLabel.text = w.word
            
            if let definition =  w.definitions?.allObjects as? [Definition] {
                for d in definition {
                    guard let text = d.text else { break }
                    descriptionLabel.text = "\t \(text)"
                    return
                }
            }
            
            if let translations = w.translations?.allObjects as? [Translation] {
                for t in translations {
                    guard let text = t.text else { break }
                    descriptionLabel.text = text
                    return
                }
            }
            
            learnedCheckBox.on = w.isLearned
            
            
        }
    }
    
    var managetContext: NSManagedObjectContext? {
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate.persistentContainer.viewContext
    }
 
    
    // MARK: - Outlets
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var learnedCheckBox: BEMCheckBox!
    
    // MARK: - IBActions
    
    @IBAction func wasTappedLearnedMark(_ sender: BEMCheckBox) {
        guard let context = managetContext else { return }
        let word = context.object(with: currentWord!.objectID) as! Word

        word.isLearned = sender.on
        
        print("learned mark for word \(word.word!) was changed to \(word.isLearned)")
        /*childEntity.dictionary?.numberofLearned = sender.on ? childEntity.dictionary!.numberofLearned + 1 : childEntity.dictionary!.numberofLearned - 1
         */
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error during updating learned mark status \(error), \(error.userInfo)")
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

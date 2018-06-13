//
//  QuizzesCollectionViewCell.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 8/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit



class QuizzesCollectionViewCell: UICollectionViewCell {
    
    var quiz : (name: QuizzesTypes, thumbnail: UIImage)! {
        didSet {
            if quiz != nil {
                testLabel.text = quiz.name.localizedString
            }
        }
    }
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func awakeFromNib() {
    }
    
}

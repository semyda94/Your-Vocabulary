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
                quizTitleLabel.text = quiz.name.localizedString
                
                switch quiz.name {
                case .seeking:
                    quizzBGView.backgroundColor = #colorLiteral(red: 0.6941176471, green: 0.8039215686, blue: 0.9411764706, alpha: 1)
                    quizImage.image = #imageLiteral(resourceName: "cat")
                    
                    quizDescription.text = NSLocalizedString("Quiz where it providing a question and you must choose one of four suggested answers", comment: "Description of seeking quiz")
                
                default:
                    
                    break;
                }
            }
        }
    }
    
    @IBOutlet weak var quizzBGView: UIView!
    @IBOutlet weak var quizImage: UIImageView!

    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizDescription: UILabel!
    
    override func awakeFromNib() {
        
        quizzBGView.layer.cornerRadius = 15.0
    }
    
}

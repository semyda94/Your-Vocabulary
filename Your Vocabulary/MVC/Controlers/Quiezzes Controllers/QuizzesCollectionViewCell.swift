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
                    quizzBGView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    quizImage.image = #imageLiteral(resourceName: "seeking_icon")
                    
                    quizDescription.text = NSLocalizedString("Quiz that providing a question and you must choose one of four suggested answers", comment: "Description of seeking quiz")
                case .seekingByTime:
                    quizzBGView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    quizImage.image = #imageLiteral(resourceName: "seeking_by_time_icon")
                    
                    quizDescription.text = NSLocalizedString("Quiz that providing a question and you must choose one of four suggested answers, however time is limited", comment: "Description of seeking quiz by time")
                case .matching:
                    quizzBGView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    quizImage.image = #imageLiteral(resourceName: "matching_icon")
                    
                    quizDescription.text = NSLocalizedString("Quiz where you should relate the presented pairs", comment: "Description of matching quiz")
                case .matchingByTime:
                    quizzBGView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    quizImage.image = #imageLiteral(resourceName: "matching_by_time_icon")
                    
                    quizDescription.text = NSLocalizedString("Quiz where you should relate the presented pairs, however time is limited", comment: "Description of matching quiz by time")
                case .spelling:
                    quizzBGView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    quizImage.image = #imageLiteral(resourceName: "spelling_icon")
                    
                    quizDescription.text = NSLocalizedString("Quiz, where you should write a right spelled answer for presented option", comment: "Description of spelling quiz")
                case .spellingByTime:
                    quizzBGView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    quizImage.image = #imageLiteral(resourceName: "spelling_by_time_icon")
                    
                    quizDescription.text = NSLocalizedString("Quiz, where you should write a right spelled answer for presented option, however time is limited", comment: "Description of spelling quiz by time")
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

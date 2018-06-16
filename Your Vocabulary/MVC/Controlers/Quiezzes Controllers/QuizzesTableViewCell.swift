//
//  QuizzesTableViewCell.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 13/06/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift

protocol QuizWasSelected: class {
    func quizWasSelected(withForQuizType quizType: QuizzesTypes)
}

class QuizzesTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    weak var delegateQuizWasSelected: QuizWasSelected?
    
    var quizzes = [(name: QuizzesTypes, thumbnail: UIImage)]() {
        didSet {
            quizzesCollection.reloadData()
        }
    }
    
    fileprivate let realm = try! Realm()
    // MARK: - Outlets
    
    @IBOutlet weak var quizzesCollection: UICollectionView!
    
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        quizzesCollection.delegate = self
        quizzesCollection.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        var textForLabel = ""
        
        for quiz in quizzes {
            textForLabel = textForLabel + " " + quiz.name.localizedString
        }
        
    }
}

// MARK: - UICollectionViewDataSource
extension QuizzesTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCell", for: indexPath) as! QuizzesCollectionViewCell
        cell.contentView.layer.cornerRadius = 10.0
        cell.quiz = quizzes[indexPath.row]
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension QuizzesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.height, height: frame.height)
    }
}

// MARK: - UICollectionViewDelegate
extension QuizzesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! QuizzesCollectionViewCell
        
        
        delegateQuizWasSelected?.quizWasSelected(withForQuizType: cell.quiz.name)
        
    }
}



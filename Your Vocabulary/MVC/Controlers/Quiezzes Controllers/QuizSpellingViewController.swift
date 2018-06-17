//
//  QuizSpellingViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 25/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

/***********************************************************
 ********This controller is't using at current version******
 **********************************************************/

import UIKit

class QuizSpellingViewController: UIViewController, QuizzesMethods {

    // MARK: - Outlets
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    
    var countOfAnswers = 0
    var countOfCorrectAnswers = 0
    let dateOfQuiz = Date()
    
    // MARK: - Actions
    
    
    
    // MARK: - Properties
    
    var chosenParametrs: (questionType: DictionaryElements, answerType: DictionaryElements)?
    
    var dictionary : RealmDictionary?
    
    fileprivate var questionPairs = [(question: String, answer: String)]()
    fileprivate var currentPair: (question: String?, answer: String?)
    
    // MARK: - Methods
    
    @objc fileprivate func tipWasTapped() {
        print("Test of tip tapped")
        
        guard let question = questionLabel.text?.lowercased(), let answer = answerField.text?.lowercased() else { return }
        
        var indexOfNextCharacterAfterTip = question.startIndex
        var newAnswer = ""
        
        for (index, character) in answer.enumerated() {
            if character == question[question.index(question.startIndex, offsetBy: index)] {
                
                print("character '\(character)' at position \(index) was matched")
                indexOfNextCharacterAfterTip = question.index(question.startIndex, offsetBy: index)
                newAnswer.append(question[question.index(question.startIndex, offsetBy: index)])
            } else {
                print("character '\(character)' at position \(index) wasn't matched")
                break
            }
        }
        
        if newAnswer.count == 0 {
            let tipCharacter = question[question.startIndex]
            print("Tip character:\(tipCharacter)")
            newAnswer.append(tipCharacter)
        } else if indexOfNextCharacterAfterTip != question.index(before: question.endIndex) {
            let tipCharacter = question[question.index(indexOfNextCharacterAfterTip, offsetBy: 1)]
            
            print("Tips character:\(tipCharacter)")
            newAnswer.append(tipCharacter)
        }
        
        answerField.text = newAnswer
    }
    
    fileprivate func prepareView() {
        let tip = UIBarButtonItem(image: #imageLiteral(resourceName: "bulb"), style: .plain, target: self, action: #selector(tipWasTapped))
        navigationItem.setRightBarButton(tip, animated: true)
    }
    
    fileprivate func formQuestions() {
        guard let parametrs = chosenParametrs, let dictionary = dictionary else { return }
        
        for word in dictionary.words {
            guard let question =
                getElement(baseOn: parametrs.questionType, forWord: word), let answer = getElement(baseOn: parametrs.answerType, forWord: word) else { continue }
            
            questionPairs.append((question, answer))
        }
    }
    
    fileprivate func setQuestion() {
        let randomQuestionPosition = questionPairs.count.getRandom()
        
        currentPair.question = questionPairs[randomQuestionPosition].question
        currentPair.answer = questionPairs[randomQuestionPosition].answer
        
        questionPairs.remove(at: randomQuestionPosition)
        
        questionLabel.text = currentPair.question
        updateProgressBarProgress()
    }
    
    fileprivate func finishQuiz() {
        let alertController = UIAlertController(title: "Done", message: "Finish quiz?", preferredStyle: .alert)
        
        alertController.view.tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
        let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.737254902, blue: 0.7058823529, alpha: 1)
        
        let restartGame = UIAlertAction(title: "New game", style: .default) { (_) in
            self.formQuestions()
            self.setQuestion()
            self.updateProgressBarProgress()
        }
        
        alertController.addAction(restartGame)
        
        let quit = UIAlertAction(title: "Quit", style: .default) { (_) in
            self.performSegue(withIdentifier: "unwindFinishSpellingQuiz", sender: self)
        }
        alertController.addAction(quit)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func updateProgressBarProgress() {
        progressBar.setProgress(1 / Float(questionPairs.count), animated: true)
    }
    
    // MARK: View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerField.delegate = self
        
        prepareView()
        
        formQuestions()
        
        setQuestion()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITextFieldDelegate
extension QuizSpellingViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        countOfAnswers += 1
        if textField.text?.lowercased() == currentPair.answer?.lowercased() {
            countOfCorrectAnswers += 1
            if questionPairs.count > 0 {
                setQuestion()
            } else {
                finishQuiz()
            }
            textField.text = nil
            return true
        }
        return false
        
    }
    
}

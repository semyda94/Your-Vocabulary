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
    
    @IBOutlet weak var timerLabel: UILabel!
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
    
    var byTime = false
    
    fileprivate var questionPairs = [(question: String, answer: String)]()
    fileprivate var currentPair: (question: String?, answer: String?)
    
    fileprivate var seconds = 15.0 {
        didSet {
            timerLabel.text = "\(Int(seconds))"
        }
    }
    fileprivate var roundTimer: Timer!
    
    // MARK: - Methods
    
    @objc fileprivate func tipWasTapped() {
        print("Test of tip tapped")
        
        guard let answerAtSistem = currentPair.answer?.lowercased(), let usersAnswer = answerField.text?.lowercased() else { return }
        
        var indexOfNextCharacterAfterTip = answerAtSistem.startIndex
        var newAnswer = ""
        
        for (index, character) in usersAnswer.enumerated() {
            if character == answerAtSistem[answerAtSistem.index(answerAtSistem.startIndex, offsetBy: index)] {
                
                print("character '\(character)' at position \(index) was matched")
                indexOfNextCharacterAfterTip = answerAtSistem.index(answerAtSistem.startIndex, offsetBy: index)
                newAnswer.append(answerAtSistem[answerAtSistem.index(answerAtSistem.startIndex, offsetBy: index)])
            } else {
                print("character '\(character)' at position \(index) wasn't matched")
                break
            }
        }
        
        if newAnswer.count == 0 {
            let tipCharacter = answerAtSistem[answerAtSistem.startIndex]
            print("Tip character:\(tipCharacter)")
            newAnswer.append(tipCharacter)
        } else if indexOfNextCharacterAfterTip != answerAtSistem.index(before: answerAtSistem.endIndex) {
            let tipCharacter = answerAtSistem[answerAtSistem.index(indexOfNextCharacterAfterTip, offsetBy: 1)]
            
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
        if questionPairs.count <= 0 {
            roundTimer.invalidate()
            finishQuiz()
            return
        }
        
        updateProgressBarProgress()
        let randomQuestionPosition = questionPairs.count.getRandom()
        
        currentPair.question = questionPairs[randomQuestionPosition].question
        currentPair.answer = questionPairs[randomQuestionPosition].answer
        
        questionPairs.remove(at: randomQuestionPosition)
        
        questionLabel.text = currentPair.question
    }
    
    fileprivate func finishQuiz() {
        if byTime {
            roundTimer.invalidate()
        }
        
        let grade = 1.0 / (Float(countOfAnswers) / Float(countOfCorrectAnswers))
        var alertTitle : String!
        var alertMessage : String!
        
        print("Grade \(grade * 100.0)%");
        
        if grade >= 0.90 {
            alertTitle = NSLocalizedString("Excellent", comment: "Title for finish alert controller when user's grade above 90%")
            alertMessage = NSLocalizedString("Excellent, your knowledge is great, keep adding new words and expand your vocabulary", comment: "Message for finish alert controller when user's grade above 90%")
        } else if grade >= 0.75 {
            alertTitle = NSLocalizedString("Good", comment: "Title for finish alert controller when user's grade above 75%")
            alertMessage = NSLocalizedString("Your results are good enough, a little more practice and your knowledge will be excellent", comment: "Message for finish alert controller when user's grade above 75%")
        } else {
            alertTitle = NSLocalizedString("Keep going", comment: "Title for finish alert controller when user's grade under 75%")
            alertMessage = NSLocalizedString("Continue to work in the same direction and your results will be improving with every attempt!", comment: "Message for finish alert controller when user's grade under 75%")
        }
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alertController.view.tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
        let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.737254902, blue: 0.7058823529, alpha: 1)
        
        let restartGame = UIAlertAction(title: NSLocalizedString("New game", comment: "new game action title"), style: .default) { (_) in
            self.formQuestions()
            self.setQuestion()
            
            if self.byTime {
                self.seconds = 15.0
                self.roundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                    self.seconds -= 1
                    if self.seconds < 0 {
                        self.setQuestion()
                        self.seconds = 15.0
                    }
                })
            }
        }
        
        alertController.addAction(restartGame)
        
        let quit = UIAlertAction(title: NSLocalizedString("Quit", comment: "quiz action title"), style: .default) { (_) in
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
        
        if byTime {
            timerLabel.isHidden = false
            seconds = 15.0
            roundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                self.seconds -= 1
                if self.seconds < 0 {
                    self.setQuestion()
                    self.seconds = 15.0
                }
            })
        }
        
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
                
                if byTime {
                    roundTimer.invalidate()
                    
                    seconds = 15.0
                    
                    roundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                        self.seconds -= 1
                        if self.seconds < 0 {
                            self.setQuestion()
                            self.seconds = 15.0
                        }
                    })
                }
            } else {
                finishQuiz()
            }
            textField.text = nil
            return true
        }
        return false
        
    }
    
}

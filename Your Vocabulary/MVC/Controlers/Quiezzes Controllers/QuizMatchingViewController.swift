//
//  QuizMatchingViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 25/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

class QuizMatchingViewController: UIViewController, QuizzesMethods {

    // MARK: - Properties
    
    var chosenParametrs: (dictionary: Dictionary, questionType: DictionaryElements, answerType: DictionaryElements)?
    
    fileprivate var questionPairs = [(question: String, answer: String)]()
    fileprivate var currentPairs = [(question: String, answer: String)]()
    
    fileprivate var countOfLeftAnswers = 0
    
    fileprivate var answer: (question: String?, answer: String?)
    
    var countOfAnswers = 0
    var countOfCorrectAnswers = 0
    let dateOfQuiz = Date()
    
    
    // MARK: - Outlets
    
    @IBOutlet var leftButtons: [UIButton]!
    @IBOutlet var rightButtons: [UIButton]!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    // MARK: - Actions
    
    @IBAction func answerButtonWasTapped(_ sender: UIButton) {
        if leftButtons.contains(sender) {
            answer.question = sender.titleLabel?.text
            if checkAnswer() {
                
                sender.isEnabled = false
                for button in rightButtons {
                    if button.titleLabel?.text == answer.answer {
                        button.isEnabled = false
                    }
                }
                
                resetAnswerValue()
                
                countOfLeftAnswers -= 1
            }
        } else {
            answer.answer = sender.titleLabel?.text
            if checkAnswer()  {
                
                sender.isEnabled = false
                for button in leftButtons {
                    if button.titleLabel?.text == answer.question {
                        button.isEnabled = false
                    }
                }
                
                resetAnswerValue()
                
                countOfLeftAnswers -= 1
            }
        }
        
        if countOfLeftAnswers == 0 {
            if questionPairs.count <= 1 {
                finishQuiz()
                return
            }
            
            setButtonsLabels()
            
            updateProgressBarProgress()
        }
    }
    
    
    // MARK: - Methods
    
    // Screen
    fileprivate func prepareScreen() {
        setButtonsSettings(forButtons: leftButtons)
        setButtonsSettings(forButtons: rightButtons)
    }
    
    fileprivate func setButtonsSettings(forButtons buttons: [UIButton]) {
        for button in buttons {
            button.titleLabel?.numberOfLines = 3
            button.titleLabel?.textAlignment = NSTextAlignment.center
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.4588235294, alpha: 1)
            button.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.737254902, blue: 0.7058823529, alpha: 1)
            button.tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
        }
    }
    
    //forming list of pairs
    
    fileprivate func formPairs() {
        guard let parametrs = chosenParametrs, let words = parametrs.dictionary.words?.array as? [Word] else { return }
        
        for word in words {
            guard let question = getElement(baseOn: parametrs.questionType, forWord: word), let answer = getElement(baseOn: parametrs.answerType, forWord: word) else { continue }
            
            questionPairs.append((question, answer))
            
        }
    }
    
    fileprivate func updateProgressBarProgress() {
        progressBar.setProgress(1 / Float(questionPairs.count), animated: true)
    }
    
    // game set up
    
    fileprivate func setQuestions() {
        currentPairs.removeAll()
    
        var numberOfEnableButtons = 0
        if questionPairs.count <= leftButtons.count {
            numberOfEnableButtons = questionPairs.count
        } else {
            numberOfEnableButtons = leftButtons.count
        }
        
        countOfLeftAnswers = numberOfEnableButtons
        
        for i in 0..<numberOfEnableButtons {
            let randomElementPosition = questionPairs.count.getRandom()

            currentPairs.append(questionPairs[randomElementPosition])
            questionPairs.remove(at: randomElementPosition)
            
            leftButtons[i].isEnabled = true
            leftButtons[i].isHidden = false
            rightButtons[i].isEnabled = true
            rightButtons[i].isHidden = false
            
        }
        
        if  numberOfEnableButtons < leftButtons.count {
            for i in (numberOfEnableButtons...leftButtons.count - 1).reversed() {
                leftButtons[i].isHidden = true
                rightButtons[i].isHidden = true
            }
        }
    }
    
    fileprivate func setButtonsLabels() {
        
        setQuestions()
        
        var copyCurrentPairs = currentPairs
        
        for i in 0..<currentPairs.count {
            let randomQuestionPosition = copyCurrentPairs.count.getRandom()
            leftButtons[i].setTitle(copyCurrentPairs[randomQuestionPosition].question, for: .normal)
            
            copyCurrentPairs.remove(at: randomQuestionPosition)
        }
        
        copyCurrentPairs = currentPairs
        
        for i in 0..<currentPairs.count{
            let randomAnswerPosition = copyCurrentPairs.count.getRandom()
            rightButtons[i].setTitle(copyCurrentPairs[randomAnswerPosition].answer, for: .normal)
            
            copyCurrentPairs.remove(at: randomAnswerPosition)
        }
        
    }
    
    fileprivate func checkAnswer() -> Bool {
        guard let _ = answer.question, let _ = answer.answer  else { return false }
        
        countOfAnswers += 1
        
        for pair in currentPairs {
            if pair.question == answer.question , pair.answer == answer.answer! {
                countOfCorrectAnswers += 1
                return true
            }
        }
        
        return false
    }
    
    fileprivate func resetAnswerValue() {
        answer.question = nil
        answer.answer = nil
    }
    
    fileprivate func finishQuiz() {
        
        let alertController = UIAlertController(title: "Done", message: "Finish quiz?", preferredStyle: .alert)
        
        alertController.view.tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
        let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.737254902, blue: 0.7058823529, alpha: 1)
        
        let restartGame = UIAlertAction(title: "New game", style: .default) { (_) in
            self.formPairs()
            self.setButtonsLabels()
            self.updateProgressBarProgress()
        }
        
        alertController.addAction(restartGame)
        
        let quit = UIAlertAction(title: "Quit", style: .default) { (_) in
            self.performSegue(withIdentifier: "unwindFinishMatchingQuiz", sender: self)
        }
        alertController.addAction(quit)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScreen()
        
        formPairs()
        
        updateProgressBarProgress()
        
        setButtonsLabels()
        
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

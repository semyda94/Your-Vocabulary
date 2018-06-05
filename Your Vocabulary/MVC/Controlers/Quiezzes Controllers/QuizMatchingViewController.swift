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
    
    var dictionary : RealmDictionary?
    
    var chosenParametrs: (questionType: DictionaryElements, answerType: DictionaryElements)?
    
    fileprivate var questionPairs = [(question: String, answer: String)]()
    fileprivate var currentPairs = [(question: String, answer: String)]()
    
    fileprivate var countOfLeftAnswers = 0
    
    fileprivate var answer: (question: String?, answer: String?)
    
    var byTime = false
    var roundTimer : Timer!
    var timeForAnswer = 15.0
    fileprivate var seconds = 0.0 {
        didSet {
            timerLabel.text = "\(Int(seconds))"
        }
    }
    
    var countOfAnswers = 0
    var countOfCorrectAnswers = 0
    let dateOfQuiz = Date()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet var leftButtons: [UIButton]!
    @IBOutlet var rightButtons: [UIButton]!
    
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
            if byTime {
                roundTimer.invalidate()
                
                seconds = timeForAnswer
                roundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                    self.seconds -= 1
                    if self.seconds < 0 {
                        self.setButtonsLabels()
                        
                        self.seconds = self.timeForAnswer
                    }
                })
            }
            
            
        }
    }
    
    
    // MARK: - Methods
    
    // Screen
    fileprivate func prepareScreen() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
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
        guard let parametrs = chosenParametrs, let dictionary = dictionary else { return }
        
        for word in dictionary.words {
            if !word.isLearned {
                guard let question = getElement(baseOn: parametrs.questionType, forWord: word), let answer = getElement(baseOn: parametrs.answerType, forWord: word) else { continue }
            
                questionPairs.append((question, answer))
            }
        }
 
    }
    
    fileprivate func updateProgressBarProgress() {
        progressBar.setProgress(1 / Float(questionPairs.count), animated: true)
    }
    
    // game set up
    
    fileprivate func setQuestions() {
        if questionPairs.count <= 1 {
            finishQuiz()
            return
        }
        
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
        
        for i in numberOfEnableButtons..<leftButtons.count {
            leftButtons[i].isHidden = true
            rightButtons[i].isHidden = true
        }
        

    }
    
    fileprivate func setButtonsLabels() {
        
        setQuestions()
        
        var copyCurrentPairs = currentPairs
        
        for i in 0..<currentPairs.count {
            let randomQuestionPosition = copyCurrentPairs.count.getRandom()
            leftButtons[i].setTitle(copyCurrentPairs[randomQuestionPosition].question, for: leftButtons[i].state)
            
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
            self.formPairs()
            self.setButtonsLabels()
            self.updateProgressBarProgress()
        }
        
        alertController.addAction(restartGame)
        
        let quit = UIAlertAction(title: NSLocalizedString("Quit", comment: "quiz action title"), style: .default) { (_) in
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
        
        if byTime {
            timerLabel.isHidden = false
            seconds = timeForAnswer
            roundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                self.seconds -= 1
                if self.seconds < 0 {
                    self.setButtonsLabels()
                    
                    self.seconds = self.timeForAnswer
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

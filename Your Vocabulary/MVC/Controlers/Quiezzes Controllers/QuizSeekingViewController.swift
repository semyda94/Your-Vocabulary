 //
//  QuizSeekingViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 13/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift

class QuizSeekingViewController: UIViewController, QuizzesMethods {

    // MARK: - Properties
    
    
    var dictionary : RealmDictionary?
    var chosenParametrs: (questionType: DictionaryElements, answerType: DictionaryElements)?
    
    fileprivate var remainingQuestion = [(question: String, answer: String)]()
    fileprivate var currentQuestion: (question: String, answer: String) = ("None", "None")
    fileprivate var wholeAnswers = [String]()
    fileprivate var currentAnswers = [String]()
    fileprivate var roundTimer : Timer!
    
    fileprivate var stepForProgressBar = 0.0
    
    /*******************************************************************************************************
     ****** If value of property "seconds" was changed then update label of showen left time for quiz ******
     *******************************************************************************************************/
    fileprivate var seconds = 0.0 {
        didSet {
            timerLabel.text = "\(Int(seconds))"
        }
    }
    
    var timeForAnswer = 5.0
    
    var countOfAnswers = 0
    var countOfCorrectAnswers = 0
    var countOfTimerInvokerd = 0
    let dateOfQuiz = Date()
    
    var byTime = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var answersButtons: [UIButton]!
    
    /***********************************
     ****** When user gave answer ******
     ***********************************/
    @IBAction func wasDoneAnswer(_ sender: UIButton) {
        //increase count of answers
        countOfAnswers += 1
        // checking given answer with answer that should be done for current question
        if sender.currentTitle == currentQuestion.answer {
            
            countOfCorrectAnswers += 1
            
            //set new question
            setQuestionAndAnswers()
            
            // if user chose the quize by time than set timer
            if byTime {
                roundTimer.invalidate()
                
                seconds = timeForAnswer
                roundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                    self.seconds -= 1
                    if self.seconds < 0 {
                        self.setQuestionAndAnswers()
                        self.countOfTimerInvokerd += 1
                        
                        self.seconds = self.timeForAnswer

                    }
                })
            }
        }
    }
    
    // MARK: - Methods
    
    /***************************************************
     ****** Setting visual properties UI elements ******
     ***************************************************/
    fileprivate func prepareScreen() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        for button in answersButtons {
            button.titleLabel?.numberOfLines = 4
            button.titleLabel?.textAlignment = NSTextAlignment.center
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.4588235294, alpha: 1)
            button.backgroundColor = #colorLiteral(red: 0.568627451, green: 0.7137254902, blue: 0.6862745098, alpha: 1)
            button.tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
        }
    }
    
    /****************************************
     ****** Forming questions for quiz ******
     ****************************************/
    fileprivate func formQuestions() {
        guard let parametrs = chosenParametrs, let dictionary = dictionary else { return }
        
        // append all unlearned words.
        for word in dictionary.words {
            if !word.isLearned {
                guard let question = getElement(baseOn: parametrs.questionType, forWord: word), let answer = getElement(baseOn: parametrs.answerType, forWord: word) else { continue }
            
                wholeAnswers.append(answer)
                remainingQuestion.append((question, answer))
            }
        }
        
        progressBar.progress = 0.0
        stepForProgressBar = 1.0 / Double(remainingQuestion.count)
        
    }
    
    /***************************************************
     ****** Setting options of answer to buttons. ******
     ***************************************************/
    fileprivate func setAnswers(forQuestion question : (question: String, answer: String)) {
        currentAnswers.removeAll()
        
        currentAnswers.append(currentQuestion.answer)
        
        while currentAnswers.count < answersButtons.count {
            let answer = wholeAnswers[wholeAnswers.count.getRandom()]
            if currentAnswers.contains(answer) { continue } else {
                currentAnswers.append(answer)
            }
        }
        
        for button in answersButtons {
            let randomOfset = currentAnswers.count.getRandom()
            let randomAnswer = currentAnswers[randomOfset]
            button.setTitle(randomAnswer, for: .normal)
            currentAnswers.remove(at: randomOfset)
        }
        
    }
    
    /****************************************************************************************************
     ****** Finishig quiz that provide alert controller which provide opportunity to restart quiz. ******
     ********************************** or finish quiz **************************************************
     ****************************************************************************************************/
    fileprivate func finishQuiz() {
        if byTime {
            roundTimer.invalidate()
        }
        
        
        // Calculate the grade of user and depend on the frade show the title and message.
        let grade = 1.0 / (Float(countOfAnswers + countOfTimerInvokerd) / Float(countOfCorrectAnswers))
        var alertTitle : String!
        var alertMessage : String!
        
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
        
        let restartGame = UIAlertAction(title: NSLocalizedString("New game", comment: "New game title of action"), style: .default) { (_) in
            self.formQuestions()
            self.setQuestionAndAnswers()
        }
        
        alertController.addAction(restartGame)
        
        let quitGame = UIAlertAction(title: NSLocalizedString("Quit", comment: "Quit title of action"), style: .default) { (_) in
            self.performSegue(withIdentifier: "unwindFinishSeekingQuiz", sender:self)
        }
        
        alertController.addAction(quitGame)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    /*****************************************************************
     ****** Set question and answers for button for next round. ******
     *****************************************************************/
    fileprivate func setQuestionAndAnswers() {
        if remainingQuestion.count == 0 {
            finishQuiz()
            return
            
        }
        
        updateProgressBar()
        
        let randomQuestionIndex = (remainingQuestion.count).getRandom()
        currentQuestion = remainingQuestion[ randomQuestionIndex]
        questionLabel.text = currentQuestion.question
        setAnswers(forQuestion: currentQuestion)
        
        remainingQuestion.remove(at: randomQuestionIndex)
    }
    
    fileprivate func updateProgressBar() {
        progressBar.setProgress(progressBar.progress + Float(stepForProgressBar), animated: true)
    }
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScreen()
        
        formQuestions()
        
        setQuestionAndAnswers()
        
        // setting a timer if user chose a quiz by time.
        if byTime {
            timerLabel.isHidden = false
            seconds = timeForAnswer
            countOfTimerInvokerd += 1
            roundTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                self.seconds -= 1
                if self.seconds < 0 {
                    self.setQuestionAndAnswers()
                    self.countOfTimerInvokerd += 1
                    
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

 /**********************************************************************
  ****** Extendig of Int class by function that get random value. ******
  **********************************************************************/

 extension Int {
    func getRandom() -> Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
 }

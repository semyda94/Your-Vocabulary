 //
//  QuizSeekingViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 13/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class QuizSeekingViewController: UIViewController {

    // MARK: - Properties
    
    var chosenParametrs: (dictionary: Dictionary, questionType: DictionaryElements, answerType: DictionaryElements)?
    
    fileprivate var remainingQuestion = [(question: String, answer: String)]()
    fileprivate var currentQuestion: (question: String, answer: String) = ("None", "None")
    fileprivate var wholeAnswers = [String]()
    fileprivate var currentAnswers = [String]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var answersButtons: [UIButton]!
    
    @IBAction func wasDoneAnswer(_ sender: UIButton) {
        if sender.currentTitle == currentQuestion.answer {
            setQuestionAndAnswers()
        }
    }
    
    // MARK: - Methods
    
    fileprivate func prepareScreen() {
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        for button in answersButtons {
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.4588235294, alpha: 1)
            button.backgroundColor = #colorLiteral(red: 0.568627451, green: 0.7137254902, blue: 0.6862745098, alpha: 1)
            button.tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
        }
    }
    
    fileprivate func getElement(baseOn typeElement: DictionaryElements, forWord word: Word) -> String?{
        switch typeElement {
        case .word:
            return word.word
        case .translation:
            guard let translations = word.translations?.allObjects as? [Translation] else { return nil}
            
            for translation in translations {
                guard let element = translation.text else { break }
                return element
            }
            return nil
            
        case .definition:
            guard let definitions = word.definitions?.allObjects as? [Definition] else { return nil}
            
            for definition in definitions {
                guard let element = definition.text else { break }
                return element
            }
            return nil
            
        case .extraInfo:
            guard let extraInfos = word.extraInfos?.allObjects as? [ExtraInfo] else { return nil}
            
            for extraInfo in extraInfos {
                guard let element = extraInfo.text else { break }
                return element
            }
            return nil
            
        case .synonym:
            guard let synonyms = word.synonyms?.allObjects as? [Synonym] else { return nil}
            
            for synonym in synonyms {
                guard let element = synonym.text else { break }
                return element
            }
            return nil
            
        case .example:
            guard let examples = word.examples?.allObjects as? [Example] else { return nil}
            
            for example in examples {
                guard let element = example.text else { break }
                return element
            }
            return nil
        }
    }
    
    fileprivate func formQuestions() {
        guard let parametrs = chosenParametrs, let words = chosenParametrs?.dictionary.words?.array as? [Word] else { return }
        
        for word in words {
            guard let question = getElement(baseOn: parametrs.questionType, forWord: word), let answer = getElement(baseOn: parametrs.answerType, forWord: word) else { break }
            
            wholeAnswers.append(answer)
            remainingQuestion.append((question, answer))
        }
        
    }
    
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
    
    fileprivate func finishQuiz() {
        let alertController = UIAlertController(title: "Title", message: "End?", preferredStyle: .alert)
        
        alertController.view.tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
        let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.737254902, blue: 0.7058823529, alpha: 1)
        
        let restartGame = UIAlertAction(title: "New game", style: .default) { (_) in
            self.formQuestions()
            self.setQuestionAndAnswers()
        }
        
        alertController.addAction(restartGame)
        
        let quitGame = UIAlertAction(title: "Quit", style: .default) { (_) in
            self.performSegue(withIdentifier: "unwindFinishSeekingQuiz", sender:self)
        }
        
        alertController.addAction(quitGame)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
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
        progressBar.setProgress(1 / Float(remainingQuestion.count), animated: true)
    }
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScreen()
        
        formQuestions()
        
        setQuestionAndAnswers()
        
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

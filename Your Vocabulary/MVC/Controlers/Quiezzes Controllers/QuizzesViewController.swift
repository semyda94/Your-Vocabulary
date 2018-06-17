//
//  QuizzesViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 13/06/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift

class QuizzesViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let realm = try! Realm()
    
    fileprivate var selectedTypeOfQuiz : QuizzesTypes?
    
    // MARK: - Outlets
    
    @IBOutlet weak var quizzesTable: UITableView!
    
    // MARK: - Methods
    
    fileprivate var quizzes = [(nameOfSection: String, sectionQuizzes: [(name: QuizzesTypes, thumbnail: UIImage)])]()
    
    // MARK: - Unwind segues
    
    @IBAction func closePropertiesView(segue: UIStoryboardSegue){
        
    }
    
    /***********************************************************************************
     ****** Unwind segue when user seleted a type of quiz and properties for quiz ******
     ***********************************************************************************/
    @IBAction func startQuiz(segue: UIStoryboardSegue) {
        if let segue = segue as? UIStoryboardSegueWithCompletion {
            
            // set segue completion
            segue.completion = {
            
                guard let sourceVC = segue.source as? QuizPropertiesViewController else { return }
                let chosenDictionary = sourceVC.dictionaries![sourceVC.pickerView.selectedRow(inComponent: 0)]
                
                //checking amount of unlearned words at chosen dictionary
                
                if chosenDictionary.words.count - chosenDictionary.numberOfLearnedWords >= 4 {
                    print("lasdasd")
                    // if chosen dictionary has more than 4 unlearned words then start quiz with chosen type
                    switch sourceVC.typeOfQuiz {
                    case .seeking:
                        self.performSegue(withIdentifier: "startSeekingQuiz", sender: sourceVC)
                    case .seekingByTime:
                        self.performSegue(withIdentifier: "startSeekingByTimeQuiz", sender: sourceVC)
                    case .matching:
                        self.performSegue(withIdentifier: "startMatchingQuiz", sender: sourceVC)
                    case .matchingByTime:
                        self.performSegue(withIdentifier: "startMatchingByTimeQuiz", sender: sourceVC)
                    case .spelling:
                        self.performSegue(withIdentifier: "startSpellingQuiz", sender: sourceVC)
                    default:
                        return
                    }
                } else {
                    //if chosen dictionary has less than 4 unlearned words present alert that explain that dictionary should has at least 4 unlearned  words for start the quiz
                    let alertController = UIAlertController(title: NSLocalizedString("Not enough words", comment: "Title for alert controller when chosen dictionary doesn't have any words"), message: NSLocalizedString("Sorry, chosen dictionary doesn't have enough unlearned words. ", comment: "Message for alert controller when chosen dictionary doesnt' have any words"), preferredStyle: .alert)
                    
                    let cancelAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Title for cancel alert action when chosen dictionary doesn't have any words"), style: .cancel, handler: nil)
                    
                    alertController.addAction(cancelAlertAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            return
        }
    }
    
    /**************************************************************
     ****** Function that finish quiz and save quiz results. ******
     **************************************************************/
    @IBAction func finishQuiz(segue: UIStoryboardSegue) {
        var countOfAnswers = 0
        var countOfCorrectAnswer = 0
        var dateOfQuiz = Date()
        var dictionary: RealmDictionary
        
        switch segue.identifier! {
        case "unwindFinishSeekingQuiz":
            guard let sourceVC = segue.source as? QuizSeekingViewController else { return }
            countOfAnswers = sourceVC.countOfAnswers + sourceVC.countOfTimerInvokerd
            countOfCorrectAnswer = sourceVC.countOfCorrectAnswers
            dateOfQuiz = sourceVC.dateOfQuiz
            dictionary = sourceVC.dictionary!
            print("unwindFinishSeekingQuiz done")
            
        case "unwindFinishMatchingQuiz":
            guard let sourceVC = segue.source as? QuizMatchingViewController else { return }
            countOfAnswers = sourceVC.countOfAnswers
            countOfCorrectAnswer = sourceVC.countOfCorrectAnswers
            dateOfQuiz = sourceVC.dateOfQuiz
            dictionary = sourceVC.dictionary!
            print("unwindFinishMatchingQuiz done")
            /*
             case "unwindFinishSpellingQuiz":
             guard let sourceVC = segue.source as? QuizSpellingViewController else { return }
             countOfAnswers = sourceVC.countOfAnswers
             countOfCorrectAnswer = sourceVC.countOfCorrectAnswers
             dateOfQuiz = sourceVC.dateOfQuiz
             dictionary = sourceVC.chosenParametrs!.dictionary
             print("unwindFinishSpellingQuiz done")
             */
        default:
            return
        }
        
        // Save quiz information
        
        try! realm.write {
            let newQuizInfo = RealmQuizInfo()
            
            newQuizInfo.numberOfAnswers = countOfAnswers
            newQuizInfo.numberOfCorrectAnswers = countOfCorrectAnswer
            newQuizInfo.dateOfCreation = dateOfQuiz
            
            dictionary.quizesInfo.append(newQuizInfo)
        }
        
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let memoName = "Memorization"
        let memoQuizzes: [(name: QuizzesTypes, thumbnail: UIImage)] =  [(.seeking, #imageLiteral(resourceName: "seeking_icon") ), (.seekingByTime, #imageLiteral(resourceName: "seeking_by_time_icon")), (.matching, #imageLiteral(resourceName: "matching_icon")), (.matchingByTime, #imageLiteral(resourceName: "matching_by_time_icon"))]
        
        quizzes.append((nameOfSection: memoName, sectionQuizzes: memoQuizzes))
        
        let spelName = "Spelling"
        let spelQuizzes: [(name: QuizzesTypes, thumbnail: UIImage)] = [(.spelling, #imageLiteral(resourceName: "spelling_icon")), (.spellingByTime, #imageLiteral(resourceName: "spelling_by_time_icon"))]
        
        quizzes.append((nameOfSection: spelName, sectionQuizzes: spelQuizzes))
        
        quizzesTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showQuizProperties":
            
            guard let qpvc = segue.destination as? QuizPropertiesViewController else { return }
            /*guard let qcvc = segue.source as? QuizzesCollectionViewController else { return }
             guard let cell = sender as? QuizzesCollectionViewCell, let indexPath = collectionView?.indexPath(for: cell) else { return }*/
            qpvc.typeOfQuiz = selectedTypeOfQuiz!
            qpvc.modalPresentationStyle = .overCurrentContext
            
        case "startSeekingByTimeQuiz":
            guard let qpvc = sender as? QuizPropertiesViewController else { return }
            guard let qsvc = segue.destination as? QuizSeekingViewController else { return }
            
            let chosenParametrs: (questionType: DictionaryElements, answerType: DictionaryElements)
            
            qsvc.byTime = true
            
            chosenParametrs.questionType = qpvc.parametrsForPicker.questionType[qpvc.pickerView.selectedRow(inComponent: 1)]
            chosenParametrs.answerType = qpvc.parametrsForPicker.answersType[qpvc.pickerView.selectedRow(inComponent: 2)]
            
            qsvc.chosenParametrs = chosenParametrs
            qsvc.dictionary = qpvc.dictionaries![qpvc.pickerView.selectedRow(inComponent: 0)]
            
        case "startSeekingQuiz":
            guard let qpvc = sender as? QuizPropertiesViewController else { return }
            guard let qsvc = segue.destination as? QuizSeekingViewController else { return }
            
            let chosenParametrs: (questionType: DictionaryElements, answerType: DictionaryElements)
            
            
            chosenParametrs.questionType = qpvc.parametrsForPicker.questionType[qpvc.pickerView.selectedRow(inComponent: 1)]
            chosenParametrs.answerType = qpvc.parametrsForPicker.answersType[qpvc.pickerView.selectedRow(inComponent: 2)]
            
            qsvc.chosenParametrs = chosenParametrs
            qsvc.dictionary = qpvc.dictionaries![qpvc.pickerView.selectedRow(inComponent: 0)]
            
        case "startMatchingByTimeQuiz":
            guard let qpvc = sender as? QuizPropertiesViewController else { return }
            guard let qmvc = segue.destination as? QuizMatchingViewController else { return }
            
            let chosenParametrs: (questionType: DictionaryElements, answerType: DictionaryElements)
            
            qmvc.byTime = true
            
            chosenParametrs.questionType = qpvc.parametrsForPicker.questionType[qpvc.pickerView.selectedRow(inComponent: 1)]
            chosenParametrs.answerType = qpvc.parametrsForPicker.answersType[qpvc.pickerView.selectedRow(inComponent: 2)]
            
            qmvc.chosenParametrs = chosenParametrs
            qmvc.dictionary = qpvc.dictionaries![qpvc.pickerView.selectedRow(inComponent: 0)]
            
        case "startMatchingQuiz":
            guard let qpvc = sender as? QuizPropertiesViewController else { return }
            guard let qmvc = segue.destination as? QuizMatchingViewController else { return }
            
            let chosenParametrs: (questionType: DictionaryElements, answerType: DictionaryElements)
            
            chosenParametrs.questionType = qpvc.parametrsForPicker.questionType[qpvc.pickerView.selectedRow(inComponent: 1)]
            chosenParametrs.answerType = qpvc.parametrsForPicker.answersType[qpvc.pickerView.selectedRow(inComponent: 2)]
            
            qmvc.chosenParametrs = chosenParametrs
            qmvc.dictionary = qpvc.dictionaries![qpvc.pickerView.selectedRow(inComponent: 0)]
            
        case "startSpellingQuiz":
             guard let qpvc = sender as? QuizPropertiesViewController else { return }
             guard let qsvc = segue.destination as? QuizSpellingViewController else { return }
             
             let chosenParametrs: (questionType: DictionaryElements, answerType: DictionaryElements)
             
             chosenParametrs.questionType = qpvc.parametrsForPicker.questionType[qpvc.pickerView.selectedRow(inComponent: 1)]
             chosenParametrs.answerType = qpvc.parametrsForPicker.answersType[qpvc.pickerView.selectedRow(inComponent: 2)]
             
             qsvc.chosenParametrs = chosenParametrs
             qsvc.dictionary = qpvc.dictionaries![qpvc.pickerView.selectedRow(inComponent: 0)]
            
        default:
            break
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

}

// MARK: - UITableViewDataSource
extension QuizzesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return quizzes[section].nameOfSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizzesTable.dequeueReusableCell(withIdentifier: "QuizzesColection", for: indexPath) as! QuizzesTableViewCell
        
        cell.quizzes = quizzes[indexPath.section].sectionQuizzes
        cell.delegateQuizWasSelected = self
        return cell
    }
    
    
}

//

// MARK: - UITableViewDelegate
extension QuizzesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height / 2.7
    }
}

// MARK: - delegateQuizWasSelected

extension QuizzesViewController: QuizWasSelected {
    func quizWasSelected(withForQuizType quizType: QuizzesTypes) {
        print("Was chose \(quizType)")
        //checking amount of dictionaries before present Quiz properties view.
        let result = realm.objects(RealmDictionary.self)
        if !result.isEmpty {
            selectedTypeOfQuiz = quizType
            performSegue(withIdentifier: "showQuizProperties", sender: self)
        } else {
            let emptyListOfDictionariesAlertController = UIAlertController(title: NSLocalizedString("No dictionaries", comment: "Title for alert controler when list of dictionaries is empty"), message: NSLocalizedString("Sadly, at this moment your list of dictionaries doesn't have no one dictionary.", comment: "Message for alert controller when list of dictionaries is empty"), preferredStyle: .alert)
            
            let cancelAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Title for cancel alert action when chosen dictionary doesn't have any words"), style: .cancel, handler: nil)
            
            emptyListOfDictionariesAlertController.addAction(cancelAlertAction)
            
            present(emptyListOfDictionariesAlertController, animated: true, completion: nil)
        }
    }
    
    
}

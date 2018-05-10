//
//  QuizzesCollectionViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 8/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "QuizCollectionCell"

class QuizzesCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    let quizzes: [(name: QuizzesTypes, thumbnail: UIImage)] = [(.seeking, #imageLiteral(resourceName: "seeking_icon") ), (.seekingByTime, #imageLiteral(resourceName: "seeking_by_time_icon")), (.matching, #imageLiteral(resourceName: "matching_icon")), (.matchingByTime, #imageLiteral(resourceName: "matching_by_time_icon")), /*(.spelling, #imageLiteral(resourceName: "spelling_icon")), (.spellingByTime, #imageLiteral(resourceName: "spelling_by_time_icon"))*/]
    
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    fileprivate var selectedQuizCellIndex = IndexPath(row: 0, section: 0)
    
    //MARK: - Unwind segue
    
    @IBAction func getEmptyListOfDictionaries(segue: UIStoryboardSegue) {
        print("Lol")
        
    }
    
    @IBAction func closePropertiesView(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func startQuiz(segue: UIStoryboardSegue) {
        if let segue = segue as? UIStoryboardSegueWithCompletion {
            
            segue.completion = {
                guard let sourceVC = segue.source as? QuizPropertiesViewController else { return }
                let chosenDictionary = sourceVC.parametrsForPicker.dictionaries[sourceVC.pickerView.selectedRow(inComponent: 0)]
                
                if chosenDictionary.numberOfWords - chosenDictionary.numberofLearned >= 4 {
                    print("Dictionary has more than 4 words")
                    
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
                    print("Dictionary doesn't have 4 words")
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
    
    @IBAction func finishQuiz(segue: UIStoryboardSegue) {
        var countOfAnswers = 0
        var countOfCorrectAnswer = 0
        var dateOfQuiz: Date?
        var dictionary: Dictionary
        
        switch segue.identifier! {
        case "unwindFinishSeekingQuiz":
            guard let sourceVC = segue.source as? QuizSeekingViewController else { return }
            countOfAnswers = sourceVC.countOfAnswers + sourceVC.countOfTimerInvokerd
            countOfCorrectAnswer = sourceVC.countOfCorrectAnswers
            dateOfQuiz = sourceVC.dateOfQuiz
            dictionary = sourceVC.chosenParametrs!.dictionary
            print("unwindFinishSeekingQuiz done")
        case "unwindFinishMatchingQuiz":
            guard let sourceVC = segue.source as? QuizMatchingViewController else { return }
            countOfAnswers = sourceVC.countOfAnswers
            countOfCorrectAnswer = sourceVC.countOfCorrectAnswers
            dateOfQuiz = sourceVC.dateOfQuiz
            dictionary = sourceVC.chosenParametrs!.dictionary
            print("unwindFinishMatchingQuiz done")
        case "unwindFinishSpellingQuiz":
            guard let sourceVC = segue.source as? QuizSpellingViewController else { return }
            countOfAnswers = sourceVC.countOfAnswers
            countOfCorrectAnswer = sourceVC.countOfCorrectAnswers
            dateOfQuiz = sourceVC.dateOfQuiz
            dictionary = sourceVC.chosenParametrs!.dictionary
            print("unwindFinishSpellingQuiz done")
        default:
            return
        }
        
        guard let context = managedContext else { return }
        
        guard let entityQuiz = NSEntityDescription.entity(forEntityName: "TestInfo", in: context) else { return }
        let newQuiz = TestInfo(entity: entityQuiz, insertInto: context)
        
        newQuiz.dateOfCreation = dateOfQuiz! as NSDate
        newQuiz.numberOfAnswers = Int32(countOfAnswers)
        newQuiz.numberOfCorrectAnswers = Int32(countOfCorrectAnswer)
        
        dictionary.insertIntoTests(newQuiz, at: 0)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error during insert new quiz \(error), \(error.userInfo)")
        }
        
        print(dictionary.tests?.array as! [TestInfo])
        
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

//        // Register cell classes
//        self.collectionView!.register(QuizzesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width / 2.0 - 5
            let itemHeight = itemWidth
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showQuizProperties":
            
            guard let qpvc = segue.destination as? QuizPropertiesViewController else { return }
            guard let qcvc = segue.source as? QuizzesCollectionViewController else { return }
            /*guard let cell = sender as? QuizzesCollectionViewCell, let indexPath = collectionView?.indexPath(for: cell) else { return }*/
            qpvc.typeOfQuiz = quizzes[selectedQuizCellIndex.row].name
            qpvc.modalPresentationStyle = .overCurrentContext
        
        case "startSeekingByTimeQuiz":
            guard let qpvc = sender as? QuizPropertiesViewController else { return }
            guard let qsvc = segue.destination as? QuizSeekingViewController else { return }
            
            let chosenParametrs: (dictionary: Dictionary, questionType: DictionaryElements, answerType: DictionaryElements)
            
            qsvc.byTime = true
            
            chosenParametrs.dictionary = qpvc.parametrsForPicker.dictionaries[qpvc.pickerView.selectedRow(inComponent: 0)]
            chosenParametrs.questionType = qpvc.parametrsForPicker.questionType[qpvc.pickerView.selectedRow(inComponent: 1)]
            chosenParametrs.answerType = qpvc.parametrsForPicker.answersType[qpvc.pickerView.selectedRow(inComponent: 2)]
            
            qsvc.chosenParametrs = chosenParametrs
 
        case "startSeekingQuiz":
            guard let qpvc = sender as? QuizPropertiesViewController else { return }
            guard let qsvc = segue.destination as? QuizSeekingViewController else { return }
            
            let chosenParametrs: (dictionary: Dictionary, questionType: DictionaryElements, answerType: DictionaryElements)
            
            chosenParametrs.dictionary = qpvc.parametrsForPicker.dictionaries[qpvc.pickerView.selectedRow(inComponent: 0)]
            chosenParametrs.questionType = qpvc.parametrsForPicker.questionType[qpvc.pickerView.selectedRow(inComponent: 1)]
            chosenParametrs.answerType = qpvc.parametrsForPicker.answersType[qpvc.pickerView.selectedRow(inComponent: 2)]
            
            qsvc.chosenParametrs = chosenParametrs
        
        case "startMatchingByTimeQuiz":
            guard let qpvc = sender as? QuizPropertiesViewController else { return }
            guard let qmvc = segue.destination as? QuizMatchingViewController else { return }
            
            let chosenParametrs: (dictionary: Dictionary, questionType: DictionaryElements, answerType: DictionaryElements)
            
            qmvc.byTime = true
            
            chosenParametrs.dictionary = qpvc.parametrsForPicker.dictionaries[qpvc.pickerView.selectedRow(inComponent: 0)]
            chosenParametrs.questionType = qpvc.parametrsForPicker.questionType[qpvc.pickerView.selectedRow(inComponent: 1)]
            chosenParametrs.answerType = qpvc.parametrsForPicker.answersType[qpvc.pickerView.selectedRow(inComponent: 2)]
            
            qmvc.chosenParametrs = chosenParametrs
            
        case "startMatchingQuiz":
            guard let qpvc = sender as? QuizPropertiesViewController else { return }
            guard let qmvc = segue.destination as? QuizMatchingViewController else { return }
            
            let chosenParametrs: (dictionary: Dictionary, questionType: DictionaryElements, answerType: DictionaryElements)
            
            chosenParametrs.dictionary = qpvc.parametrsForPicker.dictionaries[qpvc.pickerView.selectedRow(inComponent: 0)]
            chosenParametrs.questionType = qpvc.parametrsForPicker.questionType[qpvc.pickerView.selectedRow(inComponent: 1)]
            chosenParametrs.answerType = qpvc.parametrsForPicker.answersType[qpvc.pickerView.selectedRow(inComponent: 2)]
            
            qmvc.chosenParametrs = chosenParametrs
            
        case "startSpellingQuiz":
            guard let qpvc = sender as? QuizPropertiesViewController else { return }
            guard let qsvc = segue.destination as? QuizSpellingViewController else { return }
            
            let chosenParametrs: (dictionary: Dictionary, questionType: DictionaryElements, answerType: DictionaryElements)
            
            chosenParametrs.dictionary = qpvc.parametrsForPicker.dictionaries[qpvc.pickerView.selectedRow(inComponent: 0)]
            chosenParametrs.questionType = qpvc.parametrsForPicker.questionType[qpvc.pickerView.selectedRow(inComponent: 1)]
            chosenParametrs.answerType = qpvc.parametrsForPicker.answersType[qpvc.pickerView.selectedRow(inComponent: 2)]
            
            qsvc.chosenParametrs = chosenParametrs
            
        default:
            break
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return quizzes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("try to set cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! QuizzesCollectionViewCell
    
        cell.quizzThumbNail.image = quizzes[indexPath.row].thumbnail
        cell.title.text = quizzes[indexPath.row].name.rawValue
        // Configure the cell
        
        return cell
        
    }

    // MARK: UICollectionViewDelegate

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let context = managedContext else { return }
        
        let request = NSFetchRequest<Dictionary>(entityName: "Dictionary")
        
        do {
            let result = try context.fetch(request)
            if !result.isEmpty {
                selectedQuizCellIndex = indexPath
                performSegue(withIdentifier: "showQuizProperties", sender: self)
            } else {
                let emptyListOfDictionariesAlertController = UIAlertController(title: NSLocalizedString("No dictionaries", comment: "Title for alert controler when list of dictionaries is empty"), message: NSLocalizedString("Sadly, at this moment your list of dictionaries doesn't have no one dictionary.", comment: "Message for alert controller when list of dictionaries is empty"), preferredStyle: .alert)
                
                let cancelAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Title for cancel alert action when chosen dictionary doesn't have any words"), style: .cancel, handler: nil)
                
                emptyListOfDictionariesAlertController.addAction(cancelAlertAction)
                
                present(emptyListOfDictionariesAlertController, animated: true, completion: nil)
            }
        } catch let error as NSError {
            print("Unresolver error during fetching dictionary: \(error), \(error.userInfo)")
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    

}

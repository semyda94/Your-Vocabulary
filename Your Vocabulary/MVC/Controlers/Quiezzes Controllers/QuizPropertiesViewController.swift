//
//  QuizPropertiesViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 22/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class QuizPropertiesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARKL - Properties
    
    fileprivate var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    var parametrsForPicker =  (dictionaries: [Dictionary](), questionType: [DictionaryElements](), answersType: [DictionaryElements]())
    
    var typeOfQuiz = QuizzesTypes.none
    
    //MARK: - Outlets
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    //MARK: Fucntions
    
    fileprivate func setPickersParametrs() {
        guard let context = managedContext else { return }
        
        let request = NSFetchRequest<Dictionary>(entityName: "Dictionary")
        
        do {
            let result = try context.fetch(request)
            parametrsForPicker.dictionaries = result
            setSubParametrs(dictionarAt: 0)
        } catch let error as NSError {
            print("Unresolver error during fetching dictionary: \(error), \(error.userInfo)")
        }
        
    }
    
    fileprivate func setSubParametrs(dictionarAt position: Int) {
        parametrsForPicker.answersType.removeAll()
        parametrsForPicker.questionType.removeAll()
        
        parametrsForPicker.questionType.append(DictionaryElements.word)
        parametrsForPicker.answersType.append(DictionaryElements.word)
        
        if parametrsForPicker.dictionaries[position].isTranslation {
            parametrsForPicker.questionType.append(DictionaryElements.translation)
            parametrsForPicker.answersType.append(DictionaryElements.translation)
        }
        
        if parametrsForPicker.dictionaries[position].isDefinition {
            parametrsForPicker.questionType.append(DictionaryElements.definition)
            parametrsForPicker.answersType.append(DictionaryElements.definition)
        }
        
        if parametrsForPicker.dictionaries[position].isSynonym {
            parametrsForPicker.questionType.append(DictionaryElements.synonym)
            parametrsForPicker.answersType.append(DictionaryElements.synonym)
        }
        
        if parametrsForPicker.dictionaries[position].isExample {
            parametrsForPicker.questionType.append(DictionaryElements.example)
            parametrsForPicker.answersType.append(DictionaryElements.example)
        }
        
        pickerView.reloadComponent(1)
        pickerView.reloadComponent(2)
    }
    
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 10
        
        setPickersParametrs()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIPickerDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return parametrsForPicker.dictionaries.count
        case 1:
            return parametrsForPicker.questionType.count
        case 2:
            return parametrsForPicker.answersType.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return parametrsForPicker.dictionaries[row].name
        case 1:
            return parametrsForPicker.questionType[row].rawValue
        case 2:
            return parametrsForPicker.answersType[row].rawValue
        default:
            return nil
        }
    }

    //UIPickerDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            setSubParametrs(dictionarAt: row)
        default:
            return
        }
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

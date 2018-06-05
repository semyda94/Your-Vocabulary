//
//  QuizPropertiesViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 22/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData

class QuizPropertiesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARKL - Properties
    
    fileprivate let realm = try! Realm()
    
    var dictionaries : Results<RealmDictionary>?
    
    var parametrsForPicker =  (questionType: [DictionaryElements](), answersType: [DictionaryElements]())
    
    var typeOfQuiz = QuizzesTypes.none
    
    //MARK: - Outlets
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    //MARK: Fucntions
    
    fileprivate func setPickersParametrs() {
       
        dictionaries = realm.objects(RealmDictionary.self)
        setSubParametrs(dictionarAt: 0)
        
        
        
    }
    
    fileprivate func setSubParametrs(dictionarAt position: Int) {
        parametrsForPicker.answersType.removeAll()
        parametrsForPicker.questionType.removeAll()
        
        parametrsForPicker.questionType.append(DictionaryElements.word)
        parametrsForPicker.answersType.append(DictionaryElements.word)
        
        guard let dictionaries = dictionaries else { return }
        
        if dictionaries[position].isTranslation {
            parametrsForPicker.questionType.append(DictionaryElements.translation)
            parametrsForPicker.answersType.append(DictionaryElements.translation)
        }
        
        if dictionaries[position].isDefinition {
            parametrsForPicker.questionType.append(DictionaryElements.definition)
            parametrsForPicker.answersType.append(DictionaryElements.definition)
        }
        
        if dictionaries[position].isSynonym {
            parametrsForPicker.questionType.append(DictionaryElements.synonym)
            parametrsForPicker.answersType.append(DictionaryElements.synonym)
        }
        
        if dictionaries[position].isExample {
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
            guard let dictionaries = dictionaries else { return 0}
            return dictionaries.count
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
            guard let dictionaries = dictionaries else { return nil}
            return dictionaries[row].name
        case 1:
            return parametrsForPicker.questionType[row].localizedString
        case 2:
            return parametrsForPicker.answersType[row].localizedString
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

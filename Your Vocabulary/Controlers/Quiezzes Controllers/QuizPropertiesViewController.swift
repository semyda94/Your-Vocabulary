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
    
    fileprivate var dictionaries = [Dictionary]()
    
    fileprivate var firstParametrs = [String]()
    fileprivate var secondParametrs = [String]()
    fileprivate var selectedParametrs = [String]()
    
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
            dictionaries = result
            setSubParametrs(dictionarAt: 0)
        } catch let error as NSError {
            print("Unresolver error during fetching dictionary: \(error), \(error.userInfo)")
        }
        
    }
    
    fileprivate func setSubParametrs(dictionarAt position: Int) {
        firstParametrs.removeAll()
        secondParametrs.removeAll()
        
        if dictionaries[position].isTranslation {
            firstParametrs.append("Translation")
            secondParametrs.append("Translation")
        }
        
        if dictionaries[position].isDefinition {
            firstParametrs.append("Definition")
            secondParametrs.append("Definition")
        }
        
        if dictionaries[position].isSynonym {
            firstParametrs.append("Synonym")
            secondParametrs.append("Synonym")
        }
        
        if dictionaries[position].isExample {
            firstParametrs.append("Example")
            secondParametrs.append("Example")
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
            return dictionaries.count
        case 1:
            return firstParametrs.count
        case 2:
            return secondParametrs.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return dictionaries[row].name
        case 1:
            return firstParametrs[row]
        case 2:
            return secondParametrs[row]
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

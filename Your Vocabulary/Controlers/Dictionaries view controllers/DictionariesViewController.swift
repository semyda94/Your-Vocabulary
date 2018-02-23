//
//  DictionariesViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 15/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class DictionariesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    fileprivate var dictionaries = [Dictionary]()
    
    fileprivate var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    fileprivate lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    fileprivate let dictionaryFlags:  [String : Int] = [ "Translation" : 0,
                                                        "Definition" : 1,
                                                         "ExtraInfo" : 2,
                                                         "Synonym" : 3,
                                                         "Example" : 4]
    
    // MARK: - Methods
    
    fileprivate func addDictionaryAtTable(withName name : String, isTranslation translation : Bool, isDefinition definition : Bool, isExtraInfo extraInfo : Bool, isSynonym synonym : Bool, isExample example : Bool) {
        guard let context = managedContext, let entity = NSEntityDescription.entity(forEntityName: "Dictionary", in: context) else { return }
        
        let newDictionary = Dictionary(entity: entity, insertInto: context)
        
        newDictionary.setValue(name , forKey: "name")
        newDictionary.setValue(translation, forKey: "isTranslation")
        newDictionary.setValue(definition, forKey: "isDefinition")
        newDictionary.setValue(extraInfo, forKey: "isExtraInfo")
        newDictionary.setValue(synonym, forKey: "isSynonym")
        newDictionary.setValue(example, forKey: "isExample")
        
        do {
            try context.save()
            dictionaries += [newDictionary]
            dictionariesTableView.reloadData()
        } catch let error as NSError {
            print("Unresolved error during adding new dictionary \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func gettingListOfDictionaries(){
        guard let context = managedContext else { return }
        
        let request = NSFetchRequest<Dictionary>(entityName: "Dictionary")
        
        do {
            let result = try context.fetch(request)
            
            dictionaries = result
            dictionariesTableView.reloadData()
        } catch let error as NSError {
            print("Unresolved error during fetching dictionary: \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func deletingDictionaryFromTable(at index:Int){
        guard let context = managedContext else { return }
        
        let dictionaryToRemove = dictionaries[index]
        
        context.delete(dictionaryToRemove)
        
        do {
            try context.save()
            dictionaries.remove(at: index)
            dictionariesTableView.reloadData()
        } catch let error as NSError {
            print("Unresolved error during deleting dictionary \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var dictionariesTableView: UITableView!
    
    @IBOutlet var dictionaryProperties: UIView!
    @IBOutlet weak var dictionaryPropertiesTitle: UILabel!
    @IBOutlet weak var dictionaryNameTextField: UITextField!
    @IBOutlet var dictionaryFlagsCheckBoxes: [BEMCheckBox]!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    // MARK: - Actions
    
    @IBAction func cancelButtonWasTapped(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func saveButtonWasTapped(segue: UIStoryboardSegue){
        guard let sourceViewController = segue.source as? DictionaryPropertiesViewController else { return }
        
        guard let context = managedContext else { return }
        
        if sourceViewController.newDictionary {
            guard let entity = NSEntityDescription.entity(forEntityName: "Dictionary", in: context) else { return }
            let newDictionary = Dictionary(entity: entity, insertInto: context)
            
            if let name = sourceViewController.dictionaryNameTextField.text {
                newDictionary.name = name
            } else {
                newDictionary.name = "Unknowed"
            }
            newDictionary.dateOfCreation = NSDate()
            newDictionary.dateOfLastChanges = NSDate()
            newDictionary.numberOfWords = 0
            newDictionary.numberofLearned = 0
            newDictionary.isTranslation = sourceViewController.translationCheckBox.on
            newDictionary.isDefinition = sourceViewController.definitionCheckBox.on
            newDictionary.isExtraInfo = sourceViewController.extraInfoCheckBox.on
            newDictionary.isSynonym = sourceViewController.synonymCheckBox.on
            newDictionary.isExample = sourceViewController.exampleCheckBox.on
            
            do {
                try context.save()
                dictionaries += [newDictionary]
                dictionariesTableView.reloadData()
            } catch let error as NSError {
                print("Unresolved error during creating dictionary \(error), \(error.userInfo)")
            }
            
        } else {
            
            guard let dictionary = sourceViewController.dictionary else { return }
            
            if let name = sourceViewController.dictionaryNameTextField.text {
                dictionary.name = name
            } else {
                dictionary.name = "Unknowed"
            }
            
            dictionary.dateOfLastChanges = NSDate()
            dictionary.isTranslation = sourceViewController.translationCheckBox.on
            dictionary.isDefinition = sourceViewController.definitionCheckBox.on
            dictionary.isExtraInfo = sourceViewController.extraInfoCheckBox.on
            dictionary.isSynonym = sourceViewController.synonymCheckBox.on
            dictionary.isExample = sourceViewController.exampleCheckBox.on
            
            do {
                try context.save()
                dictionariesTableView.reloadData()
            } catch let error as NSError {
                print("Unresolved error during creating dictionary \(error), \(error.userInfo)")
            }
        }
        
        
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        gettingListOfDictionaries()
        
        self.dictionariesTableView.rowHeight = 60.0
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gettingListOfDictionaries()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DictionaryCell", for: indexPath) as! DictionaryTableViewCell
        
        cell.dictionary = dictionaries[indexPath.row]
        
        return cell
    }
    
    // Mark: - TableDelegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletingDictionaryFromTable(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
            guard self.dictionaries[index.row].name != nil else { return }
            
            self.performSegue(withIdentifier: "showDictionaryProperties", sender: self.dictionariesTableView.cellForRow(at: index))
        }
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, index) in
            self.deletingDictionaryFromTable(at: indexPath.row)
        }
        
        return [delete, edit]
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "openDictionarySegue"?:
            print("try make segue")
            guard let wvc = segue.destination as? WordsViewController else { return }
            
            print ("destination correct")
            
            guard let cell = sender as? DictionaryTableViewCell, let indexPath = dictionariesTableView.indexPath(for: cell) else { return }
            
            wvc.currentDictionary = dictionaries[indexPath.row]
            
            print("done segue")
        case "newDictionaryProperties"? :
            guard let dpvc = segue.destination as? DictionaryPropertiesViewController else { return }
            
            dpvc.modalPresentationStyle = .overCurrentContext
            
        case "showDictionaryProperties"?:
            guard let dpvc = segue.destination as? DictionaryPropertiesViewController else { return }
            
            guard let cell = sender as? UITableViewCell, let indexPath = dictionariesTableView.indexPath(for: cell) else { return }
            
            dpvc.modalPresentationStyle = .overCurrentContext
            dpvc.dictionary = dictionaries[indexPath.row]
            
        default:
            break
        }
    }
    
    
}

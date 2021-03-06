//
//  DictionariesViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 15/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift

class DictionariesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    let realm = try! Realm()
    
    /*****************************************************
     ****** List of dictionareis located at databse ******
     *****************************************************/
    fileprivate var dictionaries : Results<RealmDictionary>?

    fileprivate var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    fileprivate lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    /****************************************************************
     ****** Dictionary that has keys for dictionary properties ******
     ****************************************************************/
    fileprivate let dictionaryFlags:  [String : Int] = [ "Translation" : 0,
                                                        "Definition" : 1,
                                                         "ExtraInfo" : 2,
                                                         "Synonym" : 3,
                                                         "Example" : 4]
    
    // MARK: - Methods
    
    /**************************************************
     ****** Deleting of dictionary from database ******
     **************************************************/
    fileprivate func deletingDictionaryFromTable(at index:Int){
        
        guard let dictionaries = dictionaries else { return }
        
        let dictionaryToRemove = dictionaries[index]
        
        try! realm.write {
            realm.delete(dictionaryToRemove)
            dictionariesTableView.reloadData()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var dictionariesTableView: UITableView!
    
    @IBOutlet var dictionaryProperties: UIView!
    @IBOutlet weak var dictionaryPropertiesTitle: UILabel!
    @IBOutlet weak var dictionaryNameTextField: UITextField!
    @IBOutlet var dictionaryFlagsCheckBoxes: [BEMCheckBox]!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var nonDictionariesBGImage: UIImageView!
    @IBOutlet weak var nonDictionaryStack: UIStackView!
    
    // MARK: - Actions
    
    @IBAction func cancelButtonWasTapped(segue: UIStoryboardSegue){
        
    }
    
    /***********************************************************
     ****** Addeding new dictionary to dictionaries table ******
     ***********************************************************/
    @IBAction func saveButtonWasTapped(segue: UIStoryboardSegue){
       
        func getDictionryNameByField(_ field: UITextField ) -> String{
            guard let name = field.text, !name.isEmpty else {
                return NSLocalizedString("Unknown", comment: "Dictionary without name")
            }
            
            return name
        }
        
        guard let sourceViewController = segue.source as? DictionaryPropertiesViewController else { return }
        
        if sourceViewController.newDictionary {
            let newDictionary = RealmDictionary()
            
            newDictionary.name = getDictionryNameByField(sourceViewController.dictionaryNameTextField)
            newDictionary.dateOfCreation = Date()
            newDictionary.dateOfLastChanges = newDictionary.dateOfCreation
            newDictionary.numberOfLearnedWords = 0
            newDictionary.isTranslation = sourceViewController.translationCheckBox.on
            newDictionary.isDefinition = sourceViewController.definitionCheckBox.on
            newDictionary.isExtraInfo = sourceViewController.extraInfoCheckBox.on
            newDictionary.isSynonym = sourceViewController.synonymCheckBox.on
            newDictionary.isExample = sourceViewController.exampleCheckBox.on
            
            try! realm.write {
                realm.add(newDictionary)
            }
            
            dictionariesTableView.reloadData()
            
        } else {
            
           guard let dictionary = sourceViewController.dictionary else { return }
            
            try! realm.write {
                if let name = sourceViewController.dictionaryNameTextField.text {
                    dictionary.name = name
                } else {
                    dictionary.name = NSLocalizedString("Unknown", comment: "Dictionary without name")
                }
                
                dictionary.dateOfLastChanges = Date()
                dictionary.isTranslation = sourceViewController.translationCheckBox.on
                dictionary.isDefinition = sourceViewController.definitionCheckBox.on
                dictionary.isExtraInfo = sourceViewController.extraInfoCheckBox.on
                dictionary.isSynonym = sourceViewController.synonymCheckBox.on
                dictionary.isExample = sourceViewController.exampleCheckBox.on
                
                dictionariesTableView.reloadData()
            }
        }
        
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
       //gettingListOfDictionaries()
        
        
        self.dictionariesTableView.rowHeight = 60.0
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dictionaries = realm.objects(RealmDictionary.self)
        dictionariesTableView.reloadData()
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
        guard let dictionaries = dictionaries else {
            nonDictionaryStack.isHidden = false
            UIView.animate(withDuration: 2) {
                self.nonDictionaryStack.alpha = 1
                tableView.alpha = 0;
            }
            tableView.isHidden = true
            return 0
        }
        
        if (dictionaries.count <= 0) {
            nonDictionaryStack.isHidden = false
            UIView.animate(withDuration: 2) {
                self.nonDictionaryStack.alpha = 1
                tableView.alpha = 0;
            }
            tableView.isHidden = true
        } else {
            tableView.isHidden = false;
            UIView.animate(withDuration: 2) {
                self.nonDictionaryStack.alpha = 0
                tableView.alpha = 1
            }
            self.nonDictionaryStack.isHidden = true
        }
        return dictionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DictionaryCell", for: indexPath) as! DictionaryTableViewCell
        
        guard let dictionaries = dictionaries else { return cell }
        
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
        let edit = UITableViewRowAction(style: .normal, title: NSLocalizedString("Edit", comment: "Edit dictionary table view edit action") ) { (action, index) in
            
            self.performSegue(withIdentifier: "showDictionaryProperties", sender: self.dictionariesTableView.cellForRow(at: index))
        }
        
        let delete = UITableViewRowAction(style: .default, title: NSLocalizedString("Delete", comment: "Delete dictionary table view edit action")) { (action, index) in
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
            guard let wvc = segue.destination as? WordsViewController else { return }
            
            guard let cell = sender as? DictionaryTableViewCell, let indexPath = dictionariesTableView.indexPath(for: cell), let dictionaries = dictionaries else { return }
            
            wvc.currentDictionary = dictionaries[indexPath.row]

        case "newDictionaryProperties"? :
            guard let dpvc = segue.destination as? DictionaryPropertiesViewController else { return }
            
            dpvc.modalPresentationStyle = .overCurrentContext
            
        case "showDictionaryProperties"?:
            guard let dpvc = segue.destination as? DictionaryPropertiesViewController else { return }
            
            guard let cell = sender as? UITableViewCell, let indexPath = dictionariesTableView.indexPath(for: cell) else { return }
            
            dpvc.modalPresentationStyle = .overCurrentContext
            dpvc.dictionary = dictionaries?[indexPath.row]
            
        default:
            break
        }
    }
    
    
}

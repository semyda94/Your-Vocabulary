//
//  WordViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 5/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class WordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AddNewFieldDelegate, SaveCancelWordTableContentDelegate {
    
    // MARK: - Properties
    
    fileprivate var managedContext : NSManagedObjectContext? {
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    var currentDictionary: Dictionary?
    var currentWord: Word?
    
    fileprivate var sections = [[(value: String? , type: typeOfCell)]]()
    fileprivate var sectionsName = ["Translations", "Definitions", "Extra information", "Synonyms", "Examples"]
    
    // MARK: - Outlets.
    @IBOutlet weak var fieldsTableView: UITableView!
    
    // MARK: - Methods
    
    func setDefaultData() -> Int {
        
        print("Setting word sections and content")
        
        guard let dictionary = currentDictionary else { return -1 }
        
        //Word section
        sections.append([("Word", typeOfCell.titleFollowingFields), (nil, .field)])
        
        //Translation
        if dictionary.isTranslation {
            sections.append([(sectionsName[0], typeOfCell.titleFollowingFields), (nil, .field), (nil, .addFieldButton)])
        }
        
        //Definition
        if dictionary.isDefinition {
            sections.append([(sectionsName[1], typeOfCell.titleFollowingFields), (nil, .field), (nil, .addFieldButton)])
        }
        
        //ExtraInfo
        if dictionary.isExtraInfo {
            sections.append([(sectionsName[2], typeOfCell.titleFollowingFields), (nil, .field), (nil, .addFieldButton)])
        }
        
        //Synonym
        if dictionary.isSynonym {
            sections.append([(sectionsName[3], typeOfCell.titleFollowingFields), (nil, .field), (nil, .addFieldButton)])
        }
        
        //Example
        if dictionary.isExample {
            sections.append([(sectionsName[4], typeOfCell.titleFollowingFields), (nil, .field), (nil, .addFieldButton)])
        }
        
        //Save button
        sections.append([("EndButtons", typeOfCell.SaveCancelButtons)])
        
        print("Set number of word section : \(sections.count)")
        
        return 0
    }
    
    func setData(forWord word: Word) -> Int{
        
        guard let dictionary = currentDictionary else { return -1 }
        var sectionContent = [(value: String?, type: WordViewController.typeOfCell)]()
        
        //Word section
        sections.append([("Word", typeOfCell.titleFollowingFields), (word.word, .field)])
        
        //Translation
        if dictionary.isTranslation , let translations = word.translations?.allObjects as? [Translation] {
            sectionContent.removeAll()
            sectionContent.append((sectionsName[0], typeOfCell.titleFollowingFields))
            
            for translation in translations {
                sectionContent.append((translation.text , typeOfCell.field))
            }
            
            sectionContent.append((nil, typeOfCell.addFieldButton))
            sections.append(sectionContent)
        }
        
        //Definition
        if dictionary.isDefinition, let definitions = word.definitions?.allObjects as? [Definition] {
            sectionContent.removeAll()
            sectionContent.append((sectionsName[1], typeOfCell.titleFollowingFields))
            
            for definition in definitions {
                sectionContent.append((definition.text, typeOfCell.field))
            }
            
            sectionContent.append((nil, typeOfCell.addFieldButton))
            sections.append(sectionContent)
        }
        
        //ExtraInfo
        if dictionary.isExtraInfo, let extraInfos = word.extraInfos?.allObjects as? [ExtraInfo] {
            sectionContent.removeAll()
            sectionContent.append((sectionsName[2], typeOfCell.titleFollowingFields))
            
            for extraInfo in extraInfos {
                sectionContent.append((extraInfo.text, typeOfCell.field))
            }
            
            sectionContent.append((nil, typeOfCell.addFieldButton))
            sections.append(sectionContent)
        }
        
        //Synonym
        if dictionary.isSynonym, let synonyms = word.synonyms?.allObjects as? [Synonym] {
            sectionContent.removeAll()
            sectionContent.append((sectionsName[3], typeOfCell.titleFollowingFields))
            
            for synonym in synonyms {
                sectionContent.append((synonym.text, typeOfCell.field))
            }
            
            sectionContent.append((nil, typeOfCell.addFieldButton))
            sections.append(sectionContent)
        }
        
        //Example
        if dictionary.isExample, let examples = word.examples?.allObjects as? [Example] {
            sectionContent.removeAll()
            sectionContent.append((sectionsName[4], typeOfCell.titleFollowingFields))
            
            for example in examples {
                sectionContent.append((example.text, typeOfCell.field))
            }
            
            sectionContent.append((nil, typeOfCell.addFieldButton))
            sections.append(sectionContent)
        }
        
        //Save button
        sections.append([("EndButtons", typeOfCell.SaveCancelButtons)])
        
        return 0
    }
    
    // MARK: - IBActions
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.title = "New word"
        
        if let word = currentWord {
            if setData(forWord: word) < 0 {
                return
            }
        } else {
            if setDefaultData() < 0 {
                return
            }
        }
        
        // Set automatic dimensions for row height
        fieldsTableView.rowHeight = UITableViewAutomaticDimension
        fieldsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section][indexPath.row].type {
        case .titleFollowingFields:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "titleFollowingFieldsCell", for: indexPath) as? WordTitleFollowingFieldsCellTableViewCell else { break }
            cell.titleLabel.text = sections[indexPath.section][indexPath.row].value
            return cell
            
        case .field:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell", for: indexPath) as? WordFieldsTableViewCell else { break }
            cell.textField.delegate = self
            cell.textField.text = sections[indexPath.section][indexPath.row].value
            cell.textField.placeholder = "Enter \(sections[indexPath.section].first?.value!.lowercased() ?? "None")"
            return cell
            
        case .addFieldButton:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addFieldButtonCell", for: indexPath) as? WordAddFieldButtonTableViewCell else { break }
            
            cell.delegate = self
            return cell
            
        case .SaveCancelButtons:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "saveCancelButtonsCell", for: indexPath) as? WordSaveCancelButtonsTableViewCell else { break }
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    //MARK: - UITextFieldDelegate implemenation methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let cell = textField.superview?.superview as? WordFieldsTableViewCell, let indexPath = fieldsTableView.indexPath(for: cell) else { return true }
        
        sections[indexPath.section][indexPath.row].value = textField.text
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview as? WordFieldsTableViewCell, let indexPath = fieldsTableView.indexPath(for: cell) else { return }
        
        sections[indexPath.section][indexPath.row].value = textField.text
    }
    
    // MARK: - AddNewFieldDelegate implementation
    
    func addFieldBeforeRow(_ row: UITableViewCell) {
        guard let indexPath = fieldsTableView.indexPath(for: row) else { return }
        
        sections[indexPath.section].insert((nil, .field), at: indexPath.row - 1)
        
        fieldsTableView.reloadData()
    }

    // MARK: - SaveCancelWordTableContentDelegate implementation
    
    func saveContent() {

        guard let dictionary = currentDictionary else { return }

        guard let context = managedContext else { return }

        guard let entityWord = NSEntityDescription.entity(forEntityName: "Word", in: context) else { return }

        let newWord = Word(entity: entityWord, insertInto: context)

        newWord.word = sections[0][1].value
        newWord.dateCreation = NSDate()
        newWord.dateOfLastChanges = NSDate()
        newWord.isLearned = false
        
        for section in sections {
            guard let sectionName = section[0].value else { break }
            if sectionsName.contains(sectionName) {
                for element in section[1..<section.count - 1] {
                    switch sectionName {
                    case sectionsName[0]:
                        guard let entity = NSEntityDescription.entity(forEntityName: "Translation", in: context) else { break }
                        let newTranslation = Translation(entity: entity, insertInto: context)
                        newTranslation.text = element.value
                        newWord.addToTranslations(newTranslation)
                    case sectionsName[1]:
                        guard let entity = NSEntityDescription.entity(forEntityName: "Definition", in: context) else { break }
                        let newDefinition = Definition(entity: entity, insertInto: context)
                        newDefinition.text = element.value
                        newWord.addToDefinitions(newDefinition)
                    case sectionsName[2]:
                       guard let entity = NSEntityDescription.entity(forEntityName: "ExtraInfo", in: context) else { break }
                        let newExtraInfo = ExtraInfo(entity: entity, insertInto: context)
                        newExtraInfo.text = element.value
                        newWord.addToExtraInfos(newExtraInfo)
                    case sectionsName[3]:
                         guard let entity = NSEntityDescription.entity(forEntityName: "Synonym", in: context) else { break }
                        let newSynonym = Synonym(entity: entity, insertInto: context)
                        newSynonym.text = element.value
                        newWord.addToSynonyms(newSynonym)
                    case sectionsName[4]:
                        guard let entity = NSEntityDescription.entity(forEntityName: "Example", in: context) else { break }
                        let newExample = Example(entity: entity, insertInto: context)
                        newExample.text = element.value
                        newWord.addToExamples(newExample)
                    default:
                        break;
                    }
                }
            }
        }

        dictionary.addToWords(newWord)
        dictionary.dateOfLastChanges = NSDate()
        dictionary.numberOfWords += 1
    }
    
    func cancelChanges() {
        print("Cancel changes for word")
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

extension WordViewController {
    
    enum typeOfCell {
        case titleFollowingFields
        case field
        case addFieldButton
        case SaveCancelButtons
    }
    
}

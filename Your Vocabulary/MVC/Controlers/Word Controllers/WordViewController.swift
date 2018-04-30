//
//  WordViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 5/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class WordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, AddNewFieldDelegate, SaveCancelWordTableContentDelegate {
    
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
    fileprivate var sectionsName = [NSLocalizedString("Translations", comment: "Title for translations properties in word view") ,NSLocalizedString("Definitions", comment: "Title for definitions properties in word view"), NSLocalizedString("Extra information", comment: "Title for extra information properties in word view"), NSLocalizedString("Synonyms", comment: "Title for synonyms properties in word view"), NSLocalizedString("Examples", comment: "Title for examples properties in word view")]
    
    // MARK: - Outlets.
    @IBOutlet weak var fieldsTableView: UITableView!
    
    // MARK: - Methods
    
    func setDefaultData() -> Int {
        
        print("Setting word sections and content")
        
        guard let dictionary = currentDictionary else { return -1 }
        
        //Word section
        sections.append([(NSLocalizedString("Word", comment: "Title for word in word view"), typeOfCell.titleFollowingFields), (nil, .field)])
        
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
        sections.append([(NSLocalizedString("Word", comment: "Title for word in word view"), typeOfCell.titleFollowingFields), (word.word, .field)])
        
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
    
    fileprivate func deletingFiledCellFromTable(at index: IndexPath) {
        sections[index.section].remove(at: index.row)
        fieldsTableView.deleteRows(at: [index], with: .fade)
        fieldsTableView.reloadData()
    }
    
    // MARK: - IBActions
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            fieldsTableView.contentInset = UIEdgeInsets.zero
        } else {
            fieldsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        fieldsTableView.scrollIndicatorInsets = fieldsTableView.contentInset
    }
    
    @objc func hideKeyboard() {
        fieldsTableView.endEditing(true);
    }
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change table view frame size during appearance/hidden of keyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //set gesture of hidden keyboard after tap somewhere else
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WordViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.title = NSLocalizedString("New word", comment: "Title of navigation bar for during creating new word")
        
        if let word = currentWord {
            if setData(forWord: word) < 0 {
                return
            }
        } else {
            if setDefaultData() < 0 {
                return
            }
        }
        
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
            cell.textView.delegate = self
            cell.textView.text = sections[indexPath.section][indexPath.row].value
            //cell.textView.plas = "Enter \(sections[indexPath.section].first?.value!.lowercased() ?? "None")"
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
    
    //MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if sections[indexPath.section][indexPath.row].type == .field && sections[indexPath.section].count > 3 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: NSLocalizedString("Delete", comment: "Delete title properties in word view")) { (action, index) in
            self.deletingFiledCellFromTable(at: indexPath)
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section][indexPath.row].type == .addFieldButton { return 22 }
        
        return UITableViewAutomaticDimension
    }

    //MARK: - UITextViewDelegate implementation
    func textViewDidChange(_ textView: UITextView) {
        guard let cell = textView.superview?.superview as? WordFieldsTableViewCell, let index = fieldsTableView.indexPath(for: cell) else { return }
        
        sections[index.section][index.row].value = textView.text
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if textView.frame.height != newSize.height {
            var newFrame = textView.frame
            newFrame.size = CGSize(width: fixedWidth, height: newSize.height)
            textView.frame = newFrame
        
            var newCellFrame = cell.frame
            newCellFrame.size = CGSize(width: newCellFrame.size.width, height: newSize.height)
            
            fieldsTableView.beginUpdates()
            fieldsTableView.endUpdates()
        }
    }
   /*
    func textViewDidEndEditing(_ textView: UITextView) {
        print("enter into textViewDidEndEditing")
        textView.resignFirstResponder()
        guard let cell = textView.superview?.superview as? WordFieldsTableViewCell, let index = fieldsTableView.indexPath(for: cell) else { return }
        
        sections[index.section][index.row].value = textView.text
        print("was saved \(textView.text) for index \(index)")
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        guard let cell = textView.superview?.superview as? WordFieldsTableViewCell, let index = fieldsTableView.indexPath(for: cell) else { return true}
        
        sections[index.section][index.row].value = textView.text
        
        return true
    }
 */
    // MARK: - AddNewFieldDelegate implementation
    
    func addFieldBeforeRow(_ row: UITableViewCell) {
        guard let indexPath = fieldsTableView.indexPath(for: row) else { return }
        
        sections[indexPath.section].insert((nil, .field), at: indexPath.row)
        
        fieldsTableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        //fieldsTableView.reloadData()
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
                        guard let entity = NSEntityDescription.entity(forEntityName: "Translation", in: context) else {print("translation entity wasn't created"); break }
                        let newTranslation = Translation(entity: entity, insertInto: context)
                        newTranslation.text = element.value
                        newWord.addToTranslations(newTranslation)
                        print("translation was added into word")
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

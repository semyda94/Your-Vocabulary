//
//  WordViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 5/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData

class WordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, AddNewFieldDelegate, SaveCancelWordTableContentDelegate {
    
    // MARK: - Properties
    
    fileprivate var realm = try! Realm()
    
    var currentDictionary: RealmDictionary?
    var currentWord: RealmWord?
    
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
    
    func setData(forWord word: RealmWord) -> Int{
        
        guard let dictionary = currentDictionary else { return -1 }
        var sectionContent = [(value: String?, type: WordViewController.typeOfCell)]()
        
        //Word section
        sections.append([(NSLocalizedString("Word", comment: "Title for word in word view"), typeOfCell.titleFollowingFields), (word.word, .field)])
        
        //Translation
        if dictionary.isTranslation {
            sectionContent.removeAll()
            sectionContent.append((sectionsName[0], typeOfCell.titleFollowingFields))
            
            if word.translations.count > 1 {
                
                for translation in word.translations {
                    sectionContent.append((translation , typeOfCell.field))
                }
            } else {
                sectionContent.append((word.translations[0] , typeOfCell.field))
            }
            
            sectionContent.append((nil, typeOfCell.addFieldButton))
            sections.append(sectionContent)
        }
        
        //Definition
        if dictionary.isDefinition {
            sectionContent.removeAll()
            sectionContent.append((sectionsName[1], typeOfCell.titleFollowingFields))
            
            if word.definitions.count > 1 {
                
                for definition in word.definitions {
                    sectionContent.append((definition , typeOfCell.field))
                }
            } else {
                sectionContent.append((word.definitions[0] , typeOfCell.field))
            }
            
            sectionContent.append((nil, typeOfCell.addFieldButton))
            sections.append(sectionContent)
        }
        
        //ExtraInfo
        if dictionary.isExtraInfo {
            sectionContent.removeAll()
            sectionContent.append((sectionsName[2], typeOfCell.titleFollowingFields))
            
            if word.extraInfos.count > 1 {
                
                for extraInfo in word.extraInfos {
                    sectionContent.append((extraInfo , typeOfCell.field))
                }
            } else {
                sectionContent.append((word.extraInfos[0] , typeOfCell.field))
            }
            
            sectionContent.append((nil, typeOfCell.addFieldButton))
            sections.append(sectionContent)
        }
        
        //Synonym
        if dictionary.isSynonym {
            sectionContent.removeAll()
            sectionContent.append((sectionsName[3], typeOfCell.titleFollowingFields))
            
            if word.synonyms.count > 1 {
                
                for synonym in word.synonyms {
                    sectionContent.append((synonym , typeOfCell.field))
                }
            } else {
                sectionContent.append((word.synonyms[0] , typeOfCell.field))
            }
            
            sectionContent.append((nil, typeOfCell.addFieldButton))
            sections.append(sectionContent)
        }
        
        //Example
        if dictionary.isExample {
            sectionContent.removeAll()
            sectionContent.append((sectionsName[4], typeOfCell.titleFollowingFields))
            
            if word.examples.count > 1 {
        
                for example in word.examples {
                    sectionContent.append((example , typeOfCell.field))
                }
            } else {
                sectionContent.append((word.examples[0] , typeOfCell.field))
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
        
        guard let currentDictionary = currentDictionary else { return }
        
        if currentWord == nil {
            currentWord = RealmWord()
            try! realm.write {
                currentDictionary.words.append(currentWord!)
                currentDictionary.dateOfLastChanges = Date()
            }
        } else {
            try! realm.write {
                currentWord!.translations.removeAll()
                currentWord!.definitions.removeAll()
                currentWord!.extraInfos.removeAll()
                currentWord!.synonyms.removeAll()
                currentWord!.examples.removeAll()
            }
        }
        
        guard let currentWord = currentWord else { return }
        
        var word = NSLocalizedString("Unknown", comment: "Unknown name for word with out seted word name")
        try! realm.write {
            if sections[0][1].value != nil {
                word = sections[0][1].value!
            }
            
            currentWord.word = word
            currentWord.dateOfLastChanges = Date()
            currentWord.isLearned = false
            
            for section in sections {
                
                guard let sectionName = section[0].value else { break }
                if sectionsName.contains(sectionName) {
                    for element in section[1..<section.count - 1] {
                        switch sectionName {
                        case sectionsName[0]:
                            currentWord.translations.append(element.value)
                        case sectionsName[1]:
                            currentWord.definitions.append(element.value)
                        case sectionsName[2]:
                            currentWord.extraInfos.append(element.value)
                        case sectionsName[3]:
                            currentWord.synonyms.append(element.value)
                        case sectionsName[4]:
                            currentWord.examples.append(element.value)
                        default:
                            break;
                        }
                    }
                }
            }
        }
        
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

//
//  SettingsTableViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 14/03/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import RealmSwift
import SwiftyJSON

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Propertires
    
    fileprivate let realm = try! Realm()
    
    fileprivate let settingsCells : [String : IndexPath] = ["Notifications" : IndexPath(row: 1, section: 0),
                                                            "Create Backup" : IndexPath(row: 0, section: 1),
                                                            "Import" : IndexPath(row: 1, section: 1),
                                                            "Reset" : IndexPath(row: 2, section: 1),
                                                            "Guide" : IndexPath(row: 0, section: 2)]
    fileprivate let backupDirName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Backups")
    
    // MARK: - Methods
    
    fileprivate func emptyOrDoesntExistBackupDir() {
        let alertControllerTitle = NSLocalizedString("No backups", comment: "Title of alert when app doesn't have any backups")
        let alertControllerMessage = NSLocalizedString("At this moment app doesn't have any backup files", comment: "Message of alert when app doesn;t have any backups")
        let alertController = UIAlertController(title: alertControllerTitle, message: alertControllerMessage, preferredStyle: .alert)
        
        let alertDoneAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Title of action when app doesn't have any backup files"), style: .default, handler: nil)
        
        alertController.addAction(alertDoneAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func creatingBackUp(forDictionaries dictionaries : [RealmDictionary], withFileName fileName : String) {
        
        guard let backupDirName = backupDirName else { return }
        
        if !FileManager.default.fileExists(atPath: backupDirName.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: backupDirName, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error during creating Backups directory:\n \(error)")
            }
        }
        
        let fileURL = backupDirName.appendingPathComponent(fileName)
        
        print("Backup file: \(fileURL)")
        
        let jsonString = generateJSONStringBaseOn(dictionaries: dictionaries)
        
        do {
            try jsonString.write(to: fileURL, atomically: false, encoding: .utf8)
        } catch let error as NSError {
            print("Error during exporting database : \(error)")
        }
        
    }
    
    fileprivate func showCreateBackupAlertController(forDictionaries dictionaries: [RealmDictionary]) {
        
        let alertTitle = NSLocalizedString("Create Backup", comment: "Title for alert that creating backup file")
        let alertMessage = NSLocalizedString("Enter in field below name of backup file.", comment: "Message for alert that creating backup file")
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("Backup name", comment: "Placeholder string for text field that required a backup name")
            textField.text = nil
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action for alert during cration backup"), style: .cancel, handler: nil)
        
        let createAction = UIAlertAction(title: NSLocalizedString("Create", comment: "Create action for alert during cration backup"), style: .default) { (alert) in
            guard let backupFileName = alertController.textFields![0].text else { return }
            
            self.creatingBackUp(forDictionaries: dictionaries, withFileName: backupFileName)
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    fileprivate func generateJSONStringBaseOn(dictionaries : [RealmDictionary]) -> String {
        
        var jsonString = "{\n"
        
        jsonString += "\t\"realm_version\" : \(realm.configuration.schemaVersion),\n"
        
        jsonString += "\t\"dictionaries\" :\n"
        jsonString += "\t[\n"
        
        for (index, dictionary) in dictionaries.enumerated() {
            jsonString += "\t\t{\n"
            
            jsonString += "\t\t\t\"name\" : \"\(dictionary.name)\",\n"
            jsonString += "\t\t\t\"numberOfLearnedWords\" : \(dictionary.numberOfLearnedWords),\n"
            
            jsonString += "\t\t\t\"dateOfCreation\" : \"\(dictionary.dateOfCreation)\",\n"
            jsonString += "\t\t\t\"dateOfLastChanges\" : \"\(dictionary.dateOfLastChanges)\",\n"
            
            jsonString += "\t\t\t\"isTranslation\" : \(dictionary.isTranslation),\n"
            jsonString += "\t\t\t\"isDefinition\" : \(dictionary.isDefinition),\n"
            jsonString += "\t\t\t\"isExtraInfo\" : \(dictionary.isExtraInfo),\n"
            jsonString += "\t\t\t\"isSynonym\" : \(dictionary.isSynonym),\n"
            jsonString += "\t\t\t\"isExample\" : \(dictionary.isExample),\n"
            
            jsonString += "\t\t\t\"words\" :\n"
            jsonString += "\t\t\t[\n"
            
            for (wordIndex, word) in dictionary.words.enumerated() {
                jsonString += "\t\t\t\t{\n"
                
                jsonString += "\t\t\t\t\t\"word\" : \"\(word.word)\",\n"
                jsonString += "\t\t\t\t\t\"isLearned\" : \(word.isLearned),\n"
                
                jsonString += "\t\t\t\t\t\"dateOfCreation\" : \"\(word.dateOfCreation)\",\n"
                jsonString += "\t\t\t\t\t\"dateOfLastChanges\" : \"\(word.dateOfLastChanges)\",\n"
                
                jsonString += "\t\t\t\t\t\"translations\" :\n"
                jsonString += "\t\t\t\t\t[\n"
                
                let translations = Array(word.translations)
                
                for (translationIndex, translation) in translations.enumerated() {
                    
                    if let translation = translation {
                        jsonString += "\t\t\t\t\t\t\"\(translation)\""
                    } else {
                        jsonString += "\t\t\t\t\t\tnull"
                    }
                    
                    if translationIndex == word.translations.count - 1 {
                        jsonString += "\n"
                    } else {
                        jsonString += ",\n"
                    }
                    
                }
                jsonString += "\t\t\t\t\t],\n"
                
                jsonString += "\t\t\t\t\t\"definitions\" :\n"
                jsonString += "\t\t\t\t\t[\n"
                
                let definitions = Array(word.definitions)
                
                for (definitionIndex, definition) in definitions.enumerated() {
                    
                    if let definition = definition {
                        jsonString += "\t\t\t\t\t\t\"\(definition)\""
                    } else {
                        jsonString += "\t\t\t\t\t\tnull"
                    }
                    
                    if definitionIndex == definitions.count - 1 {
                        jsonString += "\n"
                    } else {
                        jsonString += ",\n"
                    }
                    
                }
                jsonString += "\t\t\t\t\t],\n"
                
                jsonString += "\t\t\t\t\t\"extraInfos\" :\n"
                jsonString += "\t\t\t\t\t[\n"
                
                let extraInfos = Array(word.extraInfos)
                
                for (extraInfoIndex, extraInfo) in extraInfos.enumerated() {
                    
                    if let extraInfo = extraInfo {
                        jsonString += "\t\t\t\t\t\t\"\(extraInfo)\""
                    } else {
                        jsonString += "\t\t\t\t\t\tnull"
                    }
                    
                    if extraInfoIndex == extraInfos.count - 1 {
                        jsonString += "\n"
                    } else {
                        jsonString += ",\n"
                    }
                    
                }
                jsonString += "\t\t\t\t\t],\n"
                
                jsonString += "\t\t\t\t\t\"synonyms\" :\n"
                jsonString += "\t\t\t\t\t[\n"
                
                let synonyms = Array(word.synonyms)
                
                for (synonymIndex, synonym) in synonyms.enumerated() {
                    
                    if let synonym = synonym {
                        jsonString += "\t\t\t\t\t\t\"\(synonym)\""
                    } else {
                        jsonString += "\t\t\t\t\t\tnull"
                    }
                    
                    if synonymIndex == synonyms.count - 1 {
                        jsonString += "\n"
                    } else {
                        jsonString += ",\n"
                    }
                    
                }
                jsonString += "\t\t\t\t\t],\n"
                
                jsonString += "\t\t\t\t\t\"examples\" :\n"
                jsonString += "\t\t\t\t\t[\n"
                
                let examples = Array(word.examples)
                
                for (exampleIndex, example) in examples.enumerated() {
                    
                    if let example = example {
                        jsonString += "\t\t\t\t\t\t\"\(example)\""
                    } else {
                        jsonString += "\t\t\t\t\t\tnull"
                    }
                    
                    if exampleIndex == examples.count - 1 {
                        jsonString += "\n"
                    } else {
                        jsonString += ",\n"
                    }
                    
                }
                jsonString += "\t\t\t\t\t]\n"
                
                if wordIndex == dictionary.words.count - 1 {
                    jsonString += "\t\t\t\t}\n"
                } else {
                    jsonString += "\t\t\t\t},\n"
                }
            }
            
            jsonString += "\t\t\t]\n"
            
            
            if index == dictionaries.count - 1 {
                jsonString += "\t\t}\n"
            } else {
                jsonString += "\t\t},\n"
            }
        }
        
        jsonString += "\t]\n"
        
        jsonString += "}"
        
        return jsonString
    }
    
    // MARK: - Unwind Segues
    
    @IBAction func finishRestoringBackup(segue: UIStoryboardSegue) {
        
    }
    
    
    // MARK : - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
            headerTitle.textLabel?.textAlignment = .center
            headerTitle.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            headerTitle.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.737254902, blue: 0.7058823529, alpha: 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        switch indexPath {
            
        case settingsCells["Notifications"] :
            
            let UNCenter = UNUserNotificationCenter.current()
            UNCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    
                }
            }
            
            //performSegue(withIdentifier: "showNotifications", sender: nil)
            /*
            var dateComponents = DateComponents()
            dateComponents.hour = 15
            dateComponents.minute = 26
            let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            triger.nextTriggerDate()
            
            let content = UNMutableNotificationContent()
            content.title = "Title test"
            content.body = "Test o the text in the body"
            content.categoryIdentifier = "customIdentifier"
            content.sound = UNNotificationSound.default()
            
            let request = UNNotificationRequest(identifier: "Test" , content: content, trigger: triger)
            
            UNCenter.add(request, withCompletionHandler: nil)*/
            
            
        case settingsCells["Create Backup"] :
            print("Start exporting of realm database")
            
            let dictionaries = realm.objects(RealmDictionary.self)
            
            if dictionaries.count < 1 {
                let alertController = UIAlertController(title: NSLocalizedString("Can not import", comment: "Title of error of exporting whole database"), message: NSLocalizedString("At this moment you don't have any dictionaries. For exporting database have to have at least one dictionary.", comment: "Message of allert action for error of exporting whole database"), preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Title of alert action when user dosn't have any dictionaries during exporting"), style: .cancel, handler: nil)
                
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
                
            } else {
                
                showCreateBackupAlertController(forDictionaries: Array(dictionaries))
            }
            
            print("End of Exporting of realm database")
            
        case settingsCells["Import"]:
            
            guard let backupDirName = backupDirName else { return }
            
                do {
                    if try !FileManager.default.contentsOfDirectory(at: backupDirName, includingPropertiesForKeys: nil).isEmpty {
                        performSegue(withIdentifier: "showBackups", sender: self)
                    } else {
                        emptyOrDoesntExistBackupDir()
                    }
                } catch let error as NSError {
                    emptyOrDoesntExistBackupDir()
                    print("Error during checking backupfilse\(error)")
                }

            // process files
            
            /*
             if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
             let fileURL = dir.appendingPathComponent(fileName)
             
             print("directory: \(fileURL)")
             
             
             }
             */
            
        case settingsCells["Reset"]:
            let alert = UIAlertController(title: "Reseting database", message: "Are you sure you want to delete all data?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { _ in
                try! self.realm.write {
                    self.realm.deleteAll()
                }
            }))
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: {
                tableView.deselectRow(at: indexPath, animated: true)
            })
            
        default:
            return
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showBackups":
            guard let stvc = segue.source as? SettingsTableViewController, let btvc = segue.destination as? BackupsTableViewController, let backupDirName = stvc.backupDirName else { return }
            
            let backups = try! FileManager.default.contentsOfDirectory(at: backupDirName, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            btvc.backups = backups
            
        default:
            break
        }
    }
    
    
}

//
//  SettingsTableViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 14/03/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class SettingsTableViewController: UITableViewController {

    // MARK : - Propertires
    
    fileprivate let realm = try! Realm()
    
    fileprivate let settingsCells : [String : (section: Int, row: Int)] = ["Export" : (1 , 0),
                                                                           "Import" : (1, 1),
                                                                           "Reset" : (1 , 2)]
    fileprivate let fileName = "DataBase.json"
    
    // MARK : - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case settingsCells["Export"]!.row :
                print("Start exporting of realm database")
                
                let dictionaries = realm.objects(RealmDictionary.self)
                
                if dictionaries.count < 1 {
                    let alertController = UIAlertController(title: NSLocalizedString("Can not import", comment: "Title of error of exporting whole database"), message: NSLocalizedString("At this moment you don't have any dictionaries. For exporting database have to have at least one dictionary.", comment: "Message of allert action for error of exporting whole database"), preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Title of alert action when user dosn't have any dictionaries during exporting"), style: .cancel, handler: nil)
                    
                    alertController.addAction(cancelAction)
                    
                    present(alertController, animated: true, completion: nil)
                    
                } else {
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
                    
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent(fileName)
                        
                        print("directory: \(fileURL)")
                        
                        do {
                            try jsonString.write(to: fileURL, atomically: false, encoding: .utf8)
                        } catch let error as NSError {
                            print("Error during exporting database : \(error)")
                        }
                        
                    }
                    
                    //print("JSON exported string:\n\(jsonString)")
                    
                }
                
                print("End of Exporting of realm database")
                
                
                /*
                guard let context = managedContext else { return }
                
                var dictionaries : [Dictionary]
                
                let request = NSFetchRequest<Dictionary>(entityName: "Dictionary")
                
                do {
                    let result = try context.fetch(request)
                    
                    dictionaries = result
                    
                } catch let error as NSError {
                    print("Unresolved error during fetching dictionary for export: \(error), \(error.userInfo)")
                }
                */
            case settingsCells["Import"]!.row:
                
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent(fileName)
                    
                    print("directory: \(fileURL)")
                    
                    do {
                        let jsonString = try String(contentsOf: fileURL, encoding: .utf8)
                        
                        if let data = jsonString.data(using: .utf8) {
                        
                            do {
                                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                                //print("Get json: \(json)")
                                
                                if let jsonDictionary = jsonObject as? [String : Any] {
                                    if let dictionariesJSONDictionary = jsonDictionary["dictionaries"] as? [[String : Any]] {
                                        for (inedex, dictionaryJSON) in dictionariesJSONDictionary.enumerated() {
                                            print("Dictionary \(inedex) : \(dictionaryJSON)\n")
                                        }
                                    }
                                }
                                
                            } catch let error as NSError {
                                print("error: \(error)")
                            }
                            
                        }
                        
                    }
                    catch {/* error handling here */}
                }
                
            case settingsCells["Reset"]!.row:
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

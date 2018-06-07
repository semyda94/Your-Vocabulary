//
//  BackupsTableViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 21/05/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift

class BackupsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var backups = [URL]()
    
    fileprivate let realm = try! Realm()
    // MARK: - Methods
    
    /***********************************************************************************
     ***************************** Restore Backup Methods ********************************
     ************************************************************************************/
    fileprivate func restoreBackup(FromFile backupFileURL: URL) {
        do {
            //Getting json string from url file
            let jsonString = try String(contentsOf: backupFileURL, encoding: .utf8)
            
            if let data = jsonString.data(using: .utf8) {
                
                // serialization of json data into realm objects
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    //print("Get json: \(json)")
                    
                    var importedDictionaries = [RealmDictionary]()
                    
                    if let jsonDictionary = jsonObject as? [String : Any], let dictionariesJSONDictionary = jsonDictionary["dictionaries"] as? [[String : Any]] {
                        for (_, dictionaryJSON) in dictionariesJSONDictionary.enumerated() {
                            let newImportedDictionary = RealmDictionary()
                            
                            newImportedDictionary.name = dictionaryJSON["name"] as! String
                            
                            newImportedDictionary.numberOfLearnedWords = dictionaryJSON["numberOfLearnedWords"] as! Int
                            /*
                             let dateFormatter = DateFormatter()
                             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                             
                             if let dictionaryDataOfCreation = dateFormatter.date(from: dictionaryJSON["dateOfCreation"] as! String) {
                             newImportedDictionary.dateOfCreation = dictionaryDataOfCreation
                             }
                             
                             if let dictionaryDateIfLastChanges = dateFormatter.date(from: dictionaryJSON["dateOfLastChanges"] as! String) {
                             newImportedDictionary.dateOfLastChanges = dictionaryDateIfLastChanges
                             }
                             */
                            newImportedDictionary.isTranslation = dictionaryJSON["isTranslation"] as! Bool
                            newImportedDictionary.isDefinition = dictionaryJSON["isDefinition"] as! Bool
                            newImportedDictionary.isExtraInfo = dictionaryJSON["isExtraInfo"] as! Bool
                            newImportedDictionary.isSynonym = dictionaryJSON["isSynonym"] as! Bool
                            newImportedDictionary.isExample = dictionaryJSON["isExample"] as! Bool
                            
                            if let wordsJSONDictionariesArray = dictionaryJSON["words"] as? [[String : Any]] {
                                let importedWords = List<RealmWord>()
                                
                                for word in wordsJSONDictionariesArray {
                                    let newImportedWord = RealmWord()
                                    
                                    newImportedWord.word = word["word"] as! String
                                    newImportedWord.isLearned = word["isLearned"] as! Bool
                                    
                                    if let translations = word["translations"] as? [String?] {
                                        newImportedWord.translations.append(objectsIn: translations)
                                    }
                                    
                                    if let translations = word["definitions"] as? [String?] {
                                        newImportedWord.definitions.append(objectsIn: translations)
                                    }
                                    
                                    if let translations = word["extraInfos"] as? [String?] {
                                        newImportedWord.extraInfos.append(objectsIn: translations)
                                    }
                                    
                                    if let translations = word["synonyms"] as? [String?] {
                                        newImportedWord.synonyms.append(objectsIn: translations)
                                    }
                                    
                                    if let translations = word["examples"] as? [String?] {
                                        newImportedWord.examples.append(objectsIn: translations)
                                    }
                                    
                                    importedWords.append(newImportedWord)
                                }
                                
                                newImportedDictionary.words = importedWords
                                print("got list of words")
                            }
                            
                            importedDictionaries.append(newImportedDictionary)
                            
                            print("newImportedDictionary: \(newImportedDictionary)")
                            
                        }
                        
                        try! realm.write {
                            realm.deleteAll()
                            
                            realm.add(importedDictionaries)
                        }
                    }
                } catch let error as NSError {
                    print("error: \(error)")
                }
                
            }
            
        }
        catch {/* error handling here */}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return backups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BackupCell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = backups[indexPath.row].lastPathComponent
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Restore backup from the file : \(backups[indexPath.row].absoluteString)")
        
        restoreBackup(FromFile: backups[indexPath.row])
        
        performSegue(withIdentifier: "finishRestoringFromBackup", sender: nil)
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

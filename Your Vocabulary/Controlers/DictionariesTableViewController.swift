//
//  DictionariesTableViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 4/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class DictionariesTableViewController: UITableViewController {

    // MARK: - Properties
    
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    var dictionaries = [Dictionary]()
    
    // MARK: - IBActions
    
    @IBAction func addNewDictionaryIntoTable(_ sender: UIBarButtonItem) {
     
        guard let context = managedContext, let entity = NSEntityDescription.entity(forEntityName: "Dictionary", in: context) else { return }
        
        let newDictionary = Dictionary(entity: entity, insertInto: context)
        
        newDictionary.setValue("undefined", forKey: "name")
        newDictionary.setValue(0, forKey: "numberOfWords")
        newDictionary.setValue(0, forKey: "numberofLearned")
        newDictionary.setValue(NSDate(), forKey: "dateOfCreation")
        newDictionary.setValue(NSDate(), forKey: "dateOfLastChanges")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error during save new dictionary: \(error), \(error.userInfo)")
        }
        
        dictionaries += [newDictionary]
        
        tableView.reloadData()
    }
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let context = managedContext else { return }
        
        let request = NSFetchRequest<Dictionary>(entityName: "Dictionary")
        
        do {
            let result = try context.fetch(request)
            
            for data in result {
                dictionaries += [data]
            }
            
        } catch let error as NSError {
            print("Unresolved error during fetch dictionary: \(error), \(error.userInfo)")
        }
        
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionaries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandartDictionaryCell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = dictionaries[indexPath.row].name
        cell.detailTextLabel?.text = "Count of words :\(dictionaries[indexPath.row].numberOfWords)"

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            guard let context = managedContext else { return }
            
            let dictionaryToRemove = dictionaries[indexPath.row]
            
            context.delete(dictionaryToRemove)
            dictionaries.remove(at: indexPath.row)
            
            do {
                try context.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError {
                print("Unresolved error during deleting dictionary \(error), \(error.userInfo)")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "dictionarySegue"?:
            if let cell = sender as? UITableViewCell {
                if let wtvc = segue.destination as? WordsTableViewController {
                    if let indexPath = tableView.indexPath(for: cell) {
                        wtvc.dictionaryName = dictionaries[indexPath.row].name
                       // wtvc.words = dictionaries[indexPath.row].words
                    }
                }
            }
        default:
            break
        }
    }

}

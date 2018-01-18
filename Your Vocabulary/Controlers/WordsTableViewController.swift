//
//  WordsTableViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 4/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class WordsTableViewController: UITableViewController {
    
    // MARK: - Properties

    private var managedContext: NSManagedObjectContext? {
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        
        return appDelegate.persistentContainer.viewContext
    }
    
    var currentDictionary: Dictionary? {
        didSet {
            navigationItem.title = currentDictionary?.name
        }
    }
    
    // MARK: - IBActions
    
    // MARK: - functions
    
    // action when we add new Word
    @objc func addTapped() {
        performSegue(withIdentifier: "newWord", sender: nil)
/*        guard let context = managedContext else { return }
        
        guard let dictionary = currentDictionary else { return }
        
        let newWord = Word(context: context)
        
        newWord.setValue("unknown", forKey: "word")
        newWord.setValue(false, forKey: "isLearned")
        newWord.setValue(NSDate(), forKey: "dataCreation")
        newWord.setValue("Bla bla bla", forKey: "definition")
       
        dictionary.addToWords(newWord)
        
        do {
            try context.save()
            tableView.reloadData()
        } catch let error as NSError {
            print("Unsolved error during add new word: \(error), \(error.userInfo)")
        }
 */
    }
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
        
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
        guard let count = currentDictionary?.words?.count else { return 0}
        
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandartDictionaryCell", for: indexPath)

        // Configure the cell...
        
        guard let words = currentDictionary?.words?.allObjects as? [Word] else { return cell }
        
        cell.textLabel?.text = words[indexPath.row].word
        
        if let d = words[indexPath.row].definition{
            cell.detailTextLabel?.text = d
        } else {
            if let t = words[indexPath.row].translation {
                cell.detailTextLabel?.text = t
            } else {
                cell.detailTextLabel?.text = "Non"
            }
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let words = currentDictionary?.words?.allObjects as? [Word] else { return }
            
            //print("count of words \(words.count)")
            managedContext?.delete(words[indexPath.row])
            
            do {
                try managedContext?.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError {
                print("Unsolved error during deleting word: \(error), \(error.userInfo)")
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let wvc = segue.destination as? WordViewController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                switch segue.identifier! {
                    case "showWord" :
                        guard let words = currentDictionary?.words?.allObjects as? [Word] else { return }
                        wvc.currentDictionary = currentDictionary
                        wvc.word = words[indexPath.row]
                    
                    case "newWord" :
                        wvc.currentDictionary = currentDictionary
                    
                    default: break
                }
            }
        }
    }

}

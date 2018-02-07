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
    
    @IBAction func cancelButtonWasTapped(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func saveButtonWasTapped(segue:
        UIStoryboardSegue){
        guard let sourceView = segue.source as? WordViewController else { return }
        
        guard let context = managedContext else {
            return
        }
        
        if let word = sourceView.currentWord{
            context.delete(word)
        }
        
        sourceView.saveContent()
        do {
            try context.save()
            tableView.reloadData()
        } catch let error as NSError {
            print("Unresolved error during saving new word \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - Methods
    
    // action when we add new Word
    
    @objc func addTapped() {
        performSegue(withIdentifier: "newWord", sender: nil)
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
        
        print(words)
        cell.textLabel?.text = words[indexPath.row].word
        
        print("Setting a detailLabel text:")
        
        if words[indexPath.row].definitions?.count != 0 {
            print("Definition isn't empty")
            guard let randomDefinition = words[indexPath.row].definitions?.anyObject() as? Definition else { return cell }
            cell.detailTextLabel?.text = randomDefinition.text
        } else if words[indexPath.row].translations?.count != 0 {
            print("Translation isn't empty")
            guard let randomTranslation = words[indexPath.row].translations?.anyObject() as? Translation else { return cell }
            cell.detailTextLabel?.text = randomTranslation.text
        } else {
            print("Definition and translation is empty")
            cell.detailTextLabel?.text = "No definitions or transaltions"
        }
        
        /*if let d = words[indexPath.row].definitions?.count {
            cell.detailTextLabel?.text = d
        } else {
            if let t = words[indexPath.row].translation {
                cell.detailTextLabel?.text = t
            } else {
                cell.detailTextLabel?.text = "Non"
            }
        }*/
        
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
        print("WordsTableViewController: Enter into prepare segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let wvc = segue.destination as? WordViewController {
            print ("got destination")
            
            switch segue.identifier! {
            case "showWord" :
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    
                    guard let words = currentDictionary?.words?.allObjects as? [Word] else { return }
                    wvc.currentDictionary = currentDictionary
                    wvc.currentWord = words[indexPath.row]
                    print("showWord segue: was seted dictionary and word")
                }
                
            case "newWord" :
                wvc.currentDictionary = currentDictionary
                print("newWord segue: was setted Dictionary")
                
            default:
                print("segue identifier wasn't found")
                break
            }
            
            
        }
        
        print("WordsTableViewController: Exit form prepare segue")
    }
    
}

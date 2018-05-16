//
//  WordsViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 15/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData

class WordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    
    let realm = try! Realm()
    
    var currentDictionary: RealmDictionary? {
        didSet {
            guard let dictionary = currentDictionary else { return }
            
            navigationItem.title = dictionary.name
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var wordsTableView: UITableView!
    
    @IBOutlet weak var nonWordsStack: UIStackView!
    
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonWasTapped(segue: UIStoryboardSegue){
    }
    
    @IBAction func saveButtonWasTapped(segue:
        UIStoryboardSegue){
        
        guard let sourceView = segue.source as? WordViewController else { return }
    
        sourceView.saveContent()
        
        wordsTableView.reloadData()
        
    }
    
    // MARK: - Methods
    
    // action when we add new Word
    
    @objc func addTapped() {
        performSegue(withIdentifier: "newWord", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
        
        wordsTableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        wordsTableView.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let dictionary = currentDictionary else {
            nonWordsStack.isHidden = false;
            UIView.animate(withDuration: 2) {
                self.nonWordsStack.alpha = 1
                tableView.alpha = 0
            }
            tableView.isHidden = true
            return 0
        }
        
        let count = dictionary.words.count
        
        if (count <= 0) {
            nonWordsStack.isHidden = false;
            UIView.animate(withDuration: 2) {
                self.nonWordsStack.alpha = 1
                tableView.alpha = 0
            }
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            UIView.animate(withDuration: 2) {
                self.nonWordsStack.alpha = 0
                tableView.alpha = 1
            }
            nonWordsStack.isHidden = true
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as? WordTableViewCell, let dictionary = currentDictionary else {
             let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
            return cell
        }
        
        // Configure the cell...
        
        cell.currentDictionary = dictionary
        cell.currentWord = dictionary.words[indexPath.row]
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let currentDictionary = currentDictionary else { return }
            
            try! realm.write {
                if currentDictionary.words[indexPath.row].isLearned {
                    currentDictionary.numberOfLearnedWords -= 1
                }
                
                currentDictionary.words.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let wvc = segue.destination as? WordViewController {
            
            switch segue.identifier! {
            case "showWord" :
                if let cell = sender as? WordTableViewCell, let indexPath = wordsTableView.indexPath(for: cell) {
                    
                    wvc.currentDictionary = currentDictionary
                    wvc.currentWord = currentDictionary?.words[indexPath.row]
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
    }
    

}

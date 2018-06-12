//
//  WordsViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 15/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift

class WordsViewController: UIViewController {

    // MARK: - Properties
    
    fileprivate let realm = try! Realm()
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate var filteredWords = [RealmWord]()
    
    /********************************
     ****** Chosen dictionary  ******
     ********************************/
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
    
    /*****************************************
     ****** Action when we add new Word ******
     *****************************************/
    
    @objc func addTapped() {
        performSegue(withIdentifier: "newWord", sender: nil)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        guard let dictionary = currentDictionary else { return }
        
        filteredWords = dictionary.words.filter({( word : RealmWord) -> Bool in
            return word.word.lowercased().contains(searchText.lowercased())
        })
        
        wordsTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = add
        
        wordsTableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search words", comment: "Place holder for search bar at words tablew view")
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = #colorLiteral(red: 0.1688913405, green: 0.2733592689, blue: 0.4399766326, alpha: 1)
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        wordsTableView.reloadData()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search words", comment: "Place holder for search bar at words tablew view")
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = #colorLiteral(red: 0.1688913405, green: 0.2733592689, blue: 0.4399766326, alpha: 1)
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
                    
                    if !isFiltering() {
                        wvc.currentDictionary = currentDictionary
                        wvc.currentWord = currentDictionary?.words[indexPath.row]
                    } else {
                        wvc.currentDictionary = currentDictionary
                        wvc.currentWord = filteredWords[indexPath.row]
                    }
                    
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

// MARK: - Table View Data Source
extension WordsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if isFiltering() {
            return filteredWords.count
        }
        
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
        
        if !isFiltering() {
            cell.currentDictionary = dictionary
            cell.currentWord = dictionary.words[indexPath.row]
        } else {
            cell.currentDictionary = dictionary
            cell.currentWord = filteredWords[indexPath.row]
        }
        return cell
    }
}

// MARK: - Table View Delegate
extension WordsViewController : UITableViewDelegate {
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
}


// MARK: - UISearchResultsUpdating Delegate
extension WordsViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

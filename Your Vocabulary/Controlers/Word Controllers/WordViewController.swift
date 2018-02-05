//
//  WordViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 5/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class WordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewFieldDelegate {
    
    // MARK: - Variables
    
    fileprivate var dataForTable = [(numberOfSection: Int, String : [(value: String?, type: typeOfCell)])]()
    
    fileprivate var managedContext : NSManagedObjectContext? {
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Outlets.
    @IBOutlet weak var fieldsTableView: UITableView!
    
    var currentDictionary: Dictionary?
    var sections = [[(value: String? , type: typeOfCell)]]()
    
    // MARK: - Methods
    
    func setDataInformation() -> Int {
        
        print("Setting number of section for dictionary")
        
        guard let dictionary = currentDictionary else { return -1 }
        
        //Word section
        sections.append([("Word", typeOfCell.titleFollowingFields), (nil, .field)])
        
        //Translation
        if dictionary.isTranslation {
            sections.append([("Translations", typeOfCell.titleFollowingFields), (nil, .field), (nil, .addFieldButton)])
        }
        
        //Definition
        if dictionary.isDefinition {
            sections.append([("Definitions", typeOfCell.titleFollowingFields), (nil, .field), (nil, .addFieldButton)])
        }
        
        //ExtraInfo
        if dictionary.isExtraInfo {
            sections.append([("Extra information", typeOfCell.titleFollowingFields), (nil, .field), (nil, .addFieldButton)])
        }
        
        //Synonym
        if dictionary.isSynonym {
            sections.append([("Synonyms", typeOfCell.titleFollowingFields), (nil, .field), (nil, .addFieldButton)])
        }
        
        //Example
        if dictionary.isExample {
            sections.append([("Examples", typeOfCell.titleFollowingFields), (nil, .addFieldButton), (nil, .addFieldButton)])
        }
        
        //Save button
        sections.append([("EndButtons", typeOfCell.SaveCancelButtons)])
        
        print("Set number of word section : \(sections.last!.count)")
        
        if dictionary.isTranslation {
            
        }
        
        
        print("number of section for dictionary \" \(dictionary.name!) \" : ")
        
        return 0
    }
    
    // MARK: - IBActions
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.title = "New word"
        
        if setDataInformation() < 0 {
            return
        }
        
        // Set automatic dimensions for row height
        fieldsTableView.rowHeight = UITableViewAutomaticDimension
        fieldsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
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
            cell.textField.placeholder = "Enter \(sections[indexPath.section].first?.value!.lowercased() ?? "None")"
            return cell
            
        case .addFieldButton:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addFieldButtonCell", for: indexPath) as? WordAddFieldButtonTableViewCell else { break }
            
            cell.delegate = self
            return cell
            
        case .SaveCancelButtons:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "saveCancelButtonsCell", for: indexPath) as? WordAddFieldButtonTableViewCell else { break }
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - AddNewFieldDelegate implementation
    
    func addFieldBeforeRow(_ row: UITableViewCell) {
        guard let indexPath = fieldsTableView.indexPath(for: row) else { return }
        
        print("Should insert row into section \(sections[indexPath.section][0]) before row \(indexPath.row)")
        
        sections[indexPath.section].insert((nil, .field), at: indexPath.row - 1)
        
        fieldsTableView.reloadData()
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

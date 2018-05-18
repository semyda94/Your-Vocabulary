//
//  SettingsTableViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 14/03/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData

class SettingsTableViewController: UITableViewController {

    // MARK : - Propertires
    
    fileprivate let realm = try! Realm()
    
    fileprivate let settingsCells : [String : (section: Int, row: Int)] = ["Export" : (1 , 0),
                                                                           "Reset" : (1 , 2)]
    
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
                print("Export")
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

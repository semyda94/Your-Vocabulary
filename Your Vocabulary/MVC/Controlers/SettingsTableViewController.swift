//
//  SettingsTableViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 14/03/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class SettingsTableViewController: UITableViewController {

    // MARK : - Propertires
    
    fileprivate var managedContext : NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
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
            headerTitle.textLabel?.textColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.4588235294, alpha: 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case settingsCells["Export"]!.row :
                print(NSPersistentContainer.defaultDirectoryURL())
            case settingsCells["Reset"]!.row:
                let alert = UIAlertController(title: "Reseting database", message: "Are you sure you want to delete all data?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { _ in
                    for entity in entities {
                        let  batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: entity.value)
                        
                        do {
                            try self.managedContext!.execute(batchDeleteRequest)
                            
                        } catch {
                            // Error Handling
                        }
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

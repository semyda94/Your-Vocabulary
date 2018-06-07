//
//  TrainingReminderViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 24/05/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import UserNotifications

class TrainingReminderViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var daysOfWeekButtons: [DayOfWeekButton]!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    // MARK: - Methods
    
    /****************************************************************************
     ****** If any of days was chosen then confirming to set notifications ******
     ****************************************************************************/
    fileprivate func checkSettigsBeforeCreateNotification() -> Bool {
        for day in daysOfWeekButtons {
            if day.isChosen {
                return true
            }
        }
        return false
    }
    
    /********************************************************************************
     ****** Current function of present alert when user didn't select any days ******
     ********************************************************************************/
    fileprivate func showNonSelectedDaysAlert() {
        let alertControllerTitle = NSLocalizedString("Couldn't set", comment: "Title of alert when user didn't choose any of days.")
        let alertControllerMessage = NSLocalizedString("You should select at least one day of the week to set a training reminder", comment: "Message of alert when user didn't choose any of days.")
        let alertController = UIAlertController(title: alertControllerTitle, message: alertControllerMessage, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: NSLocalizedString("OK", comment: "Title of action when user didn't choose any of days."), style: .default, handler: nil)
        
        alertController.addAction(actionOk)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    /***********************************************************
     ****** Setting notification into notification center ******
     ***********************************************************/
    @IBAction func saveNotification(_ sender: Any) {
        
        // Check that any days of week was chosen
        if !checkSettigsBeforeCreateNotification() {
            showNonSelectedDaysAlert()
            return
        }
        
        let UNCenter = UNUserNotificationCenter.current()
       
        // removing previos notifications.
        UNCenter.removeAllPendingNotificationRequests()
        
        //Setting time of day properties
        var dateComponents = DateComponents()
        dateComponents.hour = timePicker.calendar.component(.hour, from: timePicker.date)
        dateComponents.minute = timePicker.calendar.component(.minute, from: timePicker.date)
        
        //Setting the title and body of notification
        let content = UNMutableNotificationContent()
        content.title = "Traning Reminder"
        content.body = "Do not forget about the expansion of your vocabulary, regular practice increases the chance to memorize the material."
        content.sound = UNNotificationSound.default()
        
        //Checking each day of week and request of notifications for chosen day
        for (index, day) in daysOfWeekButtons.enumerated() {
            if day.isChosen {
                dateComponents.weekday = index + 1
                let weeklyTriger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                weeklyTriger.nextTriggerDate()
                
                content.categoryIdentifier = "YourVocabNotification"
                let request = UNNotificationRequest(identifier: "YourVocabNotification" + String(index), content: content, trigger: weeklyTriger)
                
                UNCenter.add(request, withCompletionHandler: nil)
                
            }
        }
    }
    
    @IBAction func changeButtonProperties(_ sender: DayOfWeekButton) {
        sender.isChosen = !sender.isChosen
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

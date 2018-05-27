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
    
    fileprivate func checkSettigsBeforeCreateNotification() -> Bool {
        for day in daysOfWeekButtons {
            if day.isChosen {
                return true
            }
        }
        return false
    }
    
    fileprivate func showNonSelectedDaysAlert() {
        let alertController = UIAlertController(title: "title", message: "Message", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(actionOk)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func saveNotification(_ sender: Any) {
        
        if !checkSettigsBeforeCreateNotification() {
            showNonSelectedDaysAlert()
        }
        
        let UNCenter = UNUserNotificationCenter.current()
        
        UNCenter.removeAllPendingNotificationRequests()
        
        var dateComponents = DateComponents()
        dateComponents.hour = timePicker.calendar.component(.hour, from: timePicker.date)
        dateComponents.minute = timePicker.calendar.component(.minute, from: timePicker.date)
        
        let content = UNMutableNotificationContent()
        content.title = "Traning Reminder"
        content.body = "Do not forget about the expansion of your vocabulary, regular practice increases the chance to memorize the material."
        content.sound = UNNotificationSound.default()
        
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

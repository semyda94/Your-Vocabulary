//
//  DictionaryPropertiesViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 18/01/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData

class DictionaryPropertiesViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var propetiesView: UIView!
    
    @IBOutlet weak var translationCheckBox: BEMCheckBox!
    @IBOutlet weak var definitionCheckBox: BEMCheckBox!
    @IBOutlet weak var extraInfoCheckBox: BEMCheckBox!
    @IBOutlet weak var synonymCheckBox: BEMCheckBox!
    @IBOutlet weak var exampleCheckBox: BEMCheckBox!
    
    // MARK: - Actions
    
    @IBOutlet weak var titleOfView: UILabel!
    
    @IBOutlet weak var dictionaryNameTextField: UITextField!
    // MARK: - Propeties

    var newDictionary = true
    var dictionary: RealmDictionary?
    
    // MARK: - Functions
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                    self.view.frame.origin.y -= keyboardSize.height / 2
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y += keyboardSize.height / 2
        }
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        self.dictionaryNameTextField.delegate = self
        
        self.propetiesView.layer.cornerRadius = 7
        
        //Move up view when keyboad will appear
        NotificationCenter.default.addObserver(self, selector: #selector(DictionaryPropertiesViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DictionaryPropertiesViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        if dictionary != nil {
            titleOfView.text = NSLocalizedString("Editing properties", comment: "Title during editing properties of dictionary")
            
            if let name = dictionary?.name { dictionaryNameTextField.text = name }
            
            translationCheckBox.on = (dictionary?.isTranslation)!
            definitionCheckBox.on = (dictionary?.isDefinition)!
            extraInfoCheckBox.on = (dictionary?.isExtraInfo)!
            synonymCheckBox.on = (dictionary?.isSynonym)!
            extraInfoCheckBox.on = (dictionary?.isExample)!
            
            newDictionary = false
            
        } else {
            titleOfView.text = NSLocalizedString("New dictionary", comment: "Title during creating new dictionary")
        }
    
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // User finished typing (hit return): hide the keyboard.
        dictionaryNameTextField.resignFirstResponder()
        return true
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

//
//  QuizMatchingViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 25/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

class QuizMatchingViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var leftButtons: [UIButton]!
    @IBOutlet var rightButtons: [UIButton]!
    
    // MARK: - Methods
    fileprivate func setButtonsSettings(forButtons buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.4588235294, alpha: 1)
            button.backgroundColor = #colorLiteral(red: 0.5921568627, green: 0.737254902, blue: 0.7058823529, alpha: 1)
            button.tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1)
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonsSettings(forButtons: leftButtons)
        setButtonsSettings(forButtons: rightButtons)

        // Do any additional setup after loading the view.
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

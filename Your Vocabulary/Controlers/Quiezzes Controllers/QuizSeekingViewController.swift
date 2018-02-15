 //
//  QuizSeekingViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 13/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

class QuizSeekingViewController: UIViewController {

    //Outlets
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var answersButtons: [UIButton]!
    
    @IBAction func wasDoneAnswer(_ sender: UIButton) {
        print("Was tapped \(sender.titleLabel?.text)")
    }
    
    // methods
    
    fileprivate func prepareScreen() {
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        for button in answersButtons {
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0.4588235294, alpha: 1)
            button.backgroundColor = #colorLiteral(red: 0.568627451, green: 0.7137254902, blue: 0.6862745098, alpha: 1)
        }
    }
    
    fileprivate func startGame() {
        
    }
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareScreen()
        
        startGame()
        
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

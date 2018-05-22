//
//  AppOnboardingViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 22/05/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import paper_onboarding

class AppOnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    @IBOutlet var onboardingView: AppOnboardingView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    let items = [OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onboarding_dictionary"), title: "Welcome", description: "Welcome to the app \"Your Vocabulary\" this app will help you extend your vocabulary.", pageIcon: #imageLiteral(resourceName: "onboarding_empty_page_icon"), color: #colorLiteral(red: 0.5921568627, green: 0.737254902, blue: 0.7058823529, alpha: 1)/*#colorLiteral(red: 0.662745098, green: 0.8078431373, blue: 0.9568627451, alpha: 1)*/, titleColor: #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1), descriptionColor: #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1), titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!, descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!), OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onboarding_dictionaries"), title: "Dictionaries and words", description: "At first you need to create your first dictionary and select the appropriate options for the dictionary you want to use. After meeting with the words associated with this dictionary you can add new words to the dictionary.", pageIcon: #imageLiteral(resourceName: "onboarding_empty_page_icon"), color: #colorLiteral(red: 0.662745098, green: 0.8078431373, blue: 0.9568627451, alpha: 1)/* #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)*/, titleColor: #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1), descriptionColor: #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1), titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!, descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!), OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onboarding_quizzes"), title: "Quizzes", description: "In the section \"Quizzes\" you can find 3 different type of quizzes which help you continually practice and improve your vocabulary.", pageIcon: #imageLiteral(resourceName: "onboarding_empty_page_icon"), color: #colorLiteral(red: 0.7960784314, green: 0.7019607843, blue: 0.7490196078, alpha: 1), titleColor: #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1), descriptionColor: #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1), titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!, descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!), OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onboarding_progress"), title: "Progress", description: "In the \"Progress\" section you can track your achievements over time. Where statistics for all tests will be displayed, both for all dictionaries together and for dictionaries separately.", pageIcon: #imageLiteral(resourceName: "onboarding_empty_page_icon"), color: #colorLiteral(red: 0.5921568627, green: 0.737254902, blue: 0.7058823529, alpha: 1), titleColor: #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1), descriptionColor: #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.4392156863, alpha: 1), titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!, descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!)]
    
    
    
    @IBAction func onboardingWasComplited(_ sender: Any) {
        let userDefaultes = UserDefaults.standard
        
        if !userDefaultes.bool(forKey: "onboardingWasComplited") { userDefaultes.set(true, forKey: "onboardingWasComplited")
            userDefaultes.synchronize()
        }
    
        performSegue(withIdentifier: "startApp", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingView.dataSource = self
        onboardingView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - OnboardingDataSource selegate
    
    func onboardingItemsCount() -> Int {
        return items.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        return items[index]
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index _: Int) {
        item
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        
        print("Will transition to index = \(index)")
        if index == items.count - 1 {
            UIView.animate(withDuration: 0.4) {
                self.getStartedButton.alpha = 1
            }
        } else {
            if getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.4) {
                    self.getStartedButton.alpha = 0
                }
            }
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

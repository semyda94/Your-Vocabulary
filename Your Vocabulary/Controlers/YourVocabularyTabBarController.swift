//
//  YourVocabularyTabBarController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 9/04/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

class YourVocabularyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let navController = self.viewControllers![selectedIndex] as? UINavigationController
        navController?.popToRootViewController(animated: false)
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

//
//  QuizzesViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 8/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

class QuizzesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let quizzes: [(name: String,thumbnail: UIImage)] = [("Seeking", #imageLiteral(resourceName: "seeking_icon")), ("Seeking by time", #imageLiteral(resourceName: "seeking_by_time_icon")), ("Matching", #imageLiteral(resourceName: "matching_icon")), ("Matching by time", #imageLiteral(resourceName: "matching_by_time_icon")), ("Spelling", #imageLiteral(resourceName: "spelling_icon")), ("Spelling by time", #imageLiteral(resourceName: "spelling_by_time_icon"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCollectionCell", for: indexPath) as! QuizzesCollectionViewCell
        
        cell.quizzThumbNail.image = quizzes[indexPath.row].thumbnail
        return cell
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

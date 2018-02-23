//
//  QuizzesCollectionViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 8/02/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "QuizCollectionCell"

enum QuizzesTypes:String {
    case seeking = "Seeking"
    case seekingByTime = "Seeking by time"
    case matching = "Matching"
    case matchingByTime = "Matching by time"
    case spelling = "Spelling"
    case spellingByTime = "Spelling by time"
    case none = "none"
}

class QuizzesCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    let quizzes: [(name: QuizzesTypes, thumbnail: UIImage)] = [(.seeking, #imageLiteral(resourceName: "seeking_icon") ), (.seekingByTime, #imageLiteral(resourceName: "seeking_by_time_icon")), (.matching, #imageLiteral(resourceName: "matching_icon")), (.matchingByTime, #imageLiteral(resourceName: "matching_by_time_icon")), (.spelling, #imageLiteral(resourceName: "spelling_icon")), (.spellingByTime, #imageLiteral(resourceName: "spelling_by_time_icon"))]
    
    //MARK: - Unwind segue
    
    @IBAction func closePropertiesView(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func startQuiz(segue: UIStoryboardSegue) {
        if let segue = segue as? UIStoryboardSegueWithCompletion {
            
            segue.completion = {
                guard let sourceVC = segue.source as? QuizPropertiesViewController else { return }
                
                switch sourceVC.typeOfQuiz {
                case .seeking:
                    self.performSegue(withIdentifier: "startSeekingQuiz", sender: nil)
                default:
                    return
                }
            }
        } else {
            return
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

//        // Register cell classes
//        self.collectionView!.register(QuizzesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width / 2.0 - 20
            let itemHeight = itemWidth
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showQuizProperties":
            guard let qpvc = segue.destination as? QuizPropertiesViewController else { return }
            guard let cell = sender as? QuizzesCollectionViewCell, let indexPath = collectionView?.indexPath(for: cell) else { return }
            qpvc.typeOfQuiz = quizzes[indexPath.row].name
            qpvc.modalPresentationStyle = .overCurrentContext
            
        default:
            break
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return quizzes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("try to set cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! QuizzesCollectionViewCell
    
        cell.quizzThumbNail.image = quizzes[indexPath.row].thumbnail
        cell.title.text = quizzes[indexPath.row].name.rawValue
        // Configure the cell
        
        return cell
        
    }

    // MARK: UICollectionViewDelegate

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    

}

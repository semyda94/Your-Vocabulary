//
//  StatisticViewController.swift
//  Your Vocabulary
//
//  Created by Dmitrii Semykin on 11/03/18.
//  Copyright © 2018 Dmitrii Semykin. All rights reserved.
//

import UIKit
import CoreData
import Charts

class StatisticViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    

    // MARK: - Properties
    
    var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    fileprivate var dictionaries = [Dictionary]() {
        didSet {
            dictionaryPicker.reloadAllComponents()
        }
    }
    
    fileprivate var rows = [(title: String, number: Int)]()
    
    // MARK: - Outlets
    @IBOutlet weak var dictionaryPicker: UIPickerView!
    @IBOutlet weak var combinedChart: CombinedChartView!
    @IBOutlet weak var statisticTableView: UITableView!
    
    // MARK: - Methods
    
    
    fileprivate func updateTableContent(forDictionary dictionary: Dictionary?) {
        
        var tests = [TestInfo]()
        var numberOfWords = 0
        var numberOfAnswers = 0
        var numberOfCorrectAnswers = 0
        
        if let choosenDictionary = dictionary {
            print("Choose dictionnary \(choosenDictionary.name)")
            tests = choosenDictionary.tests?.array as! [TestInfo]
            numberOfWords = Int(choosenDictionary.numberOfWords)
            
        } else {
            print("Show information for all dictionaries")
            for dictionary in dictionaries {
                tests.append(contentsOf: dictionary.tests?.array as! [TestInfo])
                
                numberOfWords += Int(dictionary.numberOfWords)
            }
        }
        
        tests = tests.sorted(by: { $0.dateOfCreation?.compare($1.dateOfCreation! as Date) == .orderedAscending })
        
        for test in tests {
            //barChartDataEntry.append(BarChartDataEntry(x: <#T##Double#>, y: <#T##Double#>) )
            numberOfAnswers += Int(test.numberOfAnswers)
            numberOfCorrectAnswers += Int(test.numberOfCorrectAnswers)
        }
        
        print(tests)
        
        let e1: (title: String, number: Int)
        let e2: (title: String, number: Int)
        let e3: (title: String, number: Int)
        
        
        e1.title = "Number of words"
        e1.number = numberOfWords
        
        e2.title = "Number of answers"
        e2.number = numberOfAnswers
        
        e3.title = "Number of correct answers"
        e3.number = numberOfCorrectAnswers
        
        rows.removeAll()
        rows.append(contentsOf: [e1, e2, e3])
        
        updateBarData(withTests: tests)
        
        statisticTableView.reloadData()
    }
    
    fileprivate func updateBarData(withTests tests: [TestInfo]) {
        var barChartDataEntries = [BarChartDataEntry]()
        var lineChartDataEntries = [ChartDataEntry]()
        
        
        let formato = CombinedChartFormatter()
        let xaxis:XAxis = XAxis()
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM dd"
        
        //Just show one point for all tests at the date otherwise show each test separately.
//        var prevDate = ""
//        for test in tests {
//            if dateFormater.string(from: test.dateOfCreation! as Date) != prevDate {
//                xAxisLabels.append(dateFormater.string(from: test.dateOfCreation! as Date))
//                prevDate = xAxisLabels.last!
//            }
//        }
        
        for (index, test) in tests.enumerated() {
            barChartDataEntries.append( BarChartDataEntry(x: Double(index), y: Double(test.numberOfAnswers)) )
            lineChartDataEntries.append(ChartDataEntry(x: Double(index), y: Double(test.numberOfCorrectAnswers)))
            formato.labels.append(dateFormater.string(from: test.dateOfCreation! as Date))
            formato.stringForValue(Double(index), axis: xaxis)
        }
        
        xaxis.valueFormatter = formato
        
       
        let barDataSet = BarChartDataSet(values: barChartDataEntries, label: "Number of answers")
        let lineDataSet = LineChartDataSet(values: lineChartDataEntries, label: "Number of correct answers")
        
        let barData = BarChartData(dataSet: barDataSet)
        let lineData = LineChartData(dataSet: lineDataSet)
        
        let combinedData = CombinedChartData()
        combinedData.barData = barData
        combinedData.lineData = lineData
        
        combinedChart.data = combinedData
        combinedChart.xAxis.valueFormatter = xaxis.valueFormatter
        
        combinedChart.notifyDataSetChanged()
        
        
    }
    
    fileprivate func fetchListOfDictionaries() -> [Dictionary]? {
        guard let context = managedContext else { return nil }
        
        let request = NSFetchRequest<Dictionary>(entityName: "Dictionary")
        
        do {
            let result = try context.fetch(request)
            
            return result
        } catch let error as NSError {
            print("Unresolved error during fetching dictionaries for Statistic: \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dictionaries = fetchListOfDictionaries() ?? [Dictionary]()
        
        updateTableContent(forDictionary: nil)
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
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticCell") as? StatisticTableViewCell else { return UITableViewCell()}
        
        cell.titleLabel.text = rows[indexPath.row].title;
        cell.numberLabel.text = "\(rows[indexPath.row].number)"
        
        return cell
    }
    
    // MARK: UIPickerDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dictionaries.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "All"
        default:
            return dictionaries[row - 1].name
        }
    }
    
    //UIPickerDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            updateTableContent(forDictionary: nil)
            return
        default:
            updateTableContent(forDictionary: dictionaries[row - 1])
            return
        }
    }
    
}

@objc(CombinedChartFormatter)
public class CombinedChartFormatter: NSObject, IAxisValueFormatter{
    
    var labels = [String]()
    
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return labels[Int(value)]
    }
}

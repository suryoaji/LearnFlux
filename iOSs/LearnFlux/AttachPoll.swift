//
//  AttachPoll.swift
//  LearnFlux
//
//  Created by Martin Darma Kusuma Tjandra on 4/28/16.
//  Copyright © 2016 Martin Darma Kusuma Tjandra. All rights reserved.
//

import Foundation

protocol AttachPollReturnDelegate: class {
    func sendSelectedPollData (poll: Dictionary<String, AnyObject>);
}

class AttachPoll : UITableViewController {
    weak var delegate : AttachPollReturnDelegate!;
    
    var question : String = "";
    var answers = [String]();
    
    var preset = [Dictionary<String, AnyObject>]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preset = [
            ["question":"How can we improve our EBF event?", "answers":["Speed up registration process", "Pick better speakers", "Do it more often"]],
            ["question":"What things do you like most from our EBF event?", "answers":["Engaging speakers", "Event neatly organized", "Interesting topic"]]
        ];
        answers.append("");
        answers.append("");
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 1: return 1;
        case 2: return answers.count;
        case 3: return 1;
        case 4: return 2;
        default: return 0;
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var code = indexPath.code;
        if (indexPath.section == 2) {
            code = "2-0";
        }
        if (indexPath.section == 4) {
            code = "4-0";
        }
        return tableView.dequeueReusableCellWithIdentifier(code)!.height;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 1: return "Question";
        case 2: return "Answers";
        case 4: return "Or choose from available";
        default: return "";
        }
    }
    
    func countValidAnswers () -> Int {
        var count : Int = 0;
        for answer in answers {
            if (answer != "") {
                count = count + 1;
            }
        }
        return count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var code = indexPath.code;
        if (indexPath.section == 2) {
            code = "2-0";
        }
        if (indexPath.section == 4) {
            code = "4-0";
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(code)!;
        
        cell.setSeparatorType(CellSeparatorFull);
        
        if (indexPath.isEqualCode("1-0")) {
            let tfQuestion = cell.viewWithTag(1) as! UITextField;
            tfQuestion.text = question;
        }
        
        if (indexPath.section == 2) {
            let tfAnswer = cell.viewWithTag(1) as! UITextField;
            tfAnswer.text = answers[indexPath.row];
        }
        
        if (indexPath.section == 4) {
            let tfQuestion = cell.viewWithTag(1) as! UILabel;
            let tfAnswers = cell.viewWithTag(2) as! UILabel;
            let curPreset = preset[indexPath.row];
            tfQuestion.text = curPreset["question"] as! String!;
            let answers: [String] = curPreset["answers"] as! [String];
            var combinedAnswers = "";
            for answer in answers {
                if (combinedAnswers != "") {
                    combinedAnswers += ", ";
                }
                combinedAnswers += answer;
            }
            combinedAnswers = "Poll choice: " + combinedAnswers;
            tfAnswers.text = combinedAnswers;
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        
        if (indexPath.section == 4) {
            delegate.sendSelectedPollData(preset[indexPath.row]);
            self.navigationController?.popViewControllerAnimated(true);
        }
    }
    
    @IBAction func addNewAnswer (sender: AnyObject) {
        answers.append("");
        tableView.reloadData();
    }
    
    @IBAction func saveAndSend (sender: AnyObject) {
        self.view.window?.endEditing(true);
        let newData : Dictionary<String, AnyObject> = ["question":question, "answers":answers]
        delegate.sendSelectedPollData(newData);
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    @IBAction func saveQuestion (sender: AnyObject) {
        let tf = sender as! UITextField;
        question = tf.text!;
    }
    
    @IBAction func saveAnswers (sender: AnyObject) {
        let tf = sender as! UITextField;
        let cell = tf.superview!.superview as! UITableViewCell;
        let indexPath = tableView.indexPathForCell(cell)!;
        answers[indexPath.row] = tf.text!;
    }
    

}
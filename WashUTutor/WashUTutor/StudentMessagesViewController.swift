//
//  StudentMessagesViewController.swift
//  WashUTutor
//
//  Created by Jessica Sheldon on 11/13/23.
//

import UIKit

// reference for menu item button
// https://medium.nextlevelswift.com/creating-a-native-popup-menu-over-a-uibutton-or-uinavigationbar-645edf0329c4
//
class StudentMessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

        @IBOutlet weak var tableView: UITableView!
       
        @IBOutlet weak var menuButton: UIButton!
    
        var messages:[String] = []
        var responses:[String] = []
        var placeholderMessages:[String] = []
        var placeholderResponses:[String] = []
        var answeredMessages:[String] = []
        var answeredResponses:[String] = []
        var unansweredMessages:[String] = []
        var unansweredResponses:[String] = []
        var tutorNames:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tabBarController?.tabBar.barTintColor = UIColor(red: 128.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1)
        
        for(_,value) in currentStudent.messages {
            if ((value["question"]?.isEmpty) != nil) {
                messages.append(value["question"] ?? "")
                responses.append(value["response"] ?? "")
                tutorNames.append(value["tutorName"] ?? "")
            }
        }
        //            for(key,value) in responsesMap {
        //                responses.append(value);
        //            }
        
        placeholderMessages = messages
        placeholderResponses = responses
       
        print("MESSAGES: \(messages)")
        print("RESPONSES: \(responses)")
        let all = UIAction(title: "All") { (action) in

            print("All was tapped")
            
            self.messages = self.placeholderMessages
            self.responses = self.placeholderResponses
            self.tableView.reloadData()
            
        }

        let answered = UIAction(title: "Answered") { (action) in

            self.messages = self.placeholderMessages
            self.responses = self.placeholderResponses
            self.answeredMessages.removeAll()
            self.answeredResponses.removeAll()
            
            for (index, value) in self.responses.enumerated() {
                if value != "" {
                    self.answeredMessages.append(self.messages[index])
                    self.answeredResponses.append(value)
                }
            }
            print("Answered was tapped")
            
            self.messages = self.answeredMessages
            self.responses = self.answeredResponses
            self.tableView.reloadData()
        }

        let unanswered = UIAction(title: "Unanswered") { (action) in
           
            self.messages = self.placeholderMessages
            self.responses = self.placeholderResponses
            self.unansweredMessages.removeAll()
            self.unansweredResponses.removeAll()
            
            for (index, value) in self.responses.enumerated() {
                if value == "" {
                    self.unansweredMessages.append(self.messages[index])
                    self.unansweredResponses.append(value)
                }
            }
            
            self.messages = self.unansweredMessages
            self.responses = self.unansweredResponses
            self.tableView.reloadData()
    
        }

        let menu = UIMenu(title: "Sort", options: .displayInline, children: [all, answered , unanswered])
            
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
        tableView.reloadData()
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messages.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = messages[indexPath.row]
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let responseVC = storyboard!.instantiateViewController(withIdentifier: "studentResponse") as! StudentViewResponseViewController
            
            responseVC.studentQuestion = messages[indexPath.row]
            responseVC.tutorName = tutorNames[indexPath.row]
            
            responseVC.tutorResponse = responses[indexPath.row]
            
            navigationController?.pushViewController(responseVC, animated: true)
        }
        
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

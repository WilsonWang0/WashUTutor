//
//  SendMessageViewController.swift
//  WashUTutor
//
//  Created by Jessica Sheldon on 11/13/23.
//

import UIKit

class SendMessageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    

    var tutorData: [Tutor] = []
    var selectedTutorIndex = 0
 
    @IBOutlet weak var classPickerView: UIPickerView!
    @IBOutlet weak var tutorPickerView: UIPickerView!
    
    @IBOutlet weak var questionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorPickerView.delegate = self
        tutorPickerView.dataSource = self
        classPickerView.delegate = self
        classPickerView.dataSource = self
        questionTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //self.hidesBottomBarWhenPushed = false
        //self.tabBarController?.tabBar.isHidden = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       view.addGestureRecognizer(tapGesture)
        
        AllTutorData { (tutors, error) in
            if let error = error {
                print("Error fetching tutors: \(error)")
            } else if let tutors = tutors {
                // Process the fetched tutor data
                for tutor in tutors {
                    DispatchQueue.main.async {
                        self.tutorData.append(tutor)
                    //    self.courses.append(contentsOf: tutor.classNumber)
                        self.tutorPickerView.reloadAllComponents()
                        self.classPickerView.reloadAllComponents()
                    }
                }
                DispatchQueue.main.async {
                    for index in 0..<self.tutorData.count {
                        print(self.tutorData[index])
                        
                    }
                }
                
            }
        }
       
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
           textView.resignFirstResponder()
           return true
       }
   
   @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    // reference for picker view: https://www.youtube.com/watch?v=NHVmvvLmHfM
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count = 0
        
        if(pickerView == tutorPickerView) {
            count = tutorData.count
        }
        else if(pickerView == classPickerView) {
            if (tutorData.count > selectedTutorIndex) {
                            count = tutorData[selectedTutorIndex].classNumber.count
                        }
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var data = ""
        
        if(pickerView == tutorPickerView) {
            selectedTutorIndex = row
            data = tutorData[row].name
        }
        else if (pickerView == classPickerView) {
            if(tutorData.count > selectedTutorIndex) {
                            data = tutorData[selectedTutorIndex].classNumber[row]
                        }
        }
        
        return data
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView == tutorPickerView) {
            selectedTutorIndex = row
            classPickerView.reloadAllComponents()
        }
    }
    
    
    @IBAction func sendMessage(_ sender: Any) {
//        tutorData[selectedTutorIndex].messages.append(questionTextField.text)
        let questionID = UUID().uuidString
        
        tutorData[selectedTutorIndex].messages[questionID] = ["userId": currentStudent.userID, "question": questionTextField.text, "response": ""]
        
        currentStudent.messages[questionID] = ["userId": currentStudent.userID, "tutorID": tutorData[selectedTutorIndex].tutorID, "tutorName": tutorData[selectedTutorIndex].name, "question": questionTextField.text, "response": ""]
        
        addMessageForTutor(tutor: tutorData[selectedTutorIndex], messages: tutorData[selectedTutorIndex].messages)
        addMessagesForStudent(userId: currentStudent.userID, tutorID: tutorData[selectedTutorIndex].tutorID, tutorName: tutorData[selectedTutorIndex].name, messages: currentStudent.messages)
        let inboxVC = storyboard!.instantiateViewController(withIdentifier: "studentInbox") as! StudentMessagesViewController
        
        navigationController?.pushViewController(inboxVC, animated: true)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

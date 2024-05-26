//
//  TutorAddAppointmentViewController.swift
//  WashUTutor
//
//  Created by Wilson Wang on 11/13/23.
//

import UIKit
import SwiftUI

class TutorAddAppointmentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @AppStorage("tutorID") var tutorID = ""

    let dateFormatter = DateFormatter()
    
    let startTimeFormatter = DateFormatter()
    
    let endTimeFormatter = DateFormatter()
    var classCode: String = ""
    var allClasses: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        classPicker.dataSource = self
        classPicker.delegate = self
        TutorLocation.delegate = self
        tutorAnnouncement.delegate = self
        startTimeFormatter.timeStyle = .short
        endTimeFormatter.timeStyle = .short
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        getAllClasses { result in
            switch result {
            case .success(let classDataArray):
                // Use the fetched class data
                DispatchQueue.main.async {
                    self.allClasses = classDataArray.sorted() {$0 < $1}
                    self.classPicker.reloadAllComponents()
                }
            case .failure(let error):
                // Handle the error
                print("Error fetching classes: \(error.localizedDescription)")
            }
        }
        self.classPicker.reloadAllComponents()
    }
    
    @IBOutlet weak var classPicker: UIPickerView!
    @IBOutlet weak var TutorDate: UIDatePicker!
    @IBOutlet weak var TutorStartTime: UIDatePicker!
    @IBOutlet weak var TutorEndTime: UIDatePicker!
    @IBOutlet weak var TutorLocation: UITextField!
    @IBOutlet weak var tutorAnnouncement: UITextField!
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
               textField.resignFirstResponder()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func tutorAddApp(_ sender: Any) {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startTimeFormatter.dateFormat = "hh:mm a"
        endTimeFormatter.dateFormat = "hh:mm a"
        
        let dateString = dateFormatter.string(from: TutorDate.date)
        let currentDate = dateFormatter.string(from: Date.now)
        
        let startTimeString = startTimeFormatter.string(from: TutorStartTime.date)
        
        let endTimeString = endTimeFormatter.string(from: TutorEndTime.date)
        
        print(dateString)
        print(startTimeString)
        print(endTimeString)
        print(TutorDate.date)
        print(Date.now)
        
        print(classCode)
        if dateString >= currentDate {
            print("TutorDate is after the current date")
            let difference = TutorEndTime.date.timeIntervalSince(TutorStartTime.date)/3600
            if difference <= 1 && difference > 0.5 {
                print("1 hour or less")
                
                if let location = TutorLocation.text, !location.isEmpty {
                    tutorAddAppointment(tutorUserID: tutorID, date: dateString, startTime: startTimeString, announcement: tutorAnnouncement.text ?? "", endTime: endTimeString, location: location, subject: classCode)
                    
                    let targetTabIndex = 0
                    tabBarController?.selectedIndex = targetTabIndex
                    
                    let tutorCalVC = storyboard!.instantiateViewController(withIdentifier: "HomeSceneViewController") as! TutorManageAppointmentViewController
                    if let navigationController = tabBarController?.viewControllers?[targetTabIndex] as? UINavigationController {
                                navigationController.pushViewController(tutorCalVC, animated: true)
                    }
                }
                else {
                    presentAlert(title: "No Location", message: "Please enter a location of the appointment")
                }
                
                //navigationController?.pushViewController(tutorCalVC, animated: true)
                presentAlert(title: "Appointment Added", message: "Appointment has been created")
            }
            else{
                print("More than one hour")
                presentAlert(title: "Timing is incorrect", message: "Please input the correct time intervals. Must be a hour long or less.")
            }
        }
        else {
            print("TutorDate is before the current date")
            presentAlert(title: "Need correct day", message: "Please the date of the current day or after it.")
        }
    }
    
    private func presentAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allClasses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        classCode = allClasses[row]
        return allClasses[row]
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

//
//  TutorLoginViewController.swift
//  WashUTutor
//
//  Created by Jessica Sheldon on 11/8/23.
//

import UIKit
import SwiftUI

class TutorLoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    

    @AppStorage("tutorID") var tutorID = ""
    @AppStorage("tutorEmail") var tutorEmail = ""
    @AppStorage("tutorName") var tutorName = ""
    @AppStorage("tutorYear") var tutorYear = ""
    //@AppStorage("tutorData") var tutorDateAgain[Tutor]
    @IBOutlet weak var emailTextBox: UITextField!
    
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
        
        emailTextBox.delegate = self
        passwordTextBox.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
               textField.resignFirstResponder()
               return true
           }
       
   @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    
    @IBAction func tutorLoginButton(_ sender: Any) {
        
        guard let email = emailTextBox.text, !email.isEmpty else {
            presentAlert(title: "Error", message: "You must enter an email.")
            return
        }

        guard let password = passwordTextBox.text, !password.isEmpty else {
            presentAlert(title: "Error", message: "You must enter a password.")
            return
        }
            
        if email.contains("wustl.edu") {
            print("This is a WashU email")
            // Assuming that the password or a part of it is used as a 'code'
            getTutorData(email: email, code: password) { [weak self] tutorData in
                DispatchQueue.main.async {
                    if tutorData != nil {
                        guard let viewController = self?.storyboard?.instantiateViewController(withIdentifier: "tutorTab") else { return }
                        self?.navigationController?.pushViewController(viewController, animated: true)
                        self?.tutorName = tutorData?.name ?? "John"
                        self?.tutorYear = tutorData?.year ?? ""
                        self?.tutorEmail = email
                        self?.tutorID = password
                    } else {
                        // Handle the case where no tutor data was found
                        self?.presentAlert(title: "Login Failed", message: "Email/Password is incorrect. Please try again.")
                        }
                    }
                }
            } else {
                presentAlert(title: "Error", message: "The email is not a WashU email.")
            }
        
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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

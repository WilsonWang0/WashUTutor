//
//  StudentLoginViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 10/27/23.
//

import UIKit

class StudentLoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var userEmailTextBox: UITextField!
    
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            userEmailTextBox.delegate = self
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
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
    
    @IBAction func forgetPassword(_ sender: Any){
    }
    
    @IBAction func loginButton(_ sender: Any)
    {
        guard let email = userEmailTextBox.text, !email.isEmpty else {
            presentAlert(title: "Error", message: "You must enter an email.")
            return
        }

        guard let password = passwordTextBox.text, !password.isEmpty else {
            presentAlert(title: "Error", message: "You must enter a password.")
            return
        }

        if email.contains("wustl.edu") {
            studentLoginSign(email: email, password: password) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Login Successful")
                        getStudentDataTutor() { data in
                            if data != nil {
                                print("Student: \(String(describing: currentStudent))")
                            }
                            else {
                                print("Error student")
                            }
                        }
                        guard let viewController = self?.storyboard?.instantiateViewController(withIdentifier: "studentTab") else { return }
//                            self?.present(viewController, animated: true, completion: nil)
                        self?.navigationController?.pushViewController(viewController, animated: true)

                    case .failure(_):
                        self?.presentAlert(title: "Email/Password Incorrect", message: "The email or password is incorrect. Please try again")
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
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}

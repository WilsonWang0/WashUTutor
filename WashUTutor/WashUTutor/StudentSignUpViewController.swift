//
//  StudentSignUpViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/6/23.
//

import UIKit


class StudentSignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextBox.delegate = self
        emailTextBox.delegate = self
        passwordTextBox.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
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
    
    
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func studentSignUp(_ sender: Any){
        if nameTextBox.text!.count != 0 {
            if emailTextBox.text!.count != 0 {
                if emailTextBox.text!.contains("wustl.edu")  {
                    if passwordTextBox.text!.count >= 8 {
                        signUp(name: nameTextBox.text!,email: emailTextBox.text!, password: passwordTextBox.text!)
                        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "studentLogin") else { return }
//                            self?.present(viewController, animated: true, completion: nil)
                        self.navigationController?.pushViewController(viewController, animated: true)
                        
                        createAlert(title: "Account Sign Up", message: "You have signed up.")
                        
                        
                        print("Sign up")
                    }
                    else{
                        createAlert(title: "Password not long", message: "Password must be 8 characters long")
                    }
                }
                else{
                    createAlert(title: "Not wustl", message: "Email must be a WUSTL email")
                }
            }
            else{
                createAlert(title: "No input", message: "Enter a wustl email")
            }
        }
        else{
            createAlert(title: "No name", message: "Please your name")
        }
        
        
        
        
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

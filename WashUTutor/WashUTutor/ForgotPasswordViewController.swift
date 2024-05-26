//
//  ForgotPasswordViewController.swift
//  WashUTutor
//
//  Created by Wilson Wang on 11/14/23.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        if let url = URL(string: "https://connect.wustl.edu/login/WUForgotPWD.aspx") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func forgotID(_ sender: Any) {
        if let url = URL(string: "https://connect.wustl.edu/login/wuforgotID.aspx") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        if let url = URL(string: "https://it.wustl.edu/items/how-do-i-change-my-wustl-key-password/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
}

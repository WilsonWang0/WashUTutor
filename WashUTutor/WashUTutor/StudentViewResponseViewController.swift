//
//  StudentViewResponseViewController.swift
//  WashUTutor
//
//  Created by Jessica Sheldon on 11/14/23.
//

import UIKit

class StudentViewResponseViewController: UIViewController {

    var studentQuestion:String!
    var tutorResponse:String!
    var markAsAnswered: UITextField!
    var tutorName: String!
    
    @IBOutlet weak var questionBox: UITextView!
    
    @IBOutlet weak var questionTutor: UILabel!
    @IBOutlet weak var responseBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionBox.text = studentQuestion
        questionTutor.text = "Your Question to \(tutorName ?? "")"
       
        responseBox.text = tutorResponse
        
        
        // Do any additional setup after loading the view.
        
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

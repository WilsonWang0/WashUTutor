//
//  StudentProfileViewController.swift
//  WashUTutor
//
//  Created by Jessica Sheldon on 12/1/23.
//

import UIKit

class StudentProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contactLabel: UILabel!
    
    @IBOutlet weak var coursesLabel: UILabel!
    
    @IBOutlet weak var biographyLabel: UILabel!
    
    var coursesList: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = currentStudent.name
        contactLabel.text = currentStudent.email
        
        coursesList = currentStudent.courses.joined(separator: ", ")
        coursesLabel.text = coursesList
        biographyLabel.text = currentStudent.biography
        
        
        
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

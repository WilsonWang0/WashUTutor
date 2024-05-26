//
//  TutorViewAppointViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/12/23.
//

import UIKit

class TutorViewAppointViewController: UIViewController {
    
    
    @IBAction func goBack(_ sender: Any) {
        print("Back button clicked")
        _ = navigationController?.popViewController(animated: true)
    }
    

    @IBOutlet weak var appointAnnouncement: UITextView!
    @IBOutlet weak var courseNumber: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var student: UILabel!
    @IBOutlet weak var questionsTextView: UITextView!
    
    var courseNumberString: String?
    var dateString: String?
    var locationString: String?
    var startTimeString: String?
    var endTimeString: String?
    var studentString: String?
    var questionsString: String?
    var appointmentID: String?
    let dateFormatter = DateFormatter()
    var announcement: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        courseNumber.text = courseNumberString
        date.text = dateString
        time.text = (startTimeString ?? "") + "-" + (endTimeString ?? "")
        location.text = locationString
        appointAnnouncement.text = announcement
        //questionsTextView.text = questionsString
        
        if studentString != "Not booked by student." {
            getStudentQuestions(appointmentID: appointmentID ?? "") { questions, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let questions = questions {
                    // Process the retrieved questions
                    print("Questions: \(questions)")
                    self.questionsTextView.text = questions
                } else {
                    // Handle the case where no questions are found
                    print("No questions found for this appointment.")
                }
            }
        }
        else {
            self.questionsTextView.text = "No questions"
        }
        
        
        print("Student\(studentString ?? "")")
        student.text = studentString
        //print(appointmentID)

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func cancelAppointment(_ sender: Any) {
        //print(appointmentID)
        deleteTutorAppointment(appointmentID: appointmentID ?? "")
    
        let tutorCal = storyboard!.instantiateViewController(withIdentifier: "HomeSceneViewController") as! TutorManageAppointmentViewController
        
        navigationController?.pushViewController(tutorCal, animated: true)
        
        presentAlert(title: "Appointment canceled", message: "Appointment has been canceled.")
    }
    private func presentAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
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

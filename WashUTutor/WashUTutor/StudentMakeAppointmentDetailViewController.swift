import UIKit

class StudentMakeAppointmentDetailViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var questions: UITextField!
    @IBOutlet weak var appointmentClass: UILabel!
    @IBOutlet var appointmentDate: UILabel!
    @IBOutlet var appointmentTime: UILabel!
    @IBOutlet var appointmentTutorID: UILabel!
    @IBOutlet var appointmentLocation: UILabel!
    @IBOutlet var appointmentAnnouncement: UITextField!
    //@IBOutlet var tipsLabel: UILabel!
    
    var appointmentData: [String: Any]?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //appointmentAnnouncement.delegate = self
        questions.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
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

    @IBAction func confirmAppointment(_ sender: Any) {
        
        if let appointment = appointmentData {
            let appointmentID = appointment["appointmentID"] as? String ?? "DefaultID"
            let date = appointment["date"] as? String ?? "Unknown Date"
            let startTime = appointment["startTime"] as? String ?? "Unknown Start Time"
            let endTime = appointment["endTime"] as? String ?? "Unknown End Time"
            let location = appointment["location"] as? String ?? "Unknown Location"
            let subject = appointment["subject"] as? String ?? "Unknown Subject"


            createAppointment(appointmentID: appointmentID,
                              date: date,
                              startTime: startTime,
                              endTime: endTime,
                              location: location,
                              subject: subject,
                              caption: questions.text ?? "No questions")
            
            let studentMakeApp = storyboard!.instantiateViewController(withIdentifier: "studentMakeApp") as! StudentMakeAppointmentViewController
            
            navigationController?.pushViewController(studentMakeApp, animated: true)
            
            presentAlert(title: "Appointment created", message: "Appointment has been created.")
        }
        
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func updateUI() {
        //print("Received data: \(String(describing: appointmentData))")
        
        if let appointment = appointmentData {
            appointmentTime.text = "\(appointment["startTime"] as? String ?? "") - \(appointment["endTime"] as? String ?? "")"
            //appointmentTutorID.text = appointment["tutorID"] as? String
            appointmentClass.text = appointment["subject"] as? String
            appointmentLocation.text = appointment["location"] as? String
            appointmentAnnouncement.text = appointment["annoucement"] as? String
//            tipsLabel.text = "Questions for tutor: What would you like to work on? Please be specific, so your tutor can prepare! \nEx: Which section of the textbook or what topics?"

            getTutorNameFromAppointment(appointmentID: appointment["appointmentID"] as! String) { (tutorName, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let tutorName = tutorName {
                    //print("Tutor's Name: \(tutorName)")
                    self.appointmentTutorID.text = tutorName
                } else {
                    print("Tutor name not found for the given appointment ID.")
                }
            }
        
            
            
            // Format and display the date
            if let dateString = appointment["date"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                if let date = dateFormatter.date(from: dateString) {
                    dateFormatter.dateFormat = "EEE MMM d, yyyy"
                    appointmentDate.text = dateFormatter.string(from: date)
                }
            }
        }
    }
    
}

//
//  HomeSceneViewController.swift
//  WashUTutor
//
//  Created by Wilson Wang on 11/12/23.
//

import UIKit
import SwiftUI

class HomeSceneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @AppStorage("tutorID") var tutorID = ""
    //start
    //var myArray = ["Wilson", "Wang"]
    var myArray: [TutorAppointment] = []
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        myCell.textLabel?.text = myArray[indexPath.row].classNumber + "," + myArray[indexPath.row].startTime + "," + myArray[indexPath.row].endTime + "," + myArray[indexPath.row].appointmentID
        
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let TutorAppointVC = storyboard!.instantiateViewController(withIdentifier: "tutorAppoint") as! TutorViewAppointViewController
        
        TutorAppointVC.courseNumberString = myArray[indexPath.row].classNumber
        TutorAppointVC.dateString = myArray[indexPath.row].Date
        TutorAppointVC.locationString = myArray[indexPath.row].Location
        TutorAppointVC.questionsString = myArray[indexPath.row].annoucement
        TutorAppointVC.startTimeString = myArray[indexPath.row].startTime
        TutorAppointVC.endTimeString = myArray[indexPath.row].endTime
        TutorAppointVC.appointmentID = myArray[indexPath.row].appointmentID
        
        var student: String?
        if myArray[indexPath.row].status == "Booked" {
            getStudentNameFromAppointment(appointmentID: myArray[indexPath.row].appointmentID) { studentName, error in
                if let error = error {
                    // Handle the error
                    print("Error fetching student name: \(error.localizedDescription)")
                } else if let studentName = studentName {
                    // Use the student name
                    //print("Student name: \(studentName)")
                    student = studentName
                    //TutorAppointVC.studentString = studentName
                } else {
                    // Handle the case where student name is nil
                    print("Student name not found or another issue occurred")
                }
            }
        }
        else{
            //TutorAppointVC.studentString = "Not booked by student."
            student = "Not booked by student."
        }
        
        TutorAppointVC.studentString = student
        navigationController?.pushViewController(TutorAppointVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        getTutorInfo()
        //print(myArray)
        
        print("tutorid:\(tutorID)")
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //getTutorInfo()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    func getTutorInfo(){
        getAllTutorAppointments(tutorID: tutorID) { (appointments, error) in
            if let error = error {
                print("Error fetching appointments: \(error)")
            } else if let appointments = appointments {
                // Process the fetched appointments
                for appointment in appointments {
                    DispatchQueue.main.async {
                        self.myArray.append(appointment)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
   
    
    

    
    
    
        
    
}

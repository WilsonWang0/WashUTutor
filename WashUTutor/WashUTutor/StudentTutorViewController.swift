//
//  StudentTutorViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/12/23.
//

import UIKit

class StudentTutorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //var tutorNames: [String] = ["Haris Naveed", "Wilson Wang"]
    //var tutorNames: [String] = []
    var tutorData: [Tutor] = []
 
    @IBOutlet weak var tutorTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorTableView.dataSource = self
        tutorTableView.delegate = self
        
        AllTutorData { (tutors, error) in
            if let error = error {
                print("Error fetching tutors: \(error)")
            } else if let tutors = tutors {
                // Process the fetched tutor data
                for tutor in tutors {
                    DispatchQueue.main.async {
                        self.tutorData.append(tutor)
                        //self.tutorNames.append(tutor.name)
                        self.tutorTableView.reloadData()
                    }
                }
            }
        }
        
        self.tutorTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tutorData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = tutorData[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tutorInfoVC = storyboard!.instantiateViewController(withIdentifier: "tutorInfo") as! StudentTutorInfoPageViewController
        
        tutorInfoVC.tutorNameString = tutorData[indexPath.row].name
        tutorInfoVC.tutorYearString = tutorData[indexPath.row].year
        tutorInfoVC.tutorClasses = tutorData[indexPath.row].classNumber
        tutorInfoVC.tutorIDString = tutorData[indexPath.row].tutorID
        
        navigationController?.pushViewController(tutorInfoVC, animated: true)
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

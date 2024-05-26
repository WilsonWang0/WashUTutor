//
//  StudentTutorInfoPageViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/12/23.
//

import UIKit
import Cosmos

class StudentTutorInfoPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    
    @IBAction func goBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var tutorClassTableView: UITableView!
    @IBOutlet weak var tutorYear: UILabel!
    
    @IBOutlet weak var fiveStarRating: CosmosView!
    @IBOutlet weak var reviewTextBox: UITextView!
    
    var tutorNameString: String?
    var tutorYearString: String?
    var tutorClasses: [String]?
    var tutorEmail: String?
    var tutorIDString: String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorClassTableView.dataSource = self
        tutorClassTableView.delegate = self
        reviewTextBox.delegate = self
        tutorName.text = tutorNameString
        tutorYear.text = tutorYearString
        fiveStarRating.rating=5
        fiveStarRating.didFinishTouchingCosmos = { rating in}
        fiveStarRating.didTouchCosmos = {rating in}
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        self.tutorClassTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorClasses?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = tutorClasses?[indexPath.row]
        return cell
    }
    
    
    @IBAction func leaveReview(_ sender: Any) {
        addReview(review: reviewTextBox.text, ratings: String(fiveStarRating.rating), tutorID: tutorIDString ?? "")
        presentAlert(title: "Tutor Reviewed", message: "Thank you for reviewing. We appreciate your input.")
        
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

//
//  tutorProfileViewController.swift
//  WashUTutor
//
//  Created by Haris Naveed on 11/17/23.
//

import UIKit
import SwiftUI
import Cosmos

class tutorProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @AppStorage("tutorID") var tutorID = ""
    @AppStorage("tutorEmail") var tutorEmail = ""
    @AppStorage("tutorName") var tutorName = ""
    @AppStorage("tutorYear") var tutorYear = ""
    var reviewList: [String] = []
    var ratingList: [Double] = []

    @IBOutlet weak var tutorNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratings: CosmosView!
    
    @IBOutlet weak var reviewTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTable.dataSource = self
        reviewTable.delegate = self

        tutorNameLabel.text = tutorName
        yearLabel.text = tutorYear

        getReviewsFromDatabase()
        self.reviewTable.reloadData()
    }

    func getReviewsFromDatabase() {
        getReviews(tutorID: tutorID) { reviews in
            DispatchQueue.main.async {
                for review in reviews {
                    self.reviewList.append(review.review)
                    if let rating = Double(review.ratings) {
                        self.ratingList.append(rating)
                    }
                }
              
                let sum = self.ratingList.reduce(0, +)
                let average = !self.ratingList.isEmpty ? Double(sum) / Double(self.ratingList.count) : 0
                print(self.reviewList)
                print("Ratings List: \(self.ratingList)")
                print("Sum: \(sum)")
                print("Average: \(average)")

                self.ratings.rating = average
                self.reviewTable.reloadData()
             
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(reviewList.count)
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = reviewList[indexPath.row]
        return cell
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

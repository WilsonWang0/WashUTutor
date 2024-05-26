
import UIKit
import SwiftUI

class TutorManageAppointmentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    
    
    
    var selectedWeekStart: Date = Calendar.current.startOfWeek(for: Date())
    var bookedAppointmentData: [Any] = []
    var filteredAppointments: [Any] = []
    var selectedAppointmentID: String?
    
   
    @IBAction func logOut(_ sender: Any) {
        //_ = navigationController?.popToRootViewController(animated: true)
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialViewController = storyboard.instantiateInitialViewController(),
           let window = scene?.windows.first {
            let transition = CATransition()
            transition.duration = 0.10
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            window.layer.add(transition, forKey: kCATransition)

            window.rootViewController = initialViewController
            window.makeKeyAndVisible()
        }
    }
    @AppStorage("tutorID") var tutorID = ""

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    @IBOutlet var tutorsAppointmentTable: UITableView!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    var appointmentData: [TutorAppointment] = []
    var weekAppointments: [TutorAppointment] = []
    var currentWeek = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tutorsAppointmentTable.dataSource = self
        tutorsAppointmentTable.delegate = self
        tabBarController?.tabBar.barTintColor = UIColor(red: 128.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1)
        setCellsView()
        setWeekView()
//        getAllTutorAppointments(tutorID: tutorID) { appointments, error in
//            DispatchQueue.main.async() {
//                    if let error = error {
//                        print("Error fetching tutor appointments:", error)
//                    } else if let appointments = appointments {
//                        print("Fetched appointments: \(appointments)")
//                        self.appointmentData = appointments
//                        self.fetchAppointmentsForWeek()
//                        self.tutorsAppointmentTable.reloadData()
//                    }
//                }
//            }
    
        }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        getAllTutorAppointments(tutorID: tutorID) { appointments, error in
            DispatchQueue.main.async() {
                    if let error = error {
                        print("Error fetching tutor appointments:", error)
                    } else if let appointments = appointments {
                        print("Fetched appointments: \(appointments)")
                        self.appointmentData = appointments
                        self.fetchAppointmentsForWeek()
                        self.tutorsAppointmentTable.reloadData()
                    }
                }
            }
        
    }
    
    func getAppointmentsForSelectedDate() -> [TutorAppointment] {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"

          let selectedDateString = dateFormatter.string(from: selectedDate)

          return appointmentData.filter { appointment in
              return appointment.Date == selectedDateString
          }
      }

    func setCellsView()
    {
        let width = (weekCollectionView.frame.size.width ) / 10
        let height = (weekCollectionView.frame.size.height ) / 10
        
        let flowLayout = weekCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func indexOfSelectedDate() -> IndexPath? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"

        let selectedDayString = dateFormatter.string(from: selectedDate)
        if let dayIndex = totalSquares.firstIndex(of: selectedDayString) {
            return IndexPath(item: dayIndex, section: 0)
        }
        return nil
    }
    
    func setWeekView() {
        totalSquares.removeAll()
        
        let startOfWeek = CalendarFunc().startOfWeek(date: selectedDate)
        let endOfWeek = CalendarFunc().plusDays(date: startOfWeek, numberOfDays: 6)
        
        for i in 0..<7 {
            let day = CalendarFunc().plusDays(date: startOfWeek, numberOfDays: i)
            totalSquares.append(CalendarFunc().dayString(date: day))
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let startOfWeekString = dateFormatter.string(from: startOfWeek)
        let endOfWeekString = dateFormatter.string(from: endOfWeek)
        
        // Check if start and end of the week are in the same month
        if CalendarFunc().monthString(date: startOfWeek) == CalendarFunc().monthString(date: endOfWeek) {
            weekLabel.text = "\(startOfWeekString)-\(endOfWeekString)"
//            print("Same month")
            print(startOfWeekString)
        } else {
            // If not, include the month name for the end of the week
            dateFormatter.dateFormat = "MMMM d"
            let endOfWeekStringWithMonth = dateFormatter.string(from: endOfWeek)
            weekLabel.text = "\(startOfWeekString) - \(endOfWeekStringWithMonth)"
//            print("Different month")
            print(startOfWeekString)
        }
        weekCollectionView.reloadData()
        fetchAppointmentsForWeek()
    }
    
    func fetchAppointmentsForWeek() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startOfWeek = CalendarFunc().startOfWeek(date: selectedDate)
        let endOfWeek = CalendarFunc().plusDays(date: startOfWeek, numberOfDays: 6)

        weekAppointments = appointmentData.filter { appointment in
            guard let appointmentDate = dateFormatter.date(from: appointment.Date) else { return false }
            return appointmentDate >= startOfWeek && appointmentDate <= endOfWeek
        }

        DispatchQueue.main.async {
            self.tutorsAppointmentTable.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        cell.backgroundColor = UIColor.clear
        cell.dayOfMonth.textColor = UIColor.black
        return cell
    }
    
    // MARK: - Week calendar
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func convertStringToDate(dayString: String) -> Date {
        // totalSquares contains only day part as string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM" // Format for year and month

        // Constructing the full date string
        let dateString = dateFormatter.string(from: selectedDate) + "-\(dayString)"

        // Updating the date format to include the day
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Converting the string back to a Date object
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    // MARK: - Appointment info
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekAppointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cellIdentifier = "AppointmentCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        
        
        let appointment = weekAppointments[indexPath.row]
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.lightGray
        cell.selectedBackgroundView = backgroundView
        cell.backgroundColor = UIColor(#colorLiteral(red: 0.1879687607, green: 0.3521268368, blue: 0.06392926723, alpha: 0.8980392157))
        cell.textLabel?.textColor = UIColor.white
        
        if appointment.status == "Booked"{
            cell.backgroundColor = UIColor(red: 0.5436918736, green: 0.07118993253, blue: 0.1235529855, alpha: 1)
            cell.textLabel?.textColor = UIColor.white
        }
    

        
       let subject = appointment.classNumber
        let date =  appointment.Date
        let startTime = appointment.startTime
        let endTime = appointment.endTime
        let location = appointment.Location
        
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        cell.textLabel?.text = "\(subject) \(date) \n\(startTime) - \(endTime) \n\(location )"
        
       // cell.textLabel?.textColor = UIColor(red: 0.5436918736, green: 0.07118993253, blue: 0.1235529855, alpha: 1)
       
        
//        else {
//        cell.textLabel?.text = "Unknown"
//    }
        
//        cell.textLabel?.text = "\(appointment.startTime) - \(appointment.endTime), \(appointment.Location)"

        return cell
    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//               
//        let cellIdentifier = "BookedAppointmentCell"
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier),
//              let appointment = filteredAppointments[indexPath.row] as? [String: Any] else {
//            return UITableViewCell()
//        }
//        
//        if let subject = appointment["subject"] as? String,
//            let date = appointment["date"] as? String,
//            let startTime = appointment["startTime"] as? String,
//            let endTime = appointment["endTime"] as? String,
//            let location = appointment["location"] as? String {
//            cell.textLabel?.numberOfLines = 0
//            cell.textLabel?.lineBreakMode = .byWordWrapping
//            cell.textLabel?.text = "\(subject), \(date), \n\(startTime) - \(endTime), \(location)"
//        } else {
//            cell.textLabel?.text = "Unknown"
//        }
//        return cell
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tutorAppointVC = storyboard.instantiateViewController(withIdentifier: "TutorViewAppointViewController") as? TutorViewAppointViewController {
            if indexPath.row < weekAppointments.count {
                let appointment = weekAppointments[indexPath.row]

                tutorAppointVC.courseNumberString = appointment.classNumber
                tutorAppointVC.dateString = appointment.Date
                tutorAppointVC.locationString = appointment.Location
                tutorAppointVC.questionsString = appointment.annoucement
                tutorAppointVC.startTimeString = appointment.startTime
                tutorAppointVC.endTimeString = appointment.endTime
                tutorAppointVC.appointmentID = appointment.appointmentID
                tutorAppointVC.announcement = appointment.annoucement

                if appointment.status == "Booked" {
                    getStudentNameFromAppointment(appointmentID: appointment.appointmentID) { studentName, error in
                        DispatchQueue.main.async {
                            if let studentName = studentName {
                                tutorAppointVC.studentString = studentName
                                self.navigationController?.pushViewController(tutorAppointVC, animated: true)
                            } else if let error = error {
                                print("Error fetching student name: \(error.localizedDescription)")
                            } else {
                                print("Student name not found or another issue occurred")
                            }
                        }
                    }
                } else {
                    tutorAppointVC.studentString = "Not booked by student."
                    self.navigationController?.pushViewController(tutorAppointVC, animated: true)
                }
            }
        }
    }
    
    // MARK: - Week control action
    @IBAction func previousWeek(_ sender: Any) {
        selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate)!
        setWeekView()
    }

    @IBAction func nextWeek(_ sender: Any) {
        selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate)!
        setWeekView()
    }
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
    
    
        
}

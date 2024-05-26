

import UIKit

class StudentManageAppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet var bookedAppointmentTable: UITableView!
    @IBOutlet var cancelAppointmentButton: UIButton!
    
    var selectedWeekStart: Date = Calendar.current.startOfWeek(for: Date())
    var bookedAppointmentData: [Any] = []
    var filteredAppointments: [Any] = []
    var selectedAppointmentID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        bookedAppointmentTable.dataSource = self
        bookedAppointmentTable.delegate = self
//        tabBarController?.tabBar.barTintColor = UIColor(red: 128.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1)
        setWeekView()
        fetchAndFilterAppointments()
        self.bookedAppointmentTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAndFilterAppointments()
        self.bookedAppointmentTable.reloadData()
    }
    
    func setWeekView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: selectedWeekStart)!
        weekLabel.text = "\(dateFormatter.string(from: selectedWeekStart)) - \(dateFormatter.string(from: endOfWeek))"
    }

    func fetchAndFilterAppointments() {
        getStudentAppointments { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bookedAppointments):
                    print("Fetched Appointments: \(bookedAppointments)")
                    self?.bookedAppointmentData = bookedAppointments
                    self?.filterAppointmentsForSelectedWeek()
                    self?.bookedAppointmentTable.reloadData()
                case .failure(let error):
                    print("Error fetching student appointments:", error)
                }
            }
        }
    }

    func filterAppointmentsForSelectedWeek() {
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: selectedWeekStart)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

//        print("Selected Week Start: \(dateFormatter.string(from: selectedWeekStart))")
//        print("End of Week: \(dateFormatter.string(from: endOfWeek))")

        filteredAppointments = bookedAppointmentData.filter { appointment in
            guard let appointmentDict = appointment as? [String: Any],
                  let appointmentDateString = appointmentDict["date"] as? String,
                  let appointmentDate = dateFormatter.date(from: appointmentDateString) else {
                print("Failed to parse date string: \(String(describing: appointment))")
                return false
            }
            let isWithinWeek = appointmentDate >= selectedWeekStart && appointmentDate <= endOfWeek
            print("Checking appointment on \(appointmentDateString): \(isWithinWeek)")
            return isWithinWeek
        }
//        print("Filtered Appointments for Selected Week: \(filteredAppointments)")
        bookedAppointmentTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAppointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BookedAppointmentCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier),
              let appointment = filteredAppointments[indexPath.row] as? [String: Any] else {
            return UITableViewCell()
        }
        
        if let subject = appointment["subject"] as? String,
            let date = appointment["date"] as? String,
            let startTime = appointment["startTime"] as? String,
            let endTime = appointment["endTime"] as? String,
            let location = appointment["location"] as? String {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = "\(subject), \(date), \n\(startTime) - \(endTime), \(location)"
            cell.textLabel?.textColor = UIColor.white
        } else {
            cell.textLabel?.text = "Unknown"
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(#colorLiteral(red: 0.1879687607, green: 0.3521268368, blue: 0.06392926723, alpha: 0.8980392157))
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    // MARK: -  Select and delete
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let appointment = filteredAppointments[indexPath.row] as? [String: Any],
              let appointmentID = appointment["appointmentID"] as? String else {
            print("Failed to get appointment ID")
            return
        }
        selectedAppointmentID = appointmentID
    }


    @IBAction func cancelAppointmentAction(_ sender: Any) {
        guard let appointmentID = selectedAppointmentID else {
            print("No appointment selected")
            return
        }
        showDeleteWarning()
    }
    
    func showDeleteWarning() {
        let alert = UIAlertController(title: "Warning", message: "Do you have to cancel this appointment?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
            guard let strongSelf = self, let appointmentID = strongSelf.selectedAppointmentID else { return }
            
            deleteStudentAppointments(appointmentID: appointmentID)
            
//  1s dealy before refreshing the appointment
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                strongSelf.fetchAndFilterAppointments()
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }
    
    

    
    // MARK: - Week control action
    @IBAction func previousWeek(_ sender: Any) {
        selectedWeekStart = Calendar.current.date(byAdding: .day, value: -7, to: selectedWeekStart)!
        setWeekView()
        filterAppointmentsForSelectedWeek()
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        selectedWeekStart = Calendar.current.date(byAdding: .day, value: 7, to: selectedWeekStart)!
        setWeekView()
        filterAppointmentsForSelectedWeek()
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}

// Get the start of the week
extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components)!
    }
}

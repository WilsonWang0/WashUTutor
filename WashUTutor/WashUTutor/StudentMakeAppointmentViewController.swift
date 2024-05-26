
import UIKit

class StudentMakeAppointmentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    
    @IBAction func logOut(_ sender: Any) {
//        _ = navigationController?.popToRootViewController(animated: true)
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
    
    
    
    @IBOutlet var availableAppointmentTable: UITableView!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    var appointmentData: Array<Any> = []
    var currentWeek = 0
    var selectedIndex: IndexPath?
    var allClasses: [String] = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //classButton.menu = menu
        availableAppointmentTable.dataSource = self
        availableAppointmentTable.delegate = self
        setCellsView()
        setWeekView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllAvailableAppointments { result in
            switch result {
            case .success(let appointments):
                print(appointments)
                self.appointmentData = appointments
                self.availableAppointmentTable.reloadData()
            case .failure(let error):
                print("Error fetching appointments:", error)
            }
        }
    }
        
    func getAppointmentsForSelectedDate() -> [Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the format to match the format in your data

        let selectedDateString = dateFormatter.string(from: selectedDate)

        return appointmentData.filter { appointment in
            guard let appointmentDict = appointment as? [String: Any],
                  let appointmentDate = appointmentDict["date"] as? String else {
                return false
            }
            return appointmentDate == selectedDateString
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
        dateFormatter.dateFormat = "d" // Format to get only the day part

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
        selectedIndex = indexOfSelectedDate()
        weekCollectionView.reloadData()
    }
    
    // MARK: - Week calendar
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        cell.dayOfMonth.text = totalSquares[indexPath.item]

        if indexPath == selectedIndex {
            cell.backgroundColor = UIColor.gray
            cell.dayOfMonth.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.clear
            cell.dayOfMonth.textColor = UIColor.black
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath

        let selectedDayString = totalSquares[indexPath.item]
        selectedDate = convertStringToDate(dayString: selectedDayString)

        collectionView.reloadData()
        availableAppointmentTable.reloadData()
    }
    
    func convertStringToDate(dayString: String) -> Date {
        // Assuming totalSquares contains only day part as string (e.g., "15")
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
        //print("All appointment data: \(self.appointmentData)")
        let filteredAppointments = getAppointmentsForSelectedDate()
        print(filteredAppointments)
        return filteredAppointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AppointmentCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)

        let filteredAppointments = getAppointmentsForSelectedDate()
        if let cellAppointment = filteredAppointments[indexPath.row] as? [String: Any],
           let subject = cellAppointment["subject"] as? String,
           let date = cellAppointment["date"] as? String,

           let startTime = cellAppointment["startTime"] as? String,
           let endTime = cellAppointment["endTime"] as? String,
           let location = cellAppointment["location"] as? String {
            
            cell.textLabel?.numberOfLines = 0
            
            cell.textLabel?.lineBreakMode = .byWordWrapping
            
            cell.textLabel?.text = "\(subject) \(date) \n\(startTime) - \(endTime) \n\(location )"
            
//            cell.textLabel?.text = "\(startTime) - \(endTime) \n\(location)"
        } else {
            cell.textLabel?.text = "Unknown"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "StudentMakeAppointmentDetailViewController") as? StudentMakeAppointmentDetailViewController {
            let filteredAppointments = getAppointmentsForSelectedDate()
            if indexPath.row < filteredAppointments.count {
                detailViewController.appointmentData = filteredAppointments[indexPath.row] as? [String: Any]
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
    
    // MARK: - Week control action
    @IBAction func previousWeek(_ sender: Any)
    {
        selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate)!
        if selectedDate < CalendarFunc().firstOfMonth(date: selectedDate) {
            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: CalendarFunc().firstOfMonth(date: selectedDate))!
            selectedDate = CalendarFunc().startOfWeek(date: selectedDate)
        }
        setWeekView()
        availableAppointmentTable.reloadData()
    }
    
    @IBAction func nextWeek(_ sender: Any)
    {
        selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate)!
        if selectedDate >= CalendarFunc().firstOfNextMonth(date: selectedDate) {
            selectedDate = CalendarFunc().firstOfNextMonth(date: selectedDate)
        }
        setWeekView()
        availableAppointmentTable.reloadData()
    }
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
}

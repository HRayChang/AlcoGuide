//
//  MyScheduleDetailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/18.
//

import UIKit
import FirebaseFirestore

class MyScheduleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableView()
        
        tableView.register(MyScheduleDetailActivitiesTableViewCell.self, forCellReuseIdentifier: "ActivitiesCell")
        tableView.register(MyScheduleDetailLocationNameTableViewCell.self, forCellReuseIdentifier: "LocationNameCell")
        tableView.register(MyScheduleDetailButtonTableViewCell.self, forCellReuseIdentifier: "ButtonCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setupTableView() {
        // Add the tableView to the view hierarchy
        view.addSubview(tableView)
        
        // Enable autoresizing mask for the tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for the tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections based on the count of currentLocations
        return CurrentSchedule.currentLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check if there are locations in the array and if the section index is within bounds
        if let currentLocations = CurrentSchedule.currentLocations, section < currentLocations.count {
            // Return the number of activities in the current section
            return currentLocations[section].activities!.count + 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentLocations = CurrentSchedule.currentLocations else {
            fatalError("Current locations not available")
        }

        let location = currentLocations[indexPath.section]

        if indexPath.row == 0 {
            // First cell in each section, display locationName
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationNameCell", for: indexPath) as? MyScheduleDetailLocationNameTableViewCell else {
                fatalError("Unable to dequeue LocationNameTableViewCell")
            }
            
            // Configure the cell with locationName
            cell.locationNameLabel.text = location.locationName ?? "No Location Name"
            return cell
        } else if indexPath.row == location.activities!.count + 1 {
            // Last cell in each section, display ButtonTableViewCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? MyScheduleDetailButtonTableViewCell else {
                fatalError("Unable to dequeue ButtonTableViewCell")
            }
            
            cell.locationName = location.locationName
            return cell
        } else {
            // Subsequent cells, display ActivityTableViewCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesCell", for: indexPath) as? MyScheduleDetailActivitiesTableViewCell else {
                fatalError("Unable to dequeue ActivityTableViewCell")
            }
            
            // Configure the cell with activity information
            if let activities = location.activities, indexPath.row <= activities.count {
                let activity = activities[indexPath.row - 1] // Adjust index for the first cell
                cell.activityLabel.text = activity
            }
            
            return cell
        }
    }
}

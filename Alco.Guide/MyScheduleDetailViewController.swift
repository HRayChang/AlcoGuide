//
//  MyScheduleDetailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/18.
//

import UIKit
import FirebaseFirestore

class MyScheduleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentLocations: [String: GeoPoint]?
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableView()
        
        tableView.register(MyScheduleDetailTableViewCell.self, forCellReuseIdentifier: "MyScheduleDetailTableViewCell")
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentSchedule.currentLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyScheduleDetailTableViewCell", for: indexPath) as? MyScheduleDetailTableViewCell else {
            fatalError("Unable to dequeue MyScheduleDetailTableViewCell")
        }
       
        if let locations = CurrentSchedule.currentLocations, indexPath.row < locations.count {
               let locationKeys = Array(locations.keys)
               let selectedKey = locationKeys[indexPath.row]
               cell.locationNameLabel.text = selectedKey
        } else {
            cell.locationNameLabel.text = "N/A" // Or any default text if data is not available
        }
        
        return cell
    }
}

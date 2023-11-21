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
    
    let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupMyScheduleDetailViewUI()
        setupConstraints()
        
        tableView.register(MyScheduleDetailActivitiesTableViewCell.self, forCellReuseIdentifier: "ActivitiesCell")
        tableView.register(MyScheduleDetailLocationNameTableViewCell.self, forCellReuseIdentifier: "LocationNameCell")
        tableView.register(MyScheduleDetailButtonTableViewCell.self, forCellReuseIdentifier: "ButtonCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        tableView.setEditing(true, animated: false)
        editButtonTapped()
        
    }
    
    func setupMyScheduleDetailViewUI() {
        
        view.backgroundColor = UIColor.black
        
        tableView.backgroundColor = UIColor.black
        
        overrideUserInterfaceStyle = .dark
        
    }
        
    func setupConstraints() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
 
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func editButtonTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
                             
        if (!tableView.isEditing) {
    
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(MyScheduleViewController.editButtonTapped))
            
        } else {

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(MyScheduleViewController.editButtonTapped))
            
            self.view.endEditing(true)

        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let currentLocations = CurrentSchedule.currentLocations {
            return currentLocations.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentLocations = CurrentSchedule.currentLocations else {
            fatalError("Current locations not available")
        }
        guard let currentActivities = CurrentSchedule.currentActivities else {
            fatalError("Current activities not available")
        }

        return (currentActivities[currentLocations[section]]?.count ?? 0) + 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentLocations = CurrentSchedule.currentLocations else {
            fatalError("Current locations not available")
        }
        guard let currentActivities = CurrentSchedule.currentActivities else {
            fatalError("Current activities not available")
        }

        let location = currentLocations[indexPath.section]

        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationNameCell", for: indexPath) as? MyScheduleDetailLocationNameTableViewCell else {
                fatalError("Unable to dequeue LocationNameTableViewCell")
            }
            
            cell.locationNameLabel.text = location

            return cell
            
        } else if indexPath.row == (currentActivities[location]?.count ?? 0) + 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? MyScheduleDetailButtonTableViewCell else {
                fatalError("Unable to dequeue ButtonTableViewCell")
            }
            
            cell.locationName = location
            
            return cell
            
        } else {
       
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesCell", for: indexPath) as? MyScheduleDetailActivitiesTableViewCell else {
                fatalError("Unable to dequeue ActivityTableViewCell")
            }
            
            let activities = currentActivities[location]
            
            print(currentActivities[location])
            
            let activity = activities?[indexPath.row - 1]
                cell.activityLabel.text = activity
            print("!!!!!!!!\(activity)")
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        }
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        tableView.reloadData()
    }
}

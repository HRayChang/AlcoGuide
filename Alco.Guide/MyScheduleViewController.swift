//
//  ScheduleViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/15.
//

import UIKit
import FirebaseFirestore

enum Section: String, CaseIterable {
  case running = "Running"
  case finished = "Finished"
}

class MyScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupMyScheduleViewUI()
        setupConstraints()
        
        fetchSchedules()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.setEditing(true, animated: false)
        editButtonTapped()
    }
    
    @objc private func fetchSchedules() {
        dataManager.fetchSchedules { [weak self] success in
            guard let self = self, success else { return }
            self.tableView.reloadData()
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrentScheduleLabel), name: Notification.Name("CurrentSchedule"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchSchedules), name: Notification.Name("UpdateLocationOrder"), object: nil)
    }
    
    @objc private func updateCurrentScheduleLabel(_ notification: Notification) {
        fetchSchedules()
    }
    
    func setupMyScheduleViewUI() {
        view.backgroundColor = UIColor.black
        
        tableView.backgroundColor = UIColor.black
        
        overrideUserInterfaceStyle = .dark
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.barTintColor = UIColor.black
    }
    
    func setupConstraints() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(MyScheduleTableViewCell.self, forCellReuseIdentifier: "cell")
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
    
    func postCurrentScheduleNotification(scheduleInfo: [String: Any]) {
            NotificationCenter.default.post(name: Notification.Name("CurrentSchedule"), object: nil, userInfo: scheduleInfo)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allCases[section] {
        case .running:
            return dataManager.runningSchedules.count
        case .finished:
            return dataManager.finishedSchedules.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyScheduleTableViewCell else {
            fatalError("Unable to dequeue MyScheduleTableViewCell")
        }
        
        switch Section.allCases[indexPath.section] {
        case .running:
            cell.configureCell(with: dataManager.runningSchedules, at: indexPath.row)
        case .finished:
            cell.configureCell(with: dataManager.finishedSchedules, at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch Section.allCases[indexPath.section] {
        case .running:
            CurrentSchedule.currentScheduleID = dataManager.runningSchedules[indexPath.row].scheduleID
            CurrentSchedule.currentScheduleName = dataManager.runningSchedules[indexPath.row].scheduleName
            CurrentSchedule.currentIsRunnung = dataManager.runningSchedules[indexPath.row].isRunning
            CurrentSchedule.currentLocations = dataManager.runningSchedules[indexPath.row].locations
            CurrentSchedule.currentActivities = dataManager.runningSchedules[indexPath.row].activities
        case .finished:
            CurrentSchedule.currentScheduleID = dataManager.finishedSchedules[indexPath.row].scheduleID
            CurrentSchedule.currentScheduleName = dataManager.finishedSchedules[indexPath.row].scheduleName
            CurrentSchedule.currentIsRunnung = dataManager.finishedSchedules[indexPath.row].isRunning
            CurrentSchedule.currentLocations = dataManager.finishedSchedules[indexPath.row].locations
            CurrentSchedule.currentActivities = dataManager.finishedSchedules[indexPath.row].activities
        }
        
        let myScheduleDetailViewController = UINavigationController(rootViewController: MyScheduleDetailViewController())

        present(myScheduleDetailViewController, animated: true, completion: nil)
        
        postCurrentScheduleNotification(scheduleInfo: ["scheduleID": CurrentSchedule.currentScheduleID!, "scheduleName": CurrentSchedule.currentScheduleName!])
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            switch Section.allCases[indexPath.section] {
            case .running:
                let scheduleID = dataManager.runningSchedules[indexPath.row].scheduleID
                dataManager.deleteSchedule(scheduleID: scheduleID)
            case .finished:
                let scheduleID = dataManager.finishedSchedules[indexPath.row].scheduleID
                dataManager.deleteSchedule(scheduleID: scheduleID)
            }
            fetchSchedules()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch Section.allCases[indexPath.section] {
        case .running:
            return true
        case .finished:
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let scheduleIDToMove = dataManager.runningSchedules.remove(at: sourceIndexPath.row)

        if sourceIndexPath.section == destinationIndexPath.section {
            
            dataManager.runningSchedules.insert(scheduleIDToMove, at: destinationIndexPath.row)
            
        } else {
            
            dataManager.finishedSchedules.insert(scheduleIDToMove, at: destinationIndexPath.row)
            
           let scheduleID = scheduleIDToMove.scheduleID
            dataManager.finishSchedule(for: scheduleID, isRunning: destinationIndexPath.section == 0) { error in
                if let error = error {
                    print("Error updating Firestore document: \(error.localizedDescription)")
                } else {
                    print("Finished Schedule successfully!")
                }
            }
        }

        fetchSchedules()
        
        tableView.reloadData()
    }
}

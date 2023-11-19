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
  case finished = "Finished!"
}

class MyScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    let locationDataManager = LocationDataManager.shared
    
    var scheduleInfo = ScheduleInfo(scheduleID: nil, scheduleName: nil, isRunning: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupMyScheduleViewUI()
        setupConstraints()
        
        setupObservers()
        
        fetchSchedules()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        tableView.setEditing(true, animated: false)
        editButtonTapped()

    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchSchedules), name: Notification.Name("ScheduleAdd"), object: nil)
    }
    
    @objc private func fetchSchedules() {
        locationDataManager.fetchSchedules { [weak self] success in
            guard let self = self, success else { return }
            self.tableView.reloadData()
        }
    }
    
    func setupMyScheduleViewUI() {
        view.backgroundColor = UIColor.black
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allCases[section] {
        case .running:
            return locationDataManager.runningSchedules.count
        case .finished:
            return locationDataManager.finishedSchedules.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyScheduleTableViewCell else {
            fatalError("Unable to dequeue MyScheduleTableViewCell")
        }
        
        switch Section.allCases[indexPath.section] {
        case .running:
            cell.configureCell(with: locationDataManager.runningSchedules, at: indexPath.row)
        case .finished:
            cell.configureCell(with: locationDataManager.finishedSchedules, at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch Section.allCases[indexPath.section] {
        case .running:
            scheduleInfo.scheduleID = locationDataManager.runningSchedules[indexPath.row].scheduleID
            scheduleInfo.scheduleName = locationDataManager.runningSchedules[indexPath.row].scheduleName
            scheduleInfo.isRunnung = locationDataManager.runningSchedules[indexPath.row].isRunnung
        case .finished:
            scheduleInfo.scheduleID = locationDataManager.finishedSchedules[indexPath.row].scheduleID
            scheduleInfo.scheduleName = locationDataManager.finishedSchedules[indexPath.row].scheduleName
            scheduleInfo.isRunnung = locationDataManager.finishedSchedules[indexPath.row].isRunnung
        }
        
        
        let myScheduleDetailViewController = MyScheduleDetailViewController()
        
        myScheduleDetailViewController.title = scheduleInfo.scheduleName
        
        navigationController?.pushViewController(myScheduleDetailViewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            switch Section.allCases[indexPath.section] {
            case .running:
                guard let scheduleID = locationDataManager.runningSchedules[indexPath.row].scheduleID else { return }
                locationDataManager.deleteSchedule(scheduleID: scheduleID)
            case .finished:
                guard let scheduleID = locationDataManager.finishedSchedules[indexPath.row].scheduleID else { return }
                locationDataManager.deleteSchedule(scheduleID: scheduleID)
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
        let scheduleIDToMove = locationDataManager.runningSchedules.remove(at: sourceIndexPath.row)

        if sourceIndexPath.section == destinationIndexPath.section {
            // Moving within the same section (running section)
            locationDataManager.runningSchedules.insert(scheduleIDToMove, at: destinationIndexPath.row)
        } else {
            // Moving to the "finished" section
            locationDataManager.finishedSchedules.insert(scheduleIDToMove, at: destinationIndexPath.row)
        }

        locationDataManager.finishSchedule(for: scheduleIDToMove.scheduleID!, isRunning: sourceIndexPath.section == 0) { error in
            if let error = error {
                print("Error updating Firestore document: \(error.localizedDescription)")
            } else {
                print("Firestore document updated successfully!")
            }
        }
        fetchSchedules()

        tableView.reloadData() // Refresh the table view
    }

    
}




//guard
//    sourceIndexPath != destinationIndexPath,
//    sourceIndexPath.section == destinationIndexPath.section,
//    let ScheduleIDToMove = locationDataManager.runningSchedules[sourceIndexPath],
//    let ScheduleIDAtDestination = locationDataManager.finishedSchedules[sourceIndexPath]
//else {
//    return
//}
//
//locationDataManager.reorderSchedules(ScheduleToMove: ScheduleIDToMove, ScheduleAtDestination: ScheduleIDAtDestination)
//
//
////            switch Section.allCases[sourceIndexPath.section] {
////            case .running:
////                scheduleIDToMove = locationDataManager.runningSchedules[sourceIndexPath.row].scheduleID
////            case .finished:
////                scheduleIDToMove = locationDataManager.finishedSchedules[sourceIndexPath.row].scheduleID
////            }
//
//
//locationDataManager.finishSchedule(for: ScheduleIDToMove, isRunning: false) { error in
//    if let error = error {
//        print("Error updating Firestore document: \(error.localizedDescription)")
//    } else {
//        print("Firestore document updated successfully!")
//    }
//}
//fetchSchedules()

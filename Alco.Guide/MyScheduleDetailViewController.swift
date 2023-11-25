//
//  MyScheduleDetailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/18.
//

import UIKit

protocol MyScheduleDetailButtonCellDelegate: AnyObject {
    func addButtonTapped(in cell: MyScheduleDetailButtonTableViewCell)
    func sendButtonTapped(in cell: MyScheduleDetailButtonTableViewCell, text: String)
}

class MyScheduleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate, MyScheduleDetailButtonCellDelegate {
    
    let tableView = UITableView()
    
    let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        setupMyScheduleDetailViewUI()
        setupConstraints()
        
        tableView.register(MyScheduleDetailActivitiesTableViewCell.self, forCellReuseIdentifier: "ActivitiesCell")
        tableView.register(MyScheduleDetailLocationNameTableViewCell.self, forCellReuseIdentifier: "LocationNameCell")
        tableView.register(MyScheduleDetailButtonTableViewCell.self, forCellReuseIdentifier: "ButtonCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        tableView.setEditing(true, animated: false)
        //        editButtonTapped()
        
    }
    
    func setupMyScheduleDetailViewUI() {
        
        view.backgroundColor = UIColor.black
        
        tableView.backgroundColor = UIColor.black
        
        overrideUserInterfaceStyle = .dark
        
        navigationItem.title = CurrentSchedule.currentScheduleName
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
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
    
    // MARK: - Drag & Drop
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        var dragItem: UIDragItem?
        
        if indexPath.row == 0 {
            
            // Drag the whole section
            let draggedItem = CurrentSchedule.currentLocations![indexPath.section]
            dragItem = UIDragItem(itemProvider: NSItemProvider(object: draggedItem as NSItemProviderWriting))
            
            // Hidden cells when drag
            tableView.performBatchUpdates({
                let section = indexPath.section
                let numberOfRows = tableView.numberOfRows(inSection: section)
                
                for row in 1..<numberOfRows {
                    let indexPathToHide = IndexPath(row: row, section: section)
                    if let cell = tableView.cellForRow(at: indexPathToHide) {
                        cell.isHidden = true
                    }
                }
            }, completion: nil)
            
        } else {
            
            // Drag the single cell
            dragItem = UIDragItem(itemProvider: NSItemProvider())
        }
        
        return [dragItem!]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        guard var sourceIndexPath = coordinator.items.first?.sourceIndexPath,
              var destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }
        
        if sourceIndexPath.row == 0 {
            
            
            if sourceIndexPath.section == destinationIndexPath.section {
                return
            }
            
            // Change the whole section
            let draggedItem = CurrentSchedule.currentLocations![sourceIndexPath.section]
            CurrentSchedule.currentLocations!.remove(at: sourceIndexPath.section)
            CurrentSchedule.currentLocations!.insert(draggedItem, at: destinationIndexPath.section)
            
            tableView.performBatchUpdates({
                tableView.moveSection(sourceIndexPath.section, toSection: destinationIndexPath.section)
            }, completion: nil)
            
            dataManager.updateLocationOrder(sourceIndexPath: sourceIndexPath.section, destinationIndexPath: destinationIndexPath.section, scheduleID: CurrentSchedule.currentScheduleID!)
            
            
        } else {
            
            
            if destinationIndexPath.row == 0 || destinationIndexPath.row == CurrentSchedule.currentActivities![CurrentSchedule.currentLocations![destinationIndexPath.section]]!.count + 2 {
                return
            }
            
            // Change the cell index
            let draggedItem = CurrentSchedule.currentActivities![CurrentSchedule.currentLocations![sourceIndexPath.section]]![sourceIndexPath.row - 1]
            CurrentSchedule.currentActivities![CurrentSchedule.currentLocations![sourceIndexPath.section]]!.remove(at: sourceIndexPath.row - 1)
            CurrentSchedule.currentActivities![CurrentSchedule.currentLocations![destinationIndexPath.section]]!.insert(draggedItem, at: destinationIndexPath.row - 1)
            
            // Update the tableView with animation
            tableView.performBatchUpdates({
                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            }, completion: nil)
            
            dataManager.updateActivityOrder(sourceIndexPath: sourceIndexPath,
                                            destinationIndexPath: destinationIndexPath,
                                            scheduleID: CurrentSchedule.currentScheduleID!,
                                            currentLocations: CurrentSchedule.currentLocations!)
            
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        // Show hidden cells after drag
        UIView.animate(withDuration: 0.3) {
            tableView.visibleCells.forEach { $0.isHidden = false }
        }
        
        // Allow dropping anywhere in the table view
        let isSectionDraggable = destinationIndexPath != nil
        return UITableViewDropProposal(operation: isSectionDraggable ? .move : .forbidden, intent: .insertAtDestinationIndexPath)
        
    }
    // MARK: Drag & Drop -
    
    // MARK: - TableView
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
            
            
            cell.delegate = self
            
            cell.locationName = location
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesCell", for: indexPath) as? MyScheduleDetailActivitiesTableViewCell else {
                fatalError("Unable to dequeue ActivityTableViewCell")
            }
            
            let activities = currentActivities[location]
            
            let activity = activities?[indexPath.row - 1]
            cell.activityLabel.text = activity
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentLocations = CurrentSchedule.currentLocations else {
            fatalError("Current locations not available")
        }
        guard var currentActivities = CurrentSchedule.currentActivities else {
            fatalError("Current activities not available")
        }
        
        let location = currentLocations[indexPath.section]
        
        if indexPath.row == 0 || indexPath.row == (currentActivities[location]?.count ?? 0) + 1 {
            return
        } else {
            
            let alertController = UIAlertController(title: "Edit Label", message: nil, preferredStyle: .alert)
            if let alertControllerView = alertController.view {
                alertControllerView.tintColor = UIColor.black
                alertControllerView.backgroundColor = UIColor.black
            }

            alertController.addTextField { textField in
                textField.text = currentActivities[location]?[indexPath.row - 1]
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                if let textField = alertController.textFields?.first, let newText = textField.text {
                    // 更新数据源并刷新TableView
                    CurrentSchedule.currentActivities?[location]?[indexPath.row - 1] = newText
                    self.tableView.reloadData()
                    
                    self.dataManager.updateActivity(scheduleID: CurrentSchedule.currentScheduleID!, locationName: location, text: newText, indexPath: indexPath) { error in
                        
                        
                    }
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        guard let currentLocations = CurrentSchedule.currentLocations else {
            fatalError("Current locations not available")
        }
        guard let currentActivities = CurrentSchedule.currentActivities else {
            fatalError("Current activities not available")
        }
        
        if indexPath.row == (currentActivities[currentLocations[indexPath.section]]?.count ?? 0) + 1 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row == 0 {
                
                guard let scheduleID = CurrentSchedule.currentScheduleID else { return }
                var deletedValue = (CurrentSchedule.currentLocations?.remove(at: indexPath.section))!
                dataManager.deleteLocation(scheduleID: scheduleID, locationIndex: indexPath.section, deletedValue: deletedValue)
                tableView.beginUpdates()
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                tableView.endUpdates()
                NotificationCenter.default.post(name: Notification.Name("DeletedLocation"), object: nil, userInfo: nil)
                tableView.reloadData()
            } else {
                guard let scheduleID = CurrentSchedule.currentScheduleID else { return }
                guard let currentLocation = CurrentSchedule.currentLocations?[indexPath.section] else { return }
                
                let dispatchGroup = DispatchGroup()
                
                dispatchGroup.enter()
                CurrentSchedule.currentActivities?[currentLocation]?.remove(at: indexPath.row - 1)
                dataManager.deleteActivity(scheduleID: CurrentSchedule.currentScheduleID!, currentLocations: CurrentSchedule.currentLocations!, indexPath: indexPath)
                dispatchGroup.leave()
                dispatchGroup.notify(queue: .main) {
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                    NotificationCenter.default.post(name: Notification.Name("DeletedActivite"), object: nil, userInfo: nil)
                    tableView.reloadData()
                }
            }
        }
    }
    // MARK: TableView -
    
    func addButtonTapped(in cell: MyScheduleDetailButtonTableViewCell) {
        // Handle add button tap
        if let indexPath = tableView.indexPath(for: cell) {
            // You can use indexPath to identify the cell if needed
        }
        cell.addActivityButton.isHidden = true
        cell.addActivityTextField.isHidden = false
        cell.sendButton.isHidden = false
    }
    
    func sendButtonTapped(in cell: MyScheduleDetailButtonTableViewCell, text: String) {
        // Handle send button tap
        if let indexPath = tableView.indexPath(for: cell) {
            // You can use indexPath to identify the cell if needed
        }
        let scheduleID = CurrentSchedule.currentScheduleID
        
        DataManager.shared.addActivities(scheduleID: scheduleID!, locationName: cell.locationName!, text: text) { result in
            switch result {
            case .success:
                print("Activities successfully updated in Firestore")
                
                if let indexPath = self.tableView.indexPath(for: cell), let scheduleID = CurrentSchedule.currentScheduleID {
                    // Add a new activity to the data source
                    var newActivity = text
                    CurrentSchedule.currentActivities![cell.locationName!]?.append(text)

                    
                    // Update the tableView
                    self.tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .automatic)
                }
                self.tableView.reloadData()
            case .failure(let error):
                print("Error updating activities in Firestore: \(error)")
            }
        }

        // Hide the text field and send button after sending the data
        cell.addActivityButton.isHidden = false
        cell.addActivityTextField.isHidden = true
        cell.sendButton.isHidden = true
        cell.addActivityTextField.text = nil // Clear the text field
    }
    
}

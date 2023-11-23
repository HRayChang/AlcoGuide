//
//  MyScheduleDetailViewController.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/11/18.
//

import UIKit

class MyScheduleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    
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
        }
        
        dataManager.updateLocationOrder(sourceIndexPath: sourceIndexPath.section, destinationIndexPath: destinationIndexPath.section, scheduleID: CurrentSchedule.currentScheduleID!)
        
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
                CurrentSchedule.currentLocations?.remove(at: indexPath.row)
                dataManager.deleteLocation(scheduleID: scheduleID, locationIndex: indexPath.section)
                tableView.beginUpdates()
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                tableView.endUpdates()
            } else {
                
            }
        }
    }
    // MARK: TableView -
}

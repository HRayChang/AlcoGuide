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
        tableView.reloadData()
        
//        tableView.setEditing(true, animated: false)
//        editButtonTapped()
        
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
    
//    @objc func editButtonTapped() {
//        tableView.setEditing(!tableView.isEditing, animated: true)
//                             
//        if (!tableView.isEditing) {
//    
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "編輯", style: .plain, target: self, action: #selector(MyScheduleViewController.editButtonTapped))
//            
//        } else {
//
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(MyScheduleViewController.editButtonTapped))
//            
//            self.view.endEditing(true)
//
//        }
//    }
    
    // MARK: - Drag
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        var dragItem: UIDragItem?
        
        if indexPath.row == 0 {
            
            let draggedItem = CurrentSchedule.currentLocations![indexPath.section]
            dragItem = UIDragItem(itemProvider: NSItemProvider(object: draggedItem as NSItemProviderWriting))
            
        } else {
            
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
            
            let draggedItem = CurrentSchedule.currentLocations![sourceIndexPath.section]
            CurrentSchedule.currentLocations!.remove(at: sourceIndexPath.section)
            CurrentSchedule.currentLocations!.insert(draggedItem, at: destinationIndexPath.section)
            
            tableView.performBatchUpdates({
                tableView.moveSection(sourceIndexPath.section, toSection: destinationIndexPath.section)
            }, completion: nil)
            
        } else {
            
            if destinationIndexPath.row == 0 || destinationIndexPath.row == CurrentSchedule.currentActivities![CurrentSchedule.currentLocations![destinationIndexPath.section]]!.count - 1 {
                return
            }
            
            let draggedItem = CurrentSchedule.currentActivities![CurrentSchedule.currentLocations![sourceIndexPath.section]]![sourceIndexPath.row - 1]
            CurrentSchedule.currentActivities![CurrentSchedule.currentLocations![sourceIndexPath.section]]!.remove(at: sourceIndexPath.row - 1)
            CurrentSchedule.currentActivities![CurrentSchedule.currentLocations![destinationIndexPath.section]]!.insert(draggedItem, at: destinationIndexPath.row - 1)
            
            //            if let indexPath = coordinator.destinationIndexPath {
            //                print(indexPath)
            //                destinationIndexPath = indexPath
            //            } else {
            //                // 如果目标 indexPath 为 nil，说明拖曳到了一个空白区域
            //                // 这里可以根据实际需求处理
            //
            //                return
            //            }
            // 在这里处理数据源的更新
            // 例如，将源 indexPath 的数据移动到目标 indexPath
            // 注意，这里的更新操作可能涉及你的数据源数组，具体实现取决于你的数据结构
            // 这里只是一个示例，实际情况需要根据你的数据源结构进行调整
            //            let draggedItem = CurrentSchedule.currentLocations![sourceIndexPath.row]
            //            CurrentSchedule.currentLocations!.remove(at: sourceIndexPath.row)
            //            CurrentSchedule.currentLocations!.insert(draggedItem, at: destinationIndexPath.row)
            
            // 在动画中更新 tableView
            tableView.performBatchUpdates({
                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            }, completion: nil)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        // Allow dropping anywhere in the table view
        let isSectionDraggable = destinationIndexPath != nil
        return UITableViewDropProposal(operation: isSectionDraggable ? .move : .forbidden, intent: .insertAtDestinationIndexPath)
    }
    // MARK: Drag -
    
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
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//        }
//    }
    
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//        tableView.reloadData()
//    }
    // MARK: TableView -
}

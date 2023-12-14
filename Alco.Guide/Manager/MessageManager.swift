//
//  MessageManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/9.
//

import Foundation
import FirebaseFirestore

protocol MessageManagerDelegate: AnyObject {
    func messageManager(_ manager: MessageManager, didAddNewMessage message: ChatMessage)
}

class MessageManager {
    
    static let shared = MessageManager()
    
    weak var delegate: MessageManagerDelegate?
    
    private let database = Firestore.firestore()
    
    var chatMessages = [[ChatMessage]]()
    
    var chatMessagesFromServer = [ChatMessage]()
    
    private init() {}
    
    //    func fetchMessage(scheduleId: String) {
    //        // 参考 "Messages" 集合中 "message" 子集合的路径
    //        let messagesCollectionRef = database.collection("Messages").document(scheduleId).collection("message")
    //
    //        chatMessages.removeAll()
    //        chatMessagesFromServer.removeAll()
    //        messagesCollectionRef.getDocuments { (querySnapshot, error) in
    //            if let error = error {
    //                print("Error fetching documents: \(error)")
    //            } else {
    //
    //                for document in querySnapshot!.documents {
    //
    //                    let content = document["content"] as? String ?? ""
    //                    let userName = document["userName"] as? String ?? ""
    //                    let userUID = document["userUID"] as? String ?? ""
    //                    guard let image = document["userImage"] as? String else { return }
    //                    let userImage = URL(string: image)!
    //                    let time = document["time"] as? Timestamp
    //
    //                    let chatMessage = ChatMessage(content: content, userName: userName, userUID: userUID, userImage: userImage, time: time?.dateValue() ?? Date())
    //
    //
    //
    //                    self.chatMessagesFromServer.append(chatMessage)
    //                    print(self.chatMessagesFromServer)
    //
    //                }
    //
    //                self.attemptToAssembleGroupedMessages()
    //            }
    //        }
    //    }
    
    func sendMessage(newMessage: ChatMessage) {
        
        let data: [String: Any] = [
            "content": newMessage.content,
            "userName": newMessage.userName,
            "userUID": newMessage.userUID,
            "userImage": "\(newMessage.userImage)",
            "time": newMessage.time
        ]
        
        let messagesCollectionRef = database.collection("Messages").document(DataManager.CurrentSchedule.currentScheduleID!).collection("message")
        
        messagesCollectionRef.addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Content added success")
            }
        }
    }
    
    func messagesObserver() {
        
        
        let messagesCollectionRef = database.collection("Messages").document(DataManager.CurrentSchedule.currentScheduleID!).collection("message")
            .order(by: "time", descending: true)
        
        chatMessages.removeAll()
        chatMessagesFromServer.removeAll()
        messagesCollectionRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }

            self.chatMessagesFromServer.removeAll()
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    let documentData = diff.document.data()
                    
                    let content = documentData["content"] as? String ?? ""
                    let userName = documentData["userName"] as? String ?? ""
                    let userUID = documentData["userUID"] as? String ?? ""
                    guard let image = documentData["userImage"] as? String else { return }
                    let userImage = URL(string: image)!
                    let time = documentData["time"] as? Timestamp
                    
                    let chatMessage = ChatMessage(content: content, userName: userName, userUID: userUID, userImage: userImage, time: time?.dateValue() ?? Date())
                    
                    //                       if self.chatMessages.isEmpty {
                    //                           self.chatMessages.append([ChatMessage]())
                    //                       }
                    self.chatMessagesFromServer.append(chatMessage)
                    
                    //                       self.chatMessages[0].insert(chatMessage, at: 0)
                    //
                }
            }
            self.attemptToAssembleGroupedMessages()
            print("@@@@@\(self.chatMessages)!!!!!")
        }
    }
    
    //    fileprivate func attemptToAssembleGroupedMessages() {
    //        let messages = chatMessagesFromServer
    //
    //        let groupedMessages = Dictionary(grouping: messages) { (element) -> Date in
    //            return element.time.reduceToMonthDayYear()
    //        }
    //
    //        let sortedKeys = groupedMessages.keys.sorted()
    //
    //        sortedKeys.forEach { (key) in
    //            var content = groupedMessages[key] ?? []
    //            content.sort { $0.time > $1.time }
    //            chatMessages.insert(content, at: 0)
    //
    //        }
    //    }
    
    fileprivate func attemptToAssembleGroupedMessages() {
        let messages = MessageManager.shared.chatMessagesFromServer
        
        let groupedMessages = Dictionary(grouping: messages) { (element) -> Date in
            return element.time.reduceToMonthDayYear()
            
        }

        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (keys) in
            let content = groupedMessages[keys]
//            chatMessages.append(content ?? [])
            chatMessages.insert(content ?? [], at: 0)
            if content?.isEmpty == false {
                for content in content! {
                    self.delegate?.messageManager(self, didAddNewMessage: content)
                }
            }
        }
    }
}

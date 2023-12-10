//
//  MessageManager.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/9.
//

import Foundation
import FirebaseFirestore


class MessageManager {
 
    static let shared = MessageManager()
    
    private let database = Firestore.firestore()

    var chatMessagesFromServer = [ChatMessage]()
    
    private init() {}
    
    func fetchMessage(scheduleId: String) {
        // 参考 "Messages" 集合中 "message" 子集合的路径
        let messagesCollectionRef = database.collection("Messages").document(scheduleId).collection("message")

       
        chatMessagesFromServer.removeAll()
        messagesCollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
               
                for document in querySnapshot!.documents {
                    
                    let content = document["content"] as? String ?? ""
                    let userName = document["userName"] as? String ?? ""
                    let userUID = document["userUID"] as? String ?? ""
                    guard let image = document["userImage"] as? String else { return }
                    let userImage = URL(string: image)!
                    let time = document["time"] as? Timestamp 
                    
                    var chatMessage = ChatMessage(content: content, userName: userName, userUID: userUID, userImage: userImage, time: time?.dateValue() ?? Date())
                    
                   
                    
                    self.chatMessagesFromServer.append(chatMessage)
                    print(self.chatMessagesFromServer)
                    
                }
        
            }
        }
    }
    
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
}

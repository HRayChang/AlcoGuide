//
//  MessageModel.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/10.
//

import Foundation

struct ChatMessage {
    var content: String
    var userName: String
    var userUID: String
    var userImage: URL
    var time: Date
}

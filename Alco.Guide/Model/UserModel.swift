//
//  UserModel.swift
//  Alco.Guide
//
//  Created by Ray Chang on 2023/12/6.
//

import Foundation

struct User: Codable {
    var userUID: String
    var email: String
    var familyName: String
    var givenName: String
    var name: String
    var image: URL

}

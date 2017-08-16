//
//  Profile.swift
//  TableViewExpandableCell
//
//  Created by Manoj pratap singh rana on 15/08/17.
//  Copyright © 2017 self.learning. All rights reserved.
//

import Foundation
struct Profile : Codable {
    var fullName: String?
    var pictureUrl: String?
    var email: String?
    var about: String?
    var friends = [Friend]()
    var profileAttributes = [Attribute]()
    
    init?(data: Data) {
        do {
            let decoder = JSONDecoder()
            self = try decoder.decode(Profile.self, from: data)
        } catch {
            print("Error in JSON deserialization \(error)")
            return nil
        }
    }
}


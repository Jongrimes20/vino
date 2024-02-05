//
//  User.swift
//  vino
//
//  Created by Jon Grimes on 12/21/23.
//

import Foundation
import SwiftUI
import UIKit
import CoreData

/**
 User class:
 - imports uikit to use image type
 
 Class vars:
 - Fname: First name
 - Lname: Last name
 - username: what they are visible to others as (will be used in later version)
 - password: 8 char min. req. Upper case letter, lower case letter, and number (will be encrypted in cloudkit data base)
 - email: for contact purposes (will be used in later version)
 - pfp: profile picture
 - wines: wines they have in their list
 */

public class UserObj {
    var id: UUID
    var Fname: String
    var Lname: String
    var username: String
    var password: String
    var email: String
    var pfp: UIImage
    var wines: [Wine]
    var recordID: String
    
    init(Fname: String, Lname: String, username: String, password: String, email: String, pfp: UIImage, wines: [Wine], recordID: String = "", id: UUID) {
        self.Fname = Fname
        self.Lname = Lname
        self.username = username
        self.password = password
        self.email = email
        self.pfp = pfp
        self.wines = wines
        self.recordID = recordID
        self.id = id
    }
    
    init() {
        self.Fname = ""
        self.Lname = ""
        self.username = ""
        self.password = ""
        self.email = ""
        self.pfp = UIImage()
        self.wines = []
        self.recordID = ""
        self.id = UUID()
    }
    
}

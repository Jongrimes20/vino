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
import CloudKit

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

//MARK: Implement Notes
public class UserObj: ObservableObject {
    var Fname: String
    var Lname: String
    var username: String
    var password: String
    var email: String
    var phoneNumber: String
    var pfp: UIImage
    var wines: [Wine]
    var wineNotes: [String]
    var cloudID: String
    var recordID: CKRecord.ID
    
    init(Fname: String, Lname: String, username: String, password: String, email: String, phoneNumber: String, pfp: UIImage, wines: [Wine], wineNotes: [String], cloudID: String = "") {
        self.Fname = Fname
        self.Lname = Lname
        self.username = username
        self.password = password
        self.email = email
        self.phoneNumber = phoneNumber
        self.pfp = pfp
        self.wines = wines
        self.wineNotes = wineNotes
        self.cloudID = cloudID
        self.recordID = CKRecord(recordType: "AccountInfo").recordID
    }
    
    init() {
        self.Fname = ""
        self.Lname = ""
        self.username = ""
        self.password = ""
        self.email = ""
        self.phoneNumber = ""
        self.pfp = UIImage()
        self.wines = []
        self.wineNotes = []
        self.cloudID = ""
        self.recordID = CKRecord(recordType: "AccountInfo").recordID
    }
    
    /**
     Creating UserObj from CK Record
     */
    init (ckrecord: CKRecord) async throws {
        self.Fname = ckrecord["FName"] as! String
        self.Lname = ckrecord["LName"] as! String
        self.username = ckrecord["Username"] as! String
        self.password = ckrecord["Password"] as! String
        self.email = ckrecord["Email"] as! String
        self.phoneNumber = ckrecord["PhoneNumber"] as! String
        self.cloudID = ckrecord.recordID.recordName
        self.recordID = ckrecord.recordID
        self.wineNotes = ckrecord["PersonalNotes"] as! [String]
        //convert CKAsset to UIImage for pfp
        let imageAsset = ckrecord["PFP"] as! CKAsset
        var imageData = Data()
        do {
            imageData = try Data(contentsOf: imageAsset.fileURL!)
        }
        catch {
            print(error)
        }
        self.pfp = UIImage(data: imageData)!
        //convert list of references to array of wines
        //REFERENCE(List) in CloudDB stores a list of CKRecord.recordName's
        //Get the list of refrences as an array of strings
        //MARK: Figure out querying a reference
        let wineRefs = ckrecord["Wines"] as! [CKRecord.Reference]
        self.wines = []
        let cloudDB = CKContainer.default().publicCloudDatabase
        Task {
            do {
                //For each wine refrenced query them and create a 'Wine' object out of the refrence
                for wine in wineRefs {
                    let fetchedRecord = try await cloudDB.record(for: wine.recordID)
                    // Handle the fetched record
                    self.wines.append(try await Wine(fetchedRecord))
                }
                
            } catch {
                print("Error fetching record: \(error.localizedDescription)")
            }
        }
    }
    
    public func isEmpty() -> Bool {
        //Add checking about if wines is empty and pfp
        if (self.Fname == "" && self.Lname == "" && self.username == "" && self.password == "" && self.email == "" && self.phoneNumber == "") {return true} else {return false}
    }
}

//MARK: user credentials struct
//used to help when querying public record using the private record
struct userCredential {
    var username: String
    var password: String
    
    init(ckrecord: CKRecord) {
        self.username = ckrecord["Username"] as! String
        self.password = ckrecord["Password"] as! String
    }
}

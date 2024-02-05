//
//  Vineyard.swift
//  vino
//
//  Created by Jon Grimes on 12/19/23.
//

import Foundation
import CloudKit
import CoreLocation

/**
 Vineyard class
 class vars:
 - name: String
 - Location: String tuple (country, region) ; for US region is state
 - URL
 */
//MARK: figure out URL redirect
struct Vineyard: Identifiable, Hashable {
    
    var name: String
    var location: CLLocation
    var url: String
    var cloudID: String
    var recordID: CKRecord.ID
    let id: UUID = UUID()
    
    init(_ name: String,_ location: CLLocation,_ url: String = "",_ cloudID: String = "",_ recordID: CKRecord.ID = CKRecord(recordType: "Vineyard").recordID) {
        self.name = name
        self.location = location
        self.url = url
        self.cloudID = cloudID
        self.recordID = recordID
    }
    
    init(_ ckrecord: CKRecord) {
        self.name = ckrecord["VineyardName"] as! String
        self.url = ckrecord["URL"] as! String
        self.location = ckrecord["Location"] as! CLLocation
        self.cloudID = ckrecord.recordID.recordName
        self.recordID = ckrecord.recordID
    }
    
    init () {
        self.name = ""
        self.url = ""
        self.location = CLLocation()
        self.cloudID = ""
        self.recordID = CKRecord(recordType: "Vineyard").recordID
    }
}

public func makeNegavtive(_ double: Double) -> Double {
    return -double
}

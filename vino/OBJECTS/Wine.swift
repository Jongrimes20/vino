//
//  Wine.swift
//  vino
//
//  Created by Jon Grimes on 12/19/23.
//

import Foundation
import CloudKit
import UIKit

/**
 wine class
 class vars
 - type: String
 - vintage: String
 - vineyard: Vineyard object
 */
//MARK: Implement photos of the wines
struct Wine: Identifiable, Hashable {
    
    var type: String
    var vintage: String
    var vineyard: Vineyard
    var images: [UIImage]
    var descriptiveTerms: [String]
    var cloudID: String
    var recordID: CKRecord.ID
    let id: UUID = UUID()//to make wine conform to identifiable
    
    init(_ type: String,_ vintage: String,_ vineyard: Vineyard,_ images: [UIImage] = [],_ descriptiveTerms: [String] = [], _ cloudID: String = "",_ recordID: CKRecord.ID = CKRecord(recordType: "Wine").recordID) {
        self.type = type
        self.vintage = vintage
        self.vineyard = vineyard
        self.images = images
        self.descriptiveTerms = descriptiveTerms
        self.cloudID = cloudID
        self.recordID = recordID
    }
    
    init() {
        self.type = ""
        self.vintage = ""
        self.vineyard = Vineyard()
        self.images = []
        self.descriptiveTerms = []
        let record = CKRecord(recordType: "Wine")
        self.cloudID = record.recordID.recordName
        self.recordID = record.recordID
    }
    
    init(_ ckrecord: CKRecord) async throws {
        self.type = ckrecord["Type"] as! String
        self.vintage = ckrecord["Vintage"] as! String
        self.cloudID = ckrecord.recordID.recordName
        self.recordID = ckrecord.recordID
        self.descriptiveTerms = ckrecord["DescriptiveTerms"] as! [String]
        
        //Process Photos
        let imageAssets = ckrecord["Pictures"] as! [CKAsset]
        var uiImages: [UIImage] = []
        var imageData = Data()
        for asset in imageAssets {
            do {
                imageData = try Data(contentsOf: asset.fileURL!)
                uiImages.append(UIImage(data: imageData)!)
            }
            catch {
                print(error)
            }
        }
        self.images = uiImages
        
        //create vineyard from record
        //set as empty in order to use self in async
        self.vineyard = Vineyard()
        if let fetchedRecord = await getRecord(ckrecord) {
            self.vineyard = Vineyard(fetchedRecord)
        }
    }
    
    func getRecord(_ ckrecord: CKRecord) async -> CKRecord? {
            let vineyardRef = ckrecord["Vineyard"] as! CKRecord.Reference
            let cloudDB = CKContainer.default().publicCloudDatabase
            let fetchedRecord = Task { () -> CKRecord in
                do {
                    return try await cloudDB.record(for: vineyardRef.recordID)
                } catch {
                    print("Error fetching record: \(error)")
                }
                throw CKError(.badContainer)
            }
            let result = await fetchedRecord.result
            do {
                 return try result.get()
             } catch {
                 print("Unable to fetch the record \(error)")
             }
            return nil
        }
}

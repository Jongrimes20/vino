//
//  Pairing.swift
//  vino
//
//  Created by Jon Grimes on 1/29/24.
//

import Foundation
import CloudKit
import UIKit

struct Pairing: Identifiable, Hashable {
    var title: String
    var descriptiveTerms: [String]
    var pairedTerms: [String]
    var specificWines: [String]
    var images: [UIImage]
    var recipe: String
    var cloudID: String
    var recordID: CKRecord.ID
    let id = UUID()
    
    init(title: String, descriptiveTerms: [String], pairedTerms: [String], specificWines: [String], images: [UIImage], recipe: String, cloudID: String, recordID: CKRecord.ID) {
        self.title = title
        self.descriptiveTerms = descriptiveTerms
        self.pairedTerms = pairedTerms
        self.specificWines = specificWines
        self.images = images
        self.recipe = recipe
        self.cloudID = cloudID
        self.recordID = recordID
    }
    
    init(_ ckrecord: CKRecord) {
        self.title = ckrecord["Title"] as! String
        self.descriptiveTerms = ckrecord["DescriptiveTerms"] as! [String]
        self.pairedTerms = ckrecord["PairedTerms"] as! [String]
        self.specificWines = ckrecord["SpecificWines"] as! [String]
        self.recipe = ckrecord["Recipe"] as! String
        self.cloudID = ckrecord.recordID.recordName
        self.recordID = ckrecord.recordID
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
    }
}

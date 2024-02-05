//
//  NewVineyardView.swift
//  vino
//
//  Created by Jon Grimes on 1/5/24.
//

import SwiftUI
import MapKit
import CloudKit

struct NewVineyardView: View {
    @EnvironmentObject var model: Model
    @State var vineyardName = ""
    @State var newVineyard: Vineyard = Vineyard()
    
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        //Need a way to pass new Vineyard object from serach result back to 'NewWineView'
        ZStack {
            SearchableMap(newVineyard: $newVineyard)
                .onDisappear(perform: { //MARK: Find better way to add vineyard
                    //set cloudID and add to database (also adds to local data model)
                    newVineyard.recordID = addNewVineyard(newVineyard)
                    newVineyard.cloudID = newVineyard.recordID.recordName
                    
                    //MARK: how to set the picker to the new vineyard upon dismissal
                })
        }
        //How to have title and back button and hide background
        .navigationTitle("New Vineyard")
        .navigationBarTitleDisplayMode(.inline)
        //Dismiss button
        .overlay(alignment: .topLeading) {
            Button("Dismiss", action: {
                dismiss()
            })
            .padding(10)
            .background(Color.gray.opacity(0.75))
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 50.0))
            .padding()
        }
    }
    
    //also returns CKRecord.ID to be recordID
    private func addNewVineyard(_ vineyard: Vineyard) -> CKRecord.ID {
        var recordID = CKRecord(recordType: "Vineyard").recordID
        
        let cloudDB = CKContainer.default().publicCloudDatabase
        let recordToAdd = CKRecord(recordType: "Vineyard")
        //set record values
        recordToAdd.setValuesForKeys([
            "VineyardName": vineyard.name,
            "Location": vineyard.location,
            "URL": vineyard.url
        ])
        
        //save record
        cloudDB.save(recordToAdd) { record, error in
            //handle error
            if let error = error {
                print(error)
                return
            }
            if record != nil {
                // add to local data model
                model.vineyards.append(newVineyard)
                recordID = (record?.recordID)!
            }
        }
        return recordID
    }
}

//#Preview {
//    NewVineyardView()
//}

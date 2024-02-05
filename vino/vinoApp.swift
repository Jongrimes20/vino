//
//  vinoApp.swift
//  vino
//
//  Created by Jon Grimes on 12/21/23.
//

import SwiftUI
import CloudKit

@main
struct vinoApp: App {
    @StateObject var model = Model()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model) //need to use enviroment object throughout app to make sure we're using the same instance of the model
                .onAppear(perform: {
                    Task {
                        do{
                            //if this function fails the login in / sign up page flow will be presented
                            try await loadActiveUser()
                        }
                        catch {
                            print("Error: \(error)")
                        }
                    }
                })
        }
    }
    
    private func loadActiveUser() async throws {
        let record = try await queryUserRecord()
        if record != [] {
            //this line works
            model.activeUser = try await UserObj(ckrecord: record[0])
            model.userDoesntExist = false
        }
        else { model.activeUser = UserObj() }
    }
    
    /**
     Queries Account Info from private 'AccountInformation' Record Zone
     
     What does this mean?: Passing argument of non-sendable type 'NSPredicate' outside of main actor-isolated context may introduce data races
     */
    private func queryUserRecord() async throws -> [CKRecord] {
        let cloudDB = CKContainer.default().publicCloudDatabase
        let device = UIDevice.current.identifierForVendor
        
        //set pred
        let pred = NSPredicate(format: "LastKnownDevice == %@", device!.uuidString)
        let query = CKQuery(recordType: "AccountInfo", predicate: pred)
        //query public record
        let (userResults, _) = try await cloudDB.records(matching: query)
        //return the public CKRecord of the user
        return userResults.compactMap { _, result in
            guard let record = try? result.get() else { return nil }
            return record
        }
    }
}


//
//  ContentView.swift
//  vino
//
//  Created by Jon Grimes on 12/21/23.
//

import SwiftUI
import CoreData
import CloudKit

//MARK: Add loading view for while the async funcs run
struct ContentView: View {
    //State vars
    //using Observed Object to reflect changes in data
    @EnvironmentObject var model: Model
    
    /**
     when app is opened we must evaluate if a user exists
     if user exists : model.userDoesntExits = false
     else : model.userDoesntExits = true
     */
    var body: some View {
        VinoMainView()
            .environmentObject(model)
            .onAppear(perform: {
                Task {
                    do {
                        model.vineyards = try await loadVineyards()
                        model.pairings = try await loadPairings()
                    } catch {
                        print("Error: \(error)")
                    }
                }
            })
            .fullScreenCover(isPresented: $model.userDoesntExist, content: {
                NavigationStack {
                    ZStack {
                        LoginForm()
                            .environmentObject(model)
                        NavigationLink(
                            "Dont Have an Account? Sign-Up Here",
                            destination: SignUpView(
                                userNotSignedin: $model.userDoesntExist
                            )
                        )
                            .font(.custom("DMSerifDisplay-Regular", size: 15))
                            .padding([.top], 300)
                        //Add loading view here?
                    }
                }
            })
        }
    /**
     check if user exists in privateDB zone
     -also sets active user to the user found
     */
    func checkIfUserDoesntExists() -> Bool {
        //if the array of CKRecords returned by 'queryUserRecords()' is not empty -> userDoesntExist = false
        if model.activeUser.isEmpty() {
            //create UserObj from record[0] because the private account zone queried from should only have one record
            //MARK: need to reload views
            return true
        }
        else { return false }
    }
    
    /**
     Load all Vineyards
     */
    func loadVineyards() async throws -> [Vineyard] {
        let cloudDB = CKContainer.default().publicCloudDatabase
        let pred = NSPredicate(value: true)// return all
        let query = CKQuery(recordType: "Vineyard", predicate: pred)
        
        let (vineyardResults, _) = try await cloudDB.records(matching: query)
        
        return vineyardResults.compactMap { _, result in
            guard let record = try? result.get(),
                  let vineyard = Vineyard(record) as? Vineyard else {return nil}
            return vineyard
        }
    }
    
    func loadPairings() async throws -> [Pairing] {
        let cloudDB = CKContainer.default().publicCloudDatabase
        let pred = NSPredicate(value: true)// return all
        let query = CKQuery(recordType: "Pairing", predicate: pred)
        
        let (pairingResults, _) = try await cloudDB.records(matching: query)
        
        return pairingResults.compactMap { _, result in
            guard let record = try? result.get(),
                  let pairing = Pairing(record) as? Pairing else {return nil}
            return pairing
        }
    }
}


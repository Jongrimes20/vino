//
//  LoginForm.swift
//  vino
//
//  Created by Jon Grimes on 12/20/23.
//

import SwiftUI
import CloudKit

//MARK: NEEED TO IMPLEMENT LOGIC
struct LoginForm: View {
    @EnvironmentObject var model : Model
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errMsg: String = ""
    
    
    //dismiss page function
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                //background image
                Image("ferrari_carano_gardens_original")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                //glass effect
                Color.white.opacity(0.75)
                    .frame(width: 300, height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.9), radius: 10, x: 0, y: 10)
                VStack {
                    Text("Bentornati al vino!")
                        .font(.custom("DMSerifDisplay-Regular", size: 30))
                    //username line
                    HStack {
                        Text("Username")
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                        TextField("username", text: $username)
                            .multilineTextAlignment(.trailing)
                    }
                    .frame(width: 275)
                    .padding()
                    //password line
                    HStack {
                        Text("Password")
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                        TextField("password", text: $password)
                            .multilineTextAlignment(.trailing)
                        
                    }
                    .frame(width: 275)
                    .padding()
                    
                    //MARK: Figure out correct way to pass binding var from signup view to ContentView
                    //to signup page
//                    NavigationLink("Dont Have an Account? Sign-Up Here", destination: SignUpView())
//                        .font(.custom("DMSerifDisplay-Regular", size: 15))
//                        .padding()
                    
                    //Login button
                    Button("Log In", action: {
                        Task {
                            do {
                                try await loginCustomer()
                                dismiss()
                            }
                            catch {
                                //present error message
                                print("ERROR: \(error)")
                            }
                        }
                        
                    })
                        .font(.custom("DMSerifDisplay-Regular", size: 15))
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            // alert
        }
    }
    /**
     login customer function
     */
    private func loginCustomer() async throws {
        //add error handling for index out of range
        let retrievedUser = try await getUserRecord()[0] //this gets the correct user
        let user = try await UserObj(ckrecord: retrievedUser)
        model.activeUser = user //doesn't query wines?
    }
    
    private func getUserRecord() async throws -> [CKRecord] {
        let cloudDB = CKContainer.default().publicCloudDatabase
        let pred = NSPredicate(format: "Username == %@ AND Password == %@", username, password)
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

//#Preview {
//    LoginForm()
//}

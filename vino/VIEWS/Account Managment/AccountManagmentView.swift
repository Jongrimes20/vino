//
//  AccountManagmentView.swift
//  vino
//
//  Created by Jon Grimes on 2/5/24.
//

import SwiftUI
import CloudKit
import CoreLocation

/**
 Need to edit these
 
 var Fname: String
 var Lname: String
 var username: String
 var password: String
 var email: String
 var phoneNumber: String
 var pfp: UIImage
 */

struct AccountManagmentView: View {
    @EnvironmentObject var model: Model
    
    //State vars
    @State var pfp: UIImage = UIImage()
    @State var Fname = ""
    @State var fName: String = ""
    @State var Lname = ""
    @State var lName: String = ""
    @State var username = ""
    @State var uName: String = ""
    //for password verification
    @State var password = ""
    @State var pwrd: String = ""
    @State var verifiedPassword = ""
    
    @State var Email = ""
    @State var email: String = ""
    @State var phoneNumber = ""
    @State var phone: String = ""
    @State var errMsg = ""
    @State var changeMsg = ""
    
    @State var infoChanged: Bool = false
    
    var body: some View {
        VStack {
            //PFP
            //Launch image picker from here to select new pfp
            Image(uiImage: pfp)
                .resizable()
                .frame(width: 100,height: 100)
                .clipShape(Circle())
            Text("@\(username)")
            
            //First name
            HStack {
                Text("First Name")
                    .font(.custom("DMSerifDisplay-Regular", size: 25))
                TextField("Jon", text: $Fname)
                    .multilineTextAlignment(.trailing)
                    .submitLabel(.next)
            }
            .frame(width: 325)
            
            //Last name
            HStack {
                Text("Last Name")
                    .font(.custom("DMSerifDisplay-Regular", size: 25))
                TextField("Doe", text: $Lname)
                    .multilineTextAlignment(.trailing)
                    .submitLabel(.next)
            }
            .frame(width: 325)
            
            //Username
            HStack {
                Text("Username")
                    .font(.custom("DMSerifDisplay-Regular", size: 25))
                TextField("required", text: $username)
                    .multilineTextAlignment(.trailing)
                    .submitLabel(.next)
            }
            .frame(width: 325)
            
            //Password
            VStack {
                HStack {
                    Text("Password")
                        .font(.custom("DMSerifDisplay-Regular", size: 25))
                    TextField("required", text: $password)
                        .multilineTextAlignment(.trailing)
                        .submitLabel(.next)
                }
                .frame(width: 325)
                Text("8 character minimum, must include an uppercase letter, a lowercase letter, and a number.")
                    .font(.system(size: 10))
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .frame(width: 275)
            }
            
            //Email
            HStack {
                Text("E-mail")
                    .font(.custom("DMSerifDisplay-Regular", size: 25))
                TextField("required", text: $Email)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
            }
            .frame(width: 325)
            
            //Phone Number
            //Add formatting later
            HStack {
                Text("Phone")
                    .font(.custom("DMSerifDisplay-Regular", size: 25))
                TextField("required", text: $phoneNumber)
                    .multilineTextAlignment(.trailing)
                    .submitLabel(.done)
                    
            }
            .frame(width: 325)
            
            //Submit Changes
            Button(action: {
                deleteAccount()
            }, label: {
                Text("Submit Changes")
                    
            })
            .padding(.top, 100)
            
            //Delete Account
            Button(action: {
                deleteAccount()
            }, label: {
                Text("Delete Account")
                    .foregroundStyle(Color.red)
            })
            .padding(.top, 100)
            
            Spacer()
            
        }
        .onAppear {
            pfp = model.activeUser.pfp
            Fname = model.activeUser.Fname
            fName = Fname
            Lname = model.activeUser.Lname
            lName = Lname
            username = model.activeUser.username
            uName = username
            password = model.activeUser.password
            pwrd = password
            Email = model.activeUser.email
            email = Email
            phoneNumber = model.activeUser.password
            phone = phoneNumber
        }
        .alert(isPresented: $infoChanged) {
            Alert(
                title: Text("ITEMS BEING CHANGED"),
                message: Text(changeMsg)
            )
        }
    }
    
    //MARK: Update Info Function
    private func updateAccount() {
        //Check What has been changed
        if (Fname != fName) {
            changeMsg += "First Name\n"
            infoChanged = true
        }
        if (Lname != lName) {
            changeMsg += "Last Name\n"
            infoChanged = true
        }
        if (username != uName) {
            changeMsg += "Username\n"
            infoChanged = true
        }
        if (password != pwrd) {
            changeMsg += "Password\n"
            infoChanged = true
        }
        if (Email != email) {
            changeMsg += "Email\n"
            infoChanged = true
        }
        if (phoneNumber != phone) {
            changeMsg += "Phone Number\n"
            infoChanged = true
        }
        // Update Record 
        if infoChanged {
            //update model.active user
            
            let cloudDB = CKContainer.default().publicCloudDatabase
            let userRecord = CKRecord(recordType: "AccountInfo", recordID: model.activeUser.recordID)
            
            userRecord.setValuesForKeys([
                "FName": Fname,
                "LName": Lname,
                "Username": username,
                "Password": password,
                "Email": Email,
                "PhoneNumber": phoneNumber,
                "PFP": pfp,
            ])
            
            let updateUser = CKModifyRecordsOperation(recordsToSave: [userRecord])
            updateUser.savePolicy = .changedKeys
            
            //save changes to users wine list
            cloudDB.add(updateUser)
        }
    }
    
    //MARK: Delete Account Function
    private func deleteAccount() {
        
    }
}

struct AccountManagmentView_Previews: PreviewProvider {
    static var previews: some View {
        AccountManagmentView()
            .environmentObject(Model())
    }
}


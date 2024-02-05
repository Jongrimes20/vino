//
//  SignUpView.swift
//  vino
//
//  Created by Jon Grimes on 12/20/23.
//

import SwiftUI
import CloudKit

//MARK: TO-DO NOTES:
/**
 1.) Make sure glass for stays centered when keyboard appears
 2.) How to dismiss keyboard?
 */

/**
 User class vars:
 - Fname: First name
 - Lname: Last name
 - username: what they are visible to others as (will be used in later version)
 - password: 8 char min. req. Upper case letter, lower case letter, and number (will be encrypted in cloudkit data base)
 - email: for contact purposes (will be used in later version)
 - pfp: profile picture
 - wines: wines they have in their list
 */
struct SignUpView: View {
    //ActiveUser
    @StateObject var model = Model()
    
    //For focusing on textField + keyboard dismissal
    enum Field {
        case firstName
        case lastName
        case username
        case password
        case verifyPassword
        case email
        case phoneNumber
    }
    @FocusState private var focusedField: Field?
    
    //State vars
    @State var Fname = ""
    @State var Lname = ""
    @State var username = ""
    //for password verification
    @State var password = ""
    @State var verifiedPassword = ""
    
    @State var email = ""
    @State var phoneNumber = ""
    @State var errMsg = ""
    @State var showErrMsg = false
    //for pfp
    @State var showPfpAlert = false
    @State var changePfp = false
    @State var openCameraRoll = false
    @State var openCamera = false
    @State var pfp = UIImage()
    
    //Binding Var to dismiss this view once user is created
    @Binding var userNotSignedin: Bool
    
    var body: some View {
        ZStack {
            //background image
            Image("ferrari_carano_gardens_original")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            //glass effect
            Color.white.opacity(0.75)
                .frame(width: 300, height: 700)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color.black.opacity(0.9), radius: 10, x: 0, y: 10)
            
            VStack {
                Text("Benvenuti a Vino!")
                    .font(.custom("DMSerifDisplay-Regular", size: 30))
                    .padding(.bottom)
                
                Group {
                    //First name
                    HStack {
                        Text("First Name")
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                        TextField("Jon", text: $Fname)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .firstName)
                            .submitLabel(.next)
                    }
                    .frame(width: 275)
                    
                    //Last name
                    HStack {
                        Text("Last Name")
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                        TextField("Doe", text: $Lname)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .lastName)
                            .submitLabel(.next)
                    }
                    .frame(width: 275)
                    
                    //Username
                    HStack {
                        Text("Username")
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                        TextField("required", text: $username)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .username)
                            .submitLabel(.next)
                    }
                    .frame(width: 275)
                    
                    //Password
                    VStack {
                        HStack {
                            Text("Password")
                                .font(.custom("DMSerifDisplay-Regular", size: 20))
                            TextField("required", text: $password)
                                .multilineTextAlignment(.trailing)
                                .focused($focusedField, equals: .password)
                                .submitLabel(.next)
                        }
                        .frame(width: 275)
                        HStack {
                            Text("Verify Password")
                                .font(.custom("DMSerifDisplay-Regular", size: 20))
                            TextField("required", text: $verifiedPassword)
                                .multilineTextAlignment(.trailing)
                                .focused($focusedField, equals: .verifyPassword)
                                .submitLabel(.next)
                            
                        }
                        .frame(width: 275)
                        Text("8 character minimum, must include an uppercase letter, a lowercase letter, and a number.")
                            .font(.system(size: 10))
                            .lineLimit(3)
                            .multilineTextAlignment(.center)
                            .frame(width: 275)
                    }
                    
                    //Email
                    HStack {
                        Text("E-mail")
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                        TextField("required", text: $email)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .email)
                            .keyboardType(.emailAddress)
                            .submitLabel(.next)
                    }
                    .frame(width: 275)
                    
                    //Phone Number
                    //Add formatting later
                    HStack {
                        Text("Phone Number")
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                        TextField("required", text: $phoneNumber)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .phoneNumber)
                            .submitLabel(.done)
                            
                    }
                    .frame(width: 275)
                }
                //to move focus / dismiss keyboard when no longer needed
                .onSubmit {
                    switch focusedField {
                    case .firstName:
                        focusedField = .lastName
                    case .lastName:
                        focusedField = .username
                    case .username:
                        focusedField = .password
                    case .password:
                        focusedField = .verifyPassword
                    case .verifyPassword:
                        focusedField = .email
                    case .email:
                        focusedField = .phoneNumber
                        //phoneNUmber doesn't need a case because it's submit button should dismiss keyboard
                    default:
                        print("Form Completed")
                    }
                }
                    
                    //PFP
                    VStack {
                        Text("Profile Picture")
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                            .padding(.top)
                        Text("(optional)")
                            .font(.system(size: 10))
                        /**
                         when clicked pops up alert asking if they want to select from:
                         - camera roll: .photoLibrary
                         Or
                         - take a photo: .camera
                         */
                        Button(action: {
                            //present alert
                            showPfpAlert = true
                            changePfp = true
                        }, label: {
                            if changePfp {
                                Image(uiImage: pfp)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                //make this cleaner
                                Image(uiImage: UIImage(systemName: "person.circle.fill")!)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                        })
                        //pop up to select camera or camera roll
                        .alert("Camera or Photo Library", isPresented: $showPfpAlert) {
                            Button("Camera", action: { openCamera = true })
                            Button("Camera Roll", action: { openCameraRoll = true })
                        }
                        
                    }
                    .frame(width: 275)
                    .padding(.bottom)
                    
                    //Login button
                    //Fix this message: Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
                    Button("Sign Up", action: signUpCustomer)
                        .font(.custom("DMSerifDisplay-Regular", size: 20))
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
            }
            //figure out full screen
            //Presents photo library
            .sheet(isPresented: $openCameraRoll, content: {
                //.photoLibrary will be depricated ~ replace with PHPicker soon
                ImagePickerView(selectedImage: $pfp, sourceType: .photoLibrary)
            })
            //presents camera
            .sheet(isPresented: $openCamera, content: {
                //.photoLibrary will be depricated ~ replace with PHPicker soon
                ImagePickerView(selectedImage: $pfp, sourceType: .camera)
            })
            .alert(isPresented: $showErrMsg) {
                Alert(
                    title: Text("ERROR"),
                    message: Text(errMsg)
                )
            }
        }
        
        //MARK: Fix form validation for public release
        func signUpCustomer() {
            //check for all required feilds are filled out
            if (Fname == "") {
                errMsg += "First Name is a required field, please complete the form \n\n"
                showErrMsg = true
            }
            if (Lname == "") {
                errMsg += "Last Name is a required field, please complete the form \n\n"
                showErrMsg = true
            }
            if (username == "") {
                errMsg += "Username is a required field, please complete the form \n\n"
                showErrMsg = true
            }
            if (password == "") {
                errMsg += "Password is a required field, please complete the form \n\n"
                showErrMsg = true
            }
            if (verifiedPassword == "") {
                errMsg += "Verify Password is a required field, please complete the form \n\n"
                showErrMsg = true
            }
            //check if password meets criteria
            if (password.count < 8 || !containsCapital(password) || !containsNumber(password)) {
                errMsg += "Passwords must contain 8 characters including: 1 uppercase letter and 1 number \n\n"
                showErrMsg = true
            }
            // make sure passwords match
            if (verifiedPassword != password) {
                errMsg += "Make sure passwords match \n\n"
                showErrMsg = true
            }
            if (email == "") {
                errMsg += "E-Mail is a required field, please complete the form \n\n"
                showErrMsg = true
            }
            if (!isValid(email: email)) {
                errMsg += "Make sure to enter a valid email address \n\n"
                showErrMsg = true
            }
            if (phoneNumber == "") {
                errMsg += "Phone Number is a required field, please complete the form \n\n"
                showErrMsg = true
            }
            // no errors in the form -> good to create the user
            if (showErrMsg == false) {
                //get device info
                let device = UIDevice.current.identifierForVendor
                
                let newUser = UserObj(
                    Fname: Fname,
                    Lname: Lname,
                    username: username,
                    password: password,
                    email: email,
                    phoneNumber: phoneNumber,
                    pfp: pfp,
                    wines: [],
                    wineNotes: []
                )
                //Define public and priv databases
                let cloudDB = CKContainer.default().publicCloudDatabase
                
                //create user record to be added to the database
                var recordToAdd = CKRecord(recordType: "AccountInfo")
                
                //convert pfp UIImage to CKAsset to add to DB
                let pfpImageData = newUser.pfp.jpegData(compressionQuality: 1.0)
                //fix to provide default
                let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString + ".dat")!
                
                do {
                    //write img data to url
                    try pfpImageData!.write(to: url)
                } catch {
                    print("Error\(error)")
                    return
                }
                
                let pfpImageAsset = CKAsset(fileURL: url)
                
                recordToAdd.setValuesForKeys([
                    "FName": newUser.Fname,
                    "LName": newUser.Lname,
                    "Username": newUser.username,
                    "Password": newUser.password,
                    "Email": newUser.email,
                    "PhoneNumber": newUser.phoneNumber,
                    "PFP": pfpImageAsset,
                    "Wines": newUser.wines,
                    "LastKnownDevice": device!.uuidString
                ])
                
                //add record to database
                cloudDB.save(recordToAdd) { record, error in
                    //check for error
                    if let err = error {
                        print(err)
                        return
                    }
                    // as long as the record is not empty
                    if record != nil {
                        //MARK: set active user to newley created user
                        model.activeUser = newUser
                        //dismiss page and go to homepage
                        model.userDoesntExist = false
                    }
                }
                
            }
            
        }
        
        func isValid(email:String) -> Bool {
            guard !email.isEmpty else { return false }
            let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
            let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
            return emailValidationPredicate.evaluate(with: email)
        }
        
        func containsCapital(_ s: String) -> Bool {
            guard !password.isEmpty else { return false }
            let passwordValidationRegex = ".*[A-Z]+.*"
            let passwordValidationPredicate = NSPredicate(format: "SELF MATCHES %@", passwordValidationRegex)
            return passwordValidationPredicate.evaluate(with: s)
        }
        
        func containsNumber(_ s: String) -> Bool {
            guard !password.isEmpty else { return false }
            let passwordValidationRegex = ".*[0-9]+.*"
            let passwordValidationPredicate = NSPredicate(format: "SELF MATCHES %@", passwordValidationRegex)
            return passwordValidationPredicate.evaluate(with: s)
        }
        
        func containsSpecialChar(_ s: String) -> Bool {
            guard !password.isEmpty else { return false }
            let passwordValidationRegex = ".*[!&^%$#@()/]+.*"
            let passwordValidationPredicate = NSPredicate(format: "SELF MATCHES %@", passwordValidationRegex)
            return passwordValidationPredicate.evaluate(with: s)
        }
    }


//#Preview {
//    SignUpView()
//}

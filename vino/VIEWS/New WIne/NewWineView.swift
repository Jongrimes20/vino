//
//  NewWineView.swift
//  vino
//
//  Created by Jon Grimes on 12/19/23.
//

import SwiftUI
import CloudKit

struct NewWineView: View {
    @EnvironmentObject var model: Model
    @State private var wine: Wine = Wine()
    
    //MARK: state vars
    @State private var errorMessage = ""
    @State private var error = false
    @State private var wineType = ""
    @State private var vineyard: Vineyard = Vineyard()
    @State private var vintage = ""
    @State private var descriptors: Set<String> = []
    @State private var additionalNotes: String = ""
    
    
    @State private var newVineyardViewVisible = false
    @State private var descriptorsViewVisible = false
    
    @State private var showImageAlert = false
    @State private var addImage = false
    @State private var openCameraRoll = false
    @State private var openCamera = false
    @State private var wineImage = UIImage()
    
    //To add wine for real time UI update of MyListView
    @Binding var wines: [Wine]
    @Binding var isVisible: Bool
    
    //For focusing on textField + keyboard dismissal
    enum Field {
        case vintageFocus
        case notesFocus
    }
    @FocusState private var focusedField: Field?
    
    //dismiss page function
    @Environment(\.dismiss) var dismiss
    
    //MARK: body
    var body: some View {
        ScrollView {
            VStack {
                //Dismiss Button
                HStack {
                    Button("Dismiss", action: {
                        isVisible = false
                    })
                    .padding(10)
                    .background(Color.gray.opacity(0.95))
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 50.0))
                    .padding(.leading, 50)
                    
                    Spacer()
                }
                /**
                 - Group 1
                 - Wine Type
                 - Vintage
                 - Vineyard Selection
                 */
                Group {
                    ZStack {
                        //white background
                        Color.white
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .frame(width: 375, height: 300)
                        VStack {
                            //Content
                            HStack {
                                Text("Wine Type")
                                    .font(.custom("Oswald-Bold", size: 20))
                                Spacer()
                                //How to alphabatize this
                                Picker("Wine Type", selection: $wineType) {
                                    ForEach(wineTypes, id: \.self) { wine in
                                        Text(wine)
                                    }
                                }
                            }
                            //Vintage TextField
                            HStack {
                                Text("Vintage")
                                    .font(.custom("Oswald-Bold", size: 20))
                                TextField("YYYY", text: $vintage)
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.trailing, 10)
                            //Picker for vineyard
                            HStack {
                                Text("Vineyard")
                                    .font(.custom("Oswald-Bold", size: 20))
                                Spacer()
                                Picker("Vineyard", selection: $vineyard) {
                                    ForEach(model.vineyards, id: \.self) { vineyard in
                                        Text(vineyard.name)
                                    }
                                }
                            }
                            //new vineyard view
                            Button(action: {
                                newVineyardViewVisible = true
                            }, label: {
                                Text("Don't see the vineyard you're looking for? Click here.")
                                    .font(.custom("Oswald-Bold", size: 15))
                                    .underline()
                            })
                        }
                        .padding([.leading, .trailing],50)
                    }
                }
                .padding([.leading, .trailing],50)
                
                /**
                 -Group 2
                 -Descriptors link
                 */
                Group {
                    ZStack {
                        //white background
                        Color.white
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .frame(width: 375, height: 100)
                        
                        Button(action: {
                            descriptorsViewVisible.toggle()
                        }, label: {
                            HStack{
                                Text("Descriptors")
                                    .font(.custom("Oswald-Bold", size: 20))
                                    .foregroundStyle(Color.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color.gray)
                            }
                        })
                        .padding([.leading, .trailing],100)
                    }
                }
                
                /**
                 -Group 3
                 - Add Photos
                 */
                Group {
                    ZStack {
                        //Background
                        Color.white
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .frame(width: 375, height: 350)
                        //Content
                        VStack {
                            //add photos
                            Text("Add Photos")
                                .font(.custom("Oswald-Bold", size: 20))
                                .padding()
                            HorizontalImageScrollView(images: $wine.images, recordType: "Wine", recordID: wine.recordID)// figure out how to ceneter
                                .frame(width: 300)
                        }
                    }
                }
                /**
                 -Group 4
                 - Additional Notes
                 */
                //notes
                Group {
                    ZStack {
                        //Background
                        Color.white
                            .frame(minWidth: 375, idealWidth: 375, maxWidth: 375, minHeight: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        //Content
                        VStack {
                            Text("Additional Notes:")
                                .font(.custom("Oswald-Bold", size: 30))
                                .padding()
                            TextField("additional notes", text: $additionalNotes, axis: .vertical)
                                .multilineTextAlignment(.center)
                                .frame(width: 300)
                                .padding()
                        }
                    }
                }
                                
                //add wine button
                Button(action: {
                    //create new wine here
                    addNewWine()
                }, label: {
                    Text("Add new wine")
                        .padding()
                        .font(.custom("Oswald-Bold", size: 20))
                        .foregroundStyle(Color.white)
                        .background(Color.blue)
                })
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                .padding()
            }
            .alert(isPresented: $error) {
                Alert(
                    title: Text("ERROR"),
                    message: Text(errorMessage)
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .sheet(isPresented: $newVineyardViewVisible, onDismiss: {
            newVineyardViewVisible = false
        }, content: {
            NewVineyardView()
                .environmentObject(model)
        })
        .sheet(isPresented: $descriptorsViewVisible, onDismiss: {
            print(Array(descriptors))
            descriptorsViewVisible = false
        }, content: {
            WineDescriptorsListView(descriptorArray: $descriptors)
        })
        
        
    }
    
    /**
     - Note: Add error handling for null values
        - only images can be null
     */
    private func addNewWine(){
        //If there is an error set value to display alert
        //check for input errors
        if wineType.isEmpty {
            errorMessage += "Please select a wine type \n"
            error = true
        }
        if vintage.isEmpty {
            errorMessage += "Please enter a vintage year\n"
            error = true
        }
        if vineyard.name.isEmpty {
            errorMessage += "Please select a vineyard"
            error = true
        }
        
        
        if error == false {
            //Add Wine to DB
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            let descriptorsArray = Array(descriptors)
            let newWine = Wine(
                wineType,
                vintage,
                vineyard,
                wine.images,
                descriptorsArray
            )
            
            //convert images to assets
            var imageAssets: [CKAsset] = []
            
            for image in wine.images {
                let imageData = image.jpegData(compressionQuality: 1.0)
                let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")!
                    do {
                        try imageData!.write(to: url)
                    }
                    catch {
                        print("Error \(error)")
                        return
                    }
                let asset = CKAsset(fileURL: url)
                imageAssets.append(asset)
            }
            
            let cloudDB = CKContainer.default().publicCloudDatabase
            let recordToAdd = CKRecord(recordType: "Wine")
            //get Vineyard Record
            recordToAdd.setValuesForKeys([
                "Type": newWine.type,
                "Vintage": newWine.vintage,
                "Vineyard": CKRecord.Reference(recordID: vineyard.recordID, action: .deleteSelf),
                "Pictures": imageAssets,
                "DescriptiveTerms": descriptorsArray as NSArray
            ])
            
            //save record to public DB
            cloudDB.save(recordToAdd) { record, error in
                //handle error
                if let error = error {
                    print(error)
                    return
                }
                if record != nil {
                    return
                }
            }
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            //Add reference to user record
            //Syntaxically correct -> casting as wrong type?
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            var wineRecords: [CKRecord.Reference] = []
            for wine in model.activeUser.wines {
                wineRecords.append(CKRecord.Reference(recordID: wine.recordID, action: .deleteSelf))
            }
            wineRecords.append(CKRecord.Reference(recordID: recordToAdd.recordID, action: .deleteSelf))
            
            model.activeUser.wineNotes.append(additionalNotes)
            
            let userRecord = CKRecord(recordType: "AccountInfo", recordID: model.activeUser.recordID)
            userRecord.setValuesForKeys([
                "Wines": wineRecords,
                "PersonalNotes": model.activeUser.wineNotes as NSArray
            ])
            
            let updateUser = CKModifyRecordsOperation(recordsToSave: [userRecord], recordIDsToDelete: [])
            updateUser.savePolicy = .changedKeys
            cloudDB.add(updateUser)
            
            //add wine object to active user wines array
            wines.append(newWine)
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            
            //dismiss view
            isVisible = false
        }
    }
    
    private func getVineyardFromDB(_ vineyard: Vineyard) async throws -> [Vineyard] {
        let cloudDB = CKContainer.default().publicCloudDatabase
        let pred = NSPredicate(format: "VineyardName == %@", vineyard.name)
        let query = CKQuery(recordType: "Vineyard", predicate: pred)
        
        let (vineyardResult, _) = try await cloudDB.records(matching: query, resultsLimit: 1)
        
        return vineyardResult
                .compactMap { _, result in
                    guard let record = try? result.get(),
                          let vineyard = Vineyard(record) as? Vineyard else {return nil}
                    return vineyard
                }
    }
    
    /**
     Check for nil values in type, vintage, or vineyard
     if any are nil display error alert
     */
   
}



//struct NewWineView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var wine = Wine()
//        WineInfoView(wine: $wine)
//    }
//}

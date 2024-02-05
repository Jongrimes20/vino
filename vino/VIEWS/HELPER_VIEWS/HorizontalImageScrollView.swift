//
//  HorizontalImageScrollView.swift
//  vino
//
//  Created by Jon Grimes on 1/11/24.
//

import SwiftUI
import PhotosUI
import CloudKit

struct HorizontalImageScrollView: View {
    @Binding var images: [UIImage]
    @State var recordType: String
    @State var recordID: CKRecord.ID
 
    //For selecting / adding phtotos
    @State private var photoPickerPresented: Bool = false
    @State private var cameraPresente: Bool = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: UIImage?
    
    var body: some View {
            ScrollView(.horizontal, content: {
                //parse through images that exist
                HStack {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 175, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .padding()
                    }

                    PhotosPicker(selection: $selectedItem, label: {
                        ZStack {
                            Color(uiColor: UIColor(rgb: 0xEDEDE9))
                                .frame(width: 175, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                .padding([.leading,.trailing])
                            Image(systemName: "plus.circle.fill")
                        }
                    })
                    .onChange(of: selectedItem) {
                        Task {
                            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                image = UIImage(data: data)
                                //add image to local object
                                images.append(image!)
                                updateRecordPhotos(images)
                                
                            } else {
                                print("Failed to load the image")
                            }
                        }
                    }
                }
            })
        }
    
    private func updateRecordPhotos(_ images: [UIImage]) {
        let cloudDB = CKContainer.default().publicCloudDatabase
        let recordToUpdate = CKRecord(recordType: recordType, recordID: recordID)
        var imageAssets: [CKAsset] = []
        
        for image in images {
            //convert pfp UIImage to CKAsset to add to DB
            let imageData = image.jpegData(compressionQuality: 1.0)
            //fix to provide default
            let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString + ".dat")!
            
            do {
                //write img data to url
                try imageData!.write(to: url)
            } catch {
                print("Error\(error)")
                return
            }
            
            imageAssets.append(CKAsset(fileURL: url))
        }
        
        recordToUpdate.setValuesForKeys([
            "Pictures": imageAssets
        ])
        
        let updateImages = CKModifyRecordsOperation(recordsToSave: [recordToUpdate])
        updateImages.savePolicy = .changedKeys
        
        //save changes to users wine list
        cloudDB.add(updateImages)
    }
    
    
}


//struct HorizontalImageScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var wine = Wine("Cabernet Sauvignon",
//                               "2018",
//                               Vineyard("Jordan Winery & Vineyard",
//                                        CLLocation(
//                                          latitude: CLLocationDegrees(floatLiteral: 38.6562),
//                                          longitude: CLLocationDegrees(floatLiteral: -122.8438)),
//                                        "https://www.jordanwinery.com/"),
//                               [UIImage(named: "2018-alexander-valley-jordan-cabernet-sauvignon")!]
//                              )
//        HorizontalImageScrollView(images: $wine.images, recordType: "Wine")
//    }
//}

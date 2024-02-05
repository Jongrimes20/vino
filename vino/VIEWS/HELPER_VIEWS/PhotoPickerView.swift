//
//  PhotoPickerView.swift
//  vino
//
//  Created by Jon Grimes on 1/12/24.
//
// For Selecting From Camera Roll

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State var image: UIImage?
    //wine that image is added to
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            //add video support at later date
            PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            image = UIImage(data: data)
                        }
                        print("Failed to load the image")
                    }
                }
                .onSubmit {
                    dismiss()
                }
        }
        .padding()
    }
}

#Preview {
    PhotoPickerView()
}

//
//  WineDescriptorsListView.swift
//  vino
//
//  Created by Jon Grimes on 1/24/24.
//

import SwiftUI

struct WineDescriptorsListView: View {
    @EnvironmentObject var model: Model
    @Binding var descriptorArray: Set<String>
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5.0)
                .frame(width: 30, height: 5)
                .foregroundStyle(Color.gray)
                .padding()
            List {
                ForEach(model.wineDescriptors, id: \.self) { descriptor in
                    HStack {
                        Checkbox(isChecked: descriptorArray.contains(descriptor))
                            .onTapGesture {
                                if self.descriptorArray.contains(descriptor) {
                                    self.descriptorArray.remove(descriptor)
                                } else {
                                    self.descriptorArray.insert(descriptor)
                                }
                            }
                        Text(descriptor)
                            .font(.custom("Oswald-Regular", size: 20))
                    }
                }
            }
        }
    }
}


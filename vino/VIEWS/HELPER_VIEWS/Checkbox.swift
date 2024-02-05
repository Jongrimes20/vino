//
//  Checkbox.swift
//  vino
//
//  Created by Jon Grimes on 1/24/24.
//

import SwiftUI

struct Checkbox: View {
    var isChecked: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .aspectRatio(1.0, contentMode: .fit)
                .foregroundStyle(Color.white)
                .border(Color.black) //need to make thicker
                .frame(width: 30, height: 30)
            if isChecked {
                Image(systemName: "checkmark")
            }
        }
    }
}


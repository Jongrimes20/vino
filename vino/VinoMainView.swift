//
//  VinoMainView.swift
//  vino
//
//  Created by Jon Grimes on 12/22/23.
//

import SwiftUI

struct VinoMainView: View {
    @ObservedObject var model : Model
    
    init(model: Model) {
        self.model = model
    }
    
    var body: some View {
        //Main screen view
        TabView {
            //change this line with the rankings view
            MyListView(model: model)
                .tabItem { Label("My List", systemImage: "wineglass") }
            //change this line with the new wine view
            NewWineView(model: model)
                .tabItem { Label("New Wine", systemImage: "plus.circle.fill") }
        }
    }
}

//#Preview {
//    VinoMainView()
//}

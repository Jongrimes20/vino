//
//  VinoMainView.swift
//  vino
//
//  Created by Jon Grimes on 12/22/23.
//

import SwiftUI

struct VinoMainView: View {
    @EnvironmentObject var model : Model

    var body: some View {
        //Main screen view
        TabView {
            //change this line with the rankings view
            MyListView()
                .environmentObject(model)
                .tabItem { Label("My List", systemImage: "wineglass") }
//            //Make this a button
//            NewWineView(model: model)
//                .tabItem { Label("New Wine", systemImage: "plus.circle.fill") }
            //Pairings
            PairingsView()
                .environmentObject(model)
                .tabItem { Label("Pairings", systemImage: "fork.knife") }
            
            //Account Managment
            AccountManagmentView()
                .environmentObject(model)
                .tabItem { Label("Account", systemImage: "person") }
        }
    }
}

//#Preview {
//    VinoMainView()
//}

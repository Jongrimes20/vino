//
//  MyListView.swift
//  vino
//
//  Created by Jon Grimes on 12/19/23.
//

import SwiftUI
import CoreLocation

struct MyListView: View {
    @EnvironmentObject var model: Model  // <--- here
    @State private var newWineViewVisible: Bool = false
    
    var body: some View {
        //Header
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Text ("vino")
                        .font(.custom("DMSerifDisplay-Regular", size: 24))
                        .padding(.leading, 50)
                    
                    Spacer()
                    //user pfp : on tap -> account managment
                    Button(action: {
                        newWineViewVisible = true
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                    })
                    .frame(width: 40, height: 40)
                    .padding()
                }
                
                /**
                 Wine List
                 - NavLink goes to WineInfoView
                 */
                List {
                    ForEach($model.activeUser.wines.indices, id: \.self) { index in
                        NavigationLink(destination: {
                            WineInfoView(wine: $model.activeUser.wines[index], index: index)
                                .environmentObject(model)
                        }) {
                            WineListView(wine: model.activeUser.wines[index]).frame(height: 100)
                        }
                    }
                }
                
            }
            .overlay{
                if newWineViewVisible {
                    ZStack {
                        //blurred back ground
                        Color.black
                            .opacity(0.5)
                            .ignoresSafeArea()
                        NewWineView(wines: $model.activeUser.wines, isVisible: $newWineViewVisible)
                            .environmentObject(model)
                    }
                }
            }
        }
    }
}

//for preview create dummy model
//#Preview {
//    MyListView()
//}

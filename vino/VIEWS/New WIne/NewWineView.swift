//
//  NewWineView.swift
//  vino
//
//  Created by Jon Grimes on 12/19/23.
//

import SwiftUI

struct NewWineView: View {
    @ObservedObject var model = Model()
    //MARK: state vars
    @State var errorMessage = ""
    @State var wineName = ""
    @State var wineType = ""
    @State var vineyard = ""
    @State var vintage = ""
    @State var vineyardCountry = ""
    @State var vineyardRegion = ""
    @State var vineyardURL = ""
    @State var notes = ""
    
    init(model: Model = Model(), errorMessage: String = "", wineName: String = "", wineType: String = "", vineyard: String = "", vintage: String = "", vineyardCountry: String = "", vineyardRegion: String = "", vineyardURL: String = "", notes: String = "") {
        self.model = model
        self.errorMessage = errorMessage
        self.wineName = wineName
        self.wineType = wineType
        self.vineyard = vineyard
        self.vintage = vintage
        self.vineyardCountry = vineyardCountry
        self.vineyardRegion = vineyardRegion
        self.vineyardURL = vineyardURL
        self.notes = notes
    }
    
    //MARK: body
    var body: some View {
        Form {
            ZStack {
                VStack {
                    Group {
                        //wine type picker
                        HStack {
                            Picker("Wine Type",selection: $wineType) {
                                ForEach(wineTypes, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                        }
                        
                        //wine name textfield
                        HStack {
                            Text("Wine Name")
                                .font(.custom("DMSerifDisplay-Regular", size: 20))
                            TextField("Wine Name", text: $wineName)
                                .multilineTextAlignment(.trailing)
                        }
                       
                        //vintage text field
                        HStack {
                            Text("Vintage")
                                .font(.custom("DMSerifDisplay-Regular", size: 20))
                            TextField("YYYY", text: $vintage)
                                .multilineTextAlignment(.trailing)
                        }
                        
                    }
                    //This will enventually get replaced with a picker but in early stages to gather data users will have to do manual entry
                    Group {
                        //Vineyard name text field
                        HStack {
                            Picker("Vineyard",selection: $vineyard) {
                                ForEach(model.vineyards, id: \.self) {
                                    Text($0.name)
                                }
                            }
                            .pickerStyle(.menu)
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                        }
                        //MARK: Add Picker Here
                        //if vineyard not on the list: press 'Add new Vineyard' Button
                        // -> Display new vineyard view to gather Vineyard name, location coordinates, and url (optional)
                        Button("Don't see the vineyard you're looking for? Tap here to add a new one", action: {
                            //Make new vineyard view visible
                        })
                            .multilineTextAlignment(.center)
                            .font(.custom("Oswald-regular", size: 17))
                            .underline()
                    }
                    Group {
                        //MARK: TO-DO: Add flavor check boxes
                        
                        //Additional notes
                        Text("Notes:")
                            .font(.custom("DMSerifDisplay-Regular", size: 20))
                        TextField("type additonal notes here", text: $notes, axis: .vertical)
                            .padding()
                            .overlay( RoundedRectangle(cornerRadius: 20).stroke(.gray.opacity(0.2)))
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        
                        //add wine button
                        Button("Add New Wine", action: { addNewWine() })
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                //MARK: New Vineyard View
                
            }
        }
        //makes form background hidden
        .scrollContentBackground(.hidden)
    }
    
    private func addNewWine() {
        
    }
}



#Preview {
    NewWineView()
}

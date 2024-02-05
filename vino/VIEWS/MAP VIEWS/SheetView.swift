//
//  SheetView.swift
//  vino
//
//  Created by Jon Grimes on 1/8/24.
//

import SwiftUI
import MapKit

struct SheetView: View {
    // State vars
    @State private var locationService = LocationService(completer: .init())
    @State private var search: String = ""

    // Binding vars
    @Binding var searchResults: [SearchResult]
    @Binding var locationTitle: String
    @Binding var locationUrl: URL
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for a restaurant", text: $search)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            searchResults = (try? await locationService.search(with: search)) ?? []
                        }
                    }
            }
            .modifier(TextFieldGrayBackgroundColor())

            Spacer()

            // search results
            List {
                ForEach(locationService.completions) { completion in
                    Button(action: { didTapOnCompletion(completion) }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(completion.title)
                                .font(.headline)
                                .fontDesign(.rounded)
                            Text(completion.subTitle)
                            //show url if it exists
                            if let url = completion.url {
                                Link(url.absoluteString, destination: url)
                                    .lineLimit(1)
                            }
                        }
                    }
                    // styling
                    .listRowBackground(Color.clear)
                }
            }
            // more styling
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        // update results on new text in text field
        .onChange(of: search) {
            locationService.update(queryFragment: search)
        }
        .padding()
        .interactiveDismissDisabled()
        .presentationDetents([.height(200), .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
    
    private func didTapOnCompletion(_ completion: SearchCompletions) {
        locationTitle = completion.title
        if let url = completion.url {
            locationUrl = url
        }
        Task {
            if let singleLocation = try? await locationService.search(with: "\(completion.title) \(completion.subTitle)").first {
                searchResults = [singleLocation]
            }
        }
    }
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}

//#Preview {
//    SheetView()
//}

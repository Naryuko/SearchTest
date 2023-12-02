//
//  ContentView.swift
//  SearchTest
//
//  Created by Naryu on 12/3/23.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            TextField("search", text: $searchText, prompt: Text("search text"))
            
            List {
                ForEach(viewModel.searchResult, id: \.self) { result in
                    Rectangle().foregroundStyle(Color.black)
                        .overlay {
                            Text(result)
                                .foregroundStyle(Color.white)
                        }
                }
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            viewModel.set(searchText: newValue)
        }
    }
    
}

private class ContentViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var searchResult: [String] = []
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    func set(searchText text: String) {
        searchCompleter.queryFragment = text
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let result = Set<String>(completer.results.compactMap { completion in
            guard let title = completion.title.split(separator: ",").first else { return nil }
            return String(title)
        })
        
        searchResult = Array(result)
    }
    
}

#Preview {
    ContentView()
}

//
//  SearchView.swift
//  MyMovies
//
//  Created by Paul Hudson on 12/05/2021.
//

import Combine
import SwiftUI

struct SearchView: View {
    @State private var searchResults = SearchResults(results: [])
    @State private var request: AnyCancellable?
    
    @StateObject private var search = DebouncedText()
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                            TextField("Search for a movie…", text: $search.text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textCase(.none)
                ) {
                    ForEach(searchResults.results, content: MovieRow.init)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Search")
            .onChange(of: search.debouncedText, perform: runSearch)
        }
    }
    
    func runSearch(criteria: String) {
        request?.cancel()
        
        request = URLSession.shared.get(
            path: "search/movie",
            queryItems: ["query": criteria],
            defaultValue: SearchResults(results: [])
        ) { results in
            searchResults = results
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

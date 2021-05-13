//
//  MovieDetailView.swift
//  MyMovies
//
//  Created by Markus on 12.05.21.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    @EnvironmentObject var dataController: DataController
    
    @State private var details: MovieDetails = MovieDetails(budget: 0, revenue: 0, runtime: 0)
    @State private var credits: Credits = Credits(cast: [], crew: [])
    
    @State private var cancellables = Set<AnyCancellable>()
    
    @State private var showingAllCast = false
    @State private var showingAllCrew = false
    
    @State private var reviews: [Review] = []
    @State private var reviewText = ""
    
    var reviewURL: URL? {
        URL(string:
                "https://www.hackingwithswift.com/samples/ios-accelerator/\(movie.id)")
    }
    
    var displayedCast: [CastMember] {
        if showingAllCast {
            return credits.cast
        } else {
            return Array(credits.cast.prefix(5))
        }
    }
    
    var displayedCrew: [CrewMember] {
        if showingAllCrew {
            return credits.crew
        } else {
            return Array(credits.crew.prefix(5))
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let path = movie.backdropPath {
                    WebImage(url: URL(string: "https://image.tmdb.org/t/p/w1280\(path)"))
                        .placeholder { Color.gray.frame(maxHeight: 200) }
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 200)
                        .clipped()
                }
                
                HStack(spacing: 20) {
                    Text("Revenue: $\(details.revenue)")
                    Text("\(details.runtime) minutes")
                }
                .foregroundColor(.white)
                .font(.caption)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.black)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(movie.genres) { genre in
                        Text(genre.name)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 2)
                            .background(Color(genre.color))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
            }
            
            Text(movie.overview)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            Group {
                Seperator()
                
                Text("Cast")
                    .font(.headline)
                
                ForEach(displayedCast) { member in
                    VStack {
                        Text(member.name)
                            .font(.body)
                        Text(member.character)
                            .font(.caption)
                    }
                    .padding(.vertical, 2)
                }
                
                if showingAllCast == false {
                    Button("Show All") {
                        showingAllCast.toggle()
                    }
                }
                
            }
            
            Group {
                Seperator()
                
                Text("Crew")
                    .font(.headline)
                
                ForEach(displayedCrew) { member in
                    VStack {
                        Text(member.name)
                            .font(.body)
                        Text(member.job)
                            .font(.caption)
                    }
                    .padding(.vertical, 2)
                }
                
                if showingAllCrew == false {
                    Button("Show All") {
                        showingAllCrew.toggle()
                    }
                }
                
            }
            
            Group {
                Seperator()
                
                Text("Reviews")
                    .font(.headline)
                
                ForEach(reviews) { review in
                    Text(review.text)
                        .font(.body.italic())
                        .padding(.vertical, 2)
                }
                
                TextEditor(text: $reviewText)
                    .frame(height: 200)
                    .border(Color.gray, width: 1)
                    .padding()
                
                Button("Submit Review", action: submitReview)
                    .padding()
            }
        }
        .toolbar {
            Button {
                dataController.toggleFavorite(movie)
            } label: {
                if dataController.isFavorite(movie) {
                    Image(systemName: "heart.fill")
                } else {
                    Image(systemName: "heart")
                }
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: load)
    }
    
    func load() {
        URLSession.shared.get(
            path: "movie/\(movie.id)",
            defaultValue: details) { details in
            self.details = details
        }?
        .store(in: &cancellables)
        
        URLSession.shared.get(
            path: "movie/\(movie.id)/credits",
            defaultValue: credits) { credits in
            self.credits = credits
        }?
        .store(in: &cancellables)
        
        guard let reviewURL = reviewURL else {
            return
        }
        
        URLSession.shared.fetch(reviewURL, defaultValue: []) { reviews in
            self.reviews = reviews
        }
        .store(in: &cancellables)
    }
    
    func submitReview() {
        guard
            reviewText.isEmpty == false,
            let reviewURL = reviewURL
        else {
            return
        }
        
        let review = Review(id: UUID().uuidString, text: reviewText)
        
        URLSession.shared.post(review, to: reviewURL) { result in
            reviews.append(review)
            reviewText = ""
        }
        .store(in: &cancellables)
    }
}

struct Seperator: View {
    var body: some View {
        Color.gray.opacity(0.7)
            .frame(maxWidth: .infinity, maxHeight: 1)
            .padding()
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailView(movie: .example)
                .environmentObject(DataController(inMemory: true))
        }
    }
}

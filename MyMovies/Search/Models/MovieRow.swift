//
//  MoviewRow.swift
//  MyMovies
//
//  Created by Markus on 12.05.21.
//

import SDWebImageSwiftUI
import SwiftUI

struct MovieRow: View {
    let movie: Movie
    
    var posterImage: some View {
        Group {
            if let path = movie.posterPath {
                WebImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(path)"))
                    .placeholder(Image("Loading").resizable())
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 60, height: 90)
                    .padding([.vertical, .trailing], 4)
            } else {
                Image("NoPoster")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 60, height: 90)
                    .padding([.vertical, .trailing], 4)
            }
        }
    }
    
    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            HStack {
                posterImage
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.title2)
                        .lineLimit(2)
                    
                    HStack {
                        Text("Rating: \(movie.voteAverage, specifier: "%g")/10")
                        
                        Text(movie.formattedReleaseDate)
                    }
                    .font(.subheadline)
                    
                    Text(movie.overview)
                        .lineLimit(2)
                        .font(.body.italic())
                }
            }
        }
    }
    
    
}

struct MoviewRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieRow(movie: .example)
        }
    }
}

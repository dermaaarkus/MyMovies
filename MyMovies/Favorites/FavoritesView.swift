//
//  FavoritesView.swift
//  MyMovies
//
//  Created by Markus on 12.05.21.
//

import SwiftUI

struct FavoritesView: View {
    @FetchRequest(entity: SavedMovie.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \SavedMovie.title, ascending: true)
        ]
    ) var savedMovies: FetchedResults<SavedMovie>
    
    var favoriteMovies: [Movie] {
        savedMovies.map { movie in
            let genreIds = movie.genres?
                .components(separatedBy: ",")
                .compactMap(Int.init) ?? []
            
            return Movie(
                id: Int(movie.id),
                title: movie.title ?? "",
                overview: movie.overview ?? "",
                releaseDate: movie.releaseDate ?? "",
                voteAverage: movie.voteAverage,
                posterPath: movie.posterPath,
                backdropPath: movie.backdropPath,
                genreIds: Set(genreIds)
            )
        }
    }
    
    var body: some View {
        NavigationView {
            List(favoriteMovies, rowContent: MovieRow.init)
            .navigationTitle("Favorites")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}

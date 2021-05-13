//
//  Review.swift
//  MyMovies
//
//  Created by Markus on 12.05.21.
//

import Foundation

struct Review: Codable, Identifiable {
    let id: String
    let text: String
}

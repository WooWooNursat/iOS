//
//  Movie.swift
//  Multithreading
//
//  Created by erumaru on 2/29/20.
//  Copyright © 2020 kbtu. All rights reserved.
//
import Foundation

class Details: Codable {
    var title: String
    var type: String
    var year: String
    var id: String
    var posterURL: String
    var description: String
    var writer: String
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case type = "Type"
        case year = "Year"
        case id = "imdbID"
        case posterURL = "Poster"
        case description = "Plot"
        case writer = "Writer"
    }
}
class Movie: Codable{
    var title: String
    var type: String
    var year: String
    var id: String
    var posterURL: String
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case type = "Type"
        case year = "Year"
        case id = "imdbID"
        case posterURL = "Poster"
    }
}

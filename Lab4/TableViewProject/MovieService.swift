//
//  MovieService.swift
//  TableViewProject
//
//  Created by erumaru on 4/4/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import Foundation

class MovieService {
    // MARK: - Variables
    static let shared = MovieService()
    
    // MARK: - Methods
    func downloadMovies(search: String, pagination: String, completion: @escaping (DownloadFilmsResponse) -> Void) {
       guard let url = URL(string: "http://www.omdbapi.com/?apikey=c5617788&s=" + search + "&r=json&page=" + pagination) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DownloadFilmsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    func downloadMovies(id:String, completion: @escaping (ShowFilmDetails) -> Void) {
       
            guard let url = URL(string: "http://www.omdbapi.com/?apikey=c5617788&i=" + id + "&r=json&plot=full") else { return }
                    var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          
            guard let data = data else {
                if let error = error {
                    print(error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ShowFilmDetails.self, from: data)
                
                DispatchQueue.main.sync {
                    completion(response)
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    class DownloadFilmsResponse: Codable {
        var movies: [Movie]
        var totalResults: String
        
        enum CodingKeys: String, CodingKey {
            case movies = "Search"
            case totalResults
        }
    }
    class ShowFilmDetails: Codable{
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
}

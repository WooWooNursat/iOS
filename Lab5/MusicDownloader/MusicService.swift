//
//  MusicService.swift
//  MusicDownloader
//
//  Created by erumaru on 4/18/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import Foundation
import AVFoundation

class MusicService {
    // MARK: - Variables
    static let shared = MusicService()
    var player: AVPlayer?
    
    // MARK: - Methods
    func searchForMusic(term: String, completion: @escaping (MusicSearchResponse?, Error?) -> ()) {
        let strings = term.split(separator: " ")
        var string = ""
        for i in strings {
            string = string + i + "%20"
        }
        string = String(string.dropLast(3))
        let url = URL(string: "https://itunes.apple.com/search?term=" + string + "&entity=song")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MusicSearchResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    func play(track: Track, folder: String) {
        let playerItem: AVPlayerItem
        
        switch isDownloaded(track: track, folder: folder) {
        case true:
            print("play from file")
            playerItem = .init(url: getFileUrl(for: track, folder: folder))
        case false:
            print("play from url")
            playerItem = .init(url: track.previewUrl)
        }

        self.player = AVPlayer(playerItem:playerItem)
        player?.volume = 1.0
        player?.play()
    }
    
    func play(url: URL, folder: String){
        let playerItem: AVPlayerItem
        if isDownloaded(url: url, folder: folder){
            playerItem = .init(url: url)
        }
        else {return}
        self.player = AVPlayer(playerItem: playerItem)
        player?.volume = 1.0
        player?.play()
    }
        
    func isDownloaded(track: Track, folder: String) -> Bool {
        return FileManager.default.fileExists(atPath: getFileUrl(for: track, folder: folder).path)
    }
    
    func isDownloaded(url: URL, folder: String) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    func download(track: Track, folder: String, completion: @escaping (URL?, Error?) -> ()) {
        URLSession.shared.downloadTask(with: track.previewUrl) { tempURL, _, error in
            if let tempURL = tempURL {
                do {
                    var url: URL
                    url = self.getFileUrl(for: track, folder: folder)
                    try FileManager.default.moveItem(at: tempURL, to: url)
                   
                    print("successfully downloaded: \(track.trackName)")
                    DispatchQueue.main.async {
                        completion(url, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    func getFileUrl(for track: Track, folder: String) -> URL {
        let documentsDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let url = documentsDirectoryURL.appendingPathComponent(folder + "/" + track.trackName + ".m4a")
        
        return url
    }
    
    
    // MARK: - Response
    class MusicSearchResponse: Codable {
        var tracks: [Track]
        
        enum CodingKeys: String, CodingKey {
            case tracks = "results"
        }
    }
}

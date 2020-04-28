//
//  Track.swift
//  MusicDownloader
//
//  Created by erumaru on 4/18/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import Foundation

class Track: Codable {
    var previewUrl: URL
    var artistName: String
    var trackName: String
    init(url: URL, artist: String, name: String) {
        self.previewUrl = url
        self.artistName = artist
        self.trackName = name
    }
}

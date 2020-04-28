//
//  ViewController.swift
//  MusicDownloader
//
//  Created by erumaru on 4/18/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func searchFieldDidChanged(_ sender: Any) {
        guard let term = searchField?.text else {return}
        MusicService.shared.searchForMusic(term: term) { [weak self] result, error in
            guard let self = self else { return }
            
            if let tracks = result?.tracks {
                self.tracks = tracks
                self.tableView.reloadData()
            } else if let error = error {
                print(error)
            }
        }
    }
    // MARK: - Variables
    var tracks: [Track] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchField.addTarget(self, action: #selector(ViewController.searchFieldDidChanged(_:)),
        for: .editingChanged)
    }
    

}

extension ViewController: TrackTableViewCellDelegate {
    func didPressPlay(track: Track) {
        MusicService.shared.play(track: track, folder: FileManagerViewController.currUrl)
    }
    
    func didPressDownload(track: Track, completion: @escaping (Track) -> ()) {
        MusicService.shared.download(track: track,folder: FileManagerViewController.currUrl) { url, error in
            if let url = url {
                completion(track)
            } else if let error = error {
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "track", for: indexPath) as! TrackTableViewCell
        cell.track = self.tracks[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}


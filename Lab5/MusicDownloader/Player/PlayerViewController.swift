//
//  PlayerViewController.swift
//  MusicDownloader
//
//  Created by Nursat on 4/28/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    var musUrl: URL?
    var playing: Bool = true
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backPressed))
        navigationItem.leftBarButtonItem = backButton
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        progressView.setProgress(0, animated: false)
        trackName.text = String((musUrl?.lastPathComponent.dropLast(4))!)
        MusicService.shared.play(url: musUrl!, folder: FileManagerViewController.currUrl)
        timer = Timer.scheduledTimer(timeInterval: 0.01,
        target: self,
        selector: Selector("progressUpd"),
        userInfo: nil,
        repeats: true)
        
    }
    @objc func progressUpd(){
        
        let time = MusicService.shared.player?.currentItem?.currentTime().seconds
        self.progressView.progress = Float(time!/30.0)
    }
    @IBAction func playOrPause(_ sender: Any) {
        if playing{
            MusicService.shared.player?.pause()
            playing = false
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        else{
            MusicService.shared.player?.play()
            playing = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @objc func backPressed(){
        MusicService.shared.player = nil
        timer?.invalidate()
        timer = nil
        _ = self.navigationController!.popViewController(animated : true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

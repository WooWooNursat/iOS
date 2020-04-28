//
//  itemCollectionViewCell.swift
//  MusicDownloader
//
//  Created by Nursat on 4/27/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import UIKit

class itemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var url: URL? {
        didSet{
            guard let url = url else { return }
            if url.lastPathComponent.hasSuffix(".m4a"){
            self.label?.text = String(url.lastPathComponent.dropLast(4))
            imageView.image = UIImage(systemName: "music.note")
            }
            else {
                self.label?.text = String(url.lastPathComponent)
                imageView.image = UIImage(systemName: "folder")
            }
        }
    }
}

//
//  detailViewController.swift
//  TableViewProject
//
//  Created by Nursat on 4/12/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var yearView: UILabel!
    @IBOutlet weak var typeView: UILabel!
    @IBOutlet weak var writerView: UILabel!
    @IBOutlet weak var descriptionView: UILabel!
    override func viewDidLoad() {
       
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    
    
    func updateUI(name: String, year: String, type: String, plot: String, writer: String, poster: String){
        
        self.nameView?.text = name
        self.yearView?.text = year
        self.typeView?.text = type
        self.writerView?.text = writer
        self.descriptionView?.text = plot
        ImageService.shared.downloadImage(url: poster) { image in
        self.imageView?.image = image
            self.imageView?.frame.size = CGSize(width: 200, height: 200)
        }
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

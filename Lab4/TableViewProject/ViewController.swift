//
//  ViewController.swift
//  TableViewProject
//
//  Created by erumaru on 4/4/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(downloadMovies), for: .valueChanged)
        
        return view
    }()
    
    // MARK: - Variables
    var movies: [Movie] = []
    var name = ""
    var id = ""
    var year = ""
    var plot = ""
    var type = ""
    var poster = ""
    var writer = ""
    var pagination: Int = 1
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = refreshControl
        downloadMovies()
        
    }
    
   
    // MARK: - Actions
    @objc func downloadMovies() {
        guard let search = self.textField.text else {return}
        MovieService.shared.downloadMovies(search: search, pagination: String(pagination)) { response in
            self.movies += response.movies
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @objc func downloadDetail(id: String){
        MovieService.shared.downloadMovies(id: id){ response in
            print("download - title:" + response.title)
            self.name = response.title
            self.id = response.id
            self.year = response.year
            self.plot = response.description
            self.type = response.type
            self.poster = response.posterURL
            self.writer = response.writer
        }
    }
    func openNav(nav: detailViewController){
        navigationController?.pushViewController(nav, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath) as! MovieTableViewCell
        cell.movie = self.movies[indexPath.row]
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let selectedMovie = self.movies[indexPath.row]
            self.downloadDetail(id: selectedMovie.id)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "detail") as detailViewController
        
        
        
        
        DispatchQueue.main.async {
            viewController.nameView?.text = self.name
            viewController.yearView?.text = self.year
            viewController.typeView?.text = self.type
            viewController.descriptionView?.text = self.plot
            viewController.writerView?.text = self.writer
            ImageService.shared.downloadImage(url: self.poster) { image in
                   viewController.imageView?.image = image
                       viewController.imageView?.frame.size = CGSize(width: 200, height: 200)
                   }
        }
                    
                
            
        
            
        openNav(nav: viewController)
               
            
        
            
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            pagination += 1
            downloadMovies()
        }
    }
    
}

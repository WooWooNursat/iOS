//
//  FileManagerViewController.swift
//  MusicDownloader
//
//  Created by Nursat on 4/27/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import UIKit

class FileManagerViewController: UIViewController {
    
    static var currUrl: String = ""
    var urls: [URL] = []
    let textField = UITextField(frame: CGRect(x: 0,y: 0,width: 150,height: 30))
    let toolbar = UIToolbar()
    var deleting: Bool = false
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var deleteBar: UIToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.dragDelegate = self as UICollectionViewDragDelegate
        collectionView.dropDelegate = self as UICollectionViewDropDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let musicButton = UIBarButtonItem(title: "Music", style: .plain, target: self, action: #selector(addMusic))
         let folderButton = UIBarButtonItem(title: "Folder", style: .plain, target: self, action: #selector(addFolder))
        
        navigationItem.rightBarButtonItems = [musicButton, folderButton]
        
        
        textField.textColor = UIColor.blue
        textField.backgroundColor = UIColor.white
        textField.frame.size.width = 300
        let textFieldButton = UIBarButtonItem(customView: textField)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addToUrl))
        
        let fixed = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: self, action: nil)
        fixed.width = 50
        
        toolbar.items = [textFieldButton, fixed, addButton]
        toolbar.frame = CGRect(x: collectionView.frame.origin.x, y: collectionView.frame.origin.y, width: self.view.frame.size.width, height: 44);
        view.addSubview(toolbar)
        toolbar.isHidden = true
        
        let choose = UIBarButtonItem(title: "Choose one", style: .plain, target: self, action: nil)
        choose.tintColor = UIColor.red
        deleteBar.items?.append(choose)
        deleteBar.items?.last?.isEnabled = false
        deleteBar.items?.last?.tintColor = UIColor.clear
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(FileManagerViewController.currUrl)
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            urls = fileURLs
//            MusicService.shared.play(url: urls[0])
            self.collectionView.reloadData()
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        sender.isEnabled = false
        sender.tintColor = UIColor.clear
        deleteBar.items?.last?.isEnabled = true
        deleteBar.items?.last?.tintColor = UIColor.red
        deleting = true
    }
    @objc func back(){
        
        var fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileManager.appendPathComponent(FileManagerViewController.currUrl)
        print(fileManager)
        let parentDir = fileManager.absoluteString.dropLast(fileManager.lastPathComponent.count + 1)
        print(fileManager.lastPathComponent.count)
        print(parentDir)
        urls = try! FileManager.default.contentsOfDirectory(at: URL(string: String(parentDir))!, includingPropertiesForKeys: nil)
        
        var url = URL(string: FileManagerViewController.currUrl)
        let parentUrl = url?.absoluteString.dropLast(((url?.lastPathComponent.count)! + 1))
        FileManagerViewController.currUrl = String(parentUrl!)
        print(FileManagerViewController.currUrl)
        if FileManagerViewController.currUrl == ""{
            navigationItem.leftBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        }
        self.collectionView.reloadData()
    }
    
    @objc func addMusic(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "music")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addFolder(){
        navigationItem.rightBarButtonItems?.remove(at: 1)
        
        toolbar.isHidden = false
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
               navigationItem.rightBarButtonItems?.append(cancelButton)
    }
    @objc func cancel(){
        toolbar.isHidden = true
        navigationItem.rightBarButtonItems?.remove(at: 1)
        let folderButton = UIBarButtonItem(title: "Folder", style: .plain, target: self, action: #selector(addFolder))
        navigationItem.rightBarButtonItems?.append(folderButton)
    }
    @objc func addToUrl()
    {
        let parentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(FileManagerViewController.currUrl)
        if let name = textField.text {
            let Dir = parentDir.appendingPathComponent(name)
            
            try? FileManager.default.createDirectory(at: Dir, withIntermediateDirectories: true, attributes: nil)
            
        }
        else {
            alert()
        }
        cancel()
        textField.text = ""
        urls = try! FileManager.default.contentsOfDirectory(at: parentDir, includingPropertiesForKeys: nil)
       self.collectionView.reloadData()
    }
    func alert(){
        let alert = UIAlertController(title: "Alert", message: "Invalid name", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension FileManagerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath{
                collectionView.performBatchUpdates({
                    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
                    var fileManager = try! FileManager.default.contentsOfDirectory(atPath: urls)
                    let info = fileManager.remove(at: sourceIndexPath.item)
                    fileManager.insert(info, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    func dragItems(at indexPath: IndexPath) -> [UIDragItem]{
        if let itemCell = collectionView?.cellForItem(at: indexPath) as? itemCollectionViewCell,
            let image = itemCell.imageView.image{
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem]
        }
        else{
            return []
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! itemCollectionViewCell
        cell.url = self.urls[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 200
        
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! itemCollectionViewCell
        if deleting {
            try? FileManager.default.removeItem(at: cell.url!)
            let items = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(FileManagerViewController.currUrl)
            urls = try! FileManager.default.contentsOfDirectory(at: items, includingPropertiesForKeys: nil)
            deleting = false
            deleteBar.items?.first?.isEnabled = true
            deleteBar.items?.first?.tintColor = UIColor.red
            deleteBar.items?.last?.isEnabled = false
            deleteBar.items?.last?.tintColor = UIColor.clear
        }
        else{
            if (cell.url?.lastPathComponent.hasSuffix(".m4a"))!{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "player") as PlayerViewController
                vc.musUrl = cell.url
                navigationController?.pushViewController(vc, animated: true)
                
            }
            else{
                urls = try! FileManager.default.contentsOfDirectory(at: cell.url!, includingPropertiesForKeys: nil)
                FileManagerViewController.currUrl.append(cell.url!.lastPathComponent + "/")
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(identifier: "collection") as FileManagerViewController
//                FileManagerViewController.currUrl = cell.url!.absoluteString
//                vc.urls = try! FileManager.default.contentsOfDirectory(at: cell.url!, includingPropertiesForKeys: nil)
//                navigationController?.pushViewController(vc, animated: true)
                
                let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
                navigationItem.leftBarButtonItem = backButton
            }
        }
        self.collectionView.reloadData()
    }
}

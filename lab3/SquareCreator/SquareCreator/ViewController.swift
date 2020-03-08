//
//  ViewController.swift
//  SquareCreator
//
//  Created by Nursat on 3/6/20.
//  Copyright © 2020 Nursat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addSquare))
    }
    
    @objc func addSquare() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "addVC") as AddSquareVC
        
        vc.square = {[weak self] view in
            guard let self = self else {return}
            self.view.addSubview(view)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
            view.addGestureRecognizer(tap)
            let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(recognizer:)))
            view.addGestureRecognizer(pan)
            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
            view.addGestureRecognizer(pinch)
        }
        
        navigationController?.pushViewController(vc, animated: true)
       
    }
    @objc func tapGesture(_ sender: UITapGestureRecognizer){
        guard let view = sender.view else {return}
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "addVC") as AddSquareVC
        vc.selected = view
        navigationController?.pushViewController(vc, animated: true)
    }
    var position: CGPoint!
    @objc func panGesture(recognizer: UIPanGestureRecognizer){
        guard let view = recognizer.view else {return}
        
        if recognizer.state == .began{
            position = view.frame.origin
        }
        else if recognizer.state == .changed{
                view.frame.origin = CGPoint(x: position.x + recognizer.translation(in: view).x, y: position.y + recognizer.translation(in: view).y)
           
            
        }
    }
    @objc func pinchGesture(_ sender: UIPinchGestureRecognizer){
        guard let view = sender.view else { return }

        if sender.state == .began || sender.state == .changed {
            view.transform = (view.transform.scaledBy(x: sender.scale, y: sender.scale))
           sender.scale = 1.0
        }
    }
}


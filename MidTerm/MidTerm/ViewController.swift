//
//  ViewController.swift
//  MidTerm
//
//  Created by Nursat on 3/7/20.
//  Copyright © 2020 Nursat. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func buttonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "redblue") as RedBlueViewController
        vc.color = { c in
            sender.backgroundColor = c
        }
        navigationController?.pushViewController(vc, animated: true)
}
}


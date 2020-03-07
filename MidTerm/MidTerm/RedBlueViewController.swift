//
//  RedBlueViewController.swift
//  MidTerm
//
//  Created by Nursat on 3/7/20.
//  Copyright © 2020 Nursat. All rights reserved.
//

import UIKit

class RedBlueViewController: UIViewController {

    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var color: ((_ c: UIColor) -> Void)?
    @IBAction func colorPressed(_ sender: UIButton) {
        guard let c = sender.backgroundColor else {return}
        self.color?(c)
        self.navigationController?.popViewController(animated: true)
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

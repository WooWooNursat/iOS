//
//  ViewController.swift
//  CalculatorProject
//
//  Created by erumaru on 1/25/20.
//  Copyright © 2020 kbtu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let model = Calculator()
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var ACButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    var secnum: Bool = false
    
    @IBAction func numberPressed(_ sender: UIButton) {
        guard
            let numberText = sender.titleLabel?.text
        else { return }
        if resultLabel.text == "0" {
            resultLabel.text = sender.titleLabel?.text
        }
        else{
           
            if(secnum){
                resultLabel.text = sender.titleLabel?.text
                secnum = false
            }
            else {
                 resultLabel.text?.append(numberText)
            }
        }
        if(model.acorc == false){
            ACButton.titleLabel?.text = "C"
            model.acorc = true
        }
        model.lastIsOp = false
        model.repeatop = false
    }
    
    
    @IBAction func operationPressed(_ sender: UIButton) {
        guard
            let numberText = resultLabel.text,
            let number = Double(numberText),
            let operation = sender.titleLabel?.text
        else {
            return
        }
        if operation == "C" {
            sender.titleLabel?.text = "AC"
        }
        
        model.setOperand(number: number)
        model.executeOperation(symbol: operation)
        
        if model.check == false {
            resultLabel.text = "Не определено"
        }
            
       
            
        if model.result - model.result.rounded() != 0{
        resultLabel.text = "\(model.result)"
        }
        else{
            resultLabel.text = "\(Int(model.result))"
        }
        
        if operation == "+" ||
            operation == "-" ||
            operation == "*" ||
            operation == "/" ||
            operation == "pow"{
            secnum = true
            
        }
    }
}


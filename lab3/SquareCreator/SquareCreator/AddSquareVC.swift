//
//  AddSquareVC.swift
//  SquareCreator
//
//  Created by Nursat on 3/6/20.
//  Copyright © 2020 Nursat. All rights reserved.
//

import UIKit

class AddSquareVC: UIViewController {

    @IBOutlet weak var textFieldWidth: UITextField!
    @IBOutlet weak var textFieldHeight: UITextField!
    @IBOutlet weak var textFieldX: UITextField!
    @IBOutlet weak var textFieldY: UITextField!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBAction func buttonPressed(_ sender: UIButton){
        switch UIColor.white {
        case redButton.backgroundColor:
            redButton.tintColor = UIColor.white
            redButton.backgroundColor = UIColor.red
        case blueButton.backgroundColor:
            blueButton.tintColor = UIColor.white
            blueButton.backgroundColor = UIColor.blue
        case purpleButton.backgroundColor:
            purpleButton.tintColor = UIColor.white
            purpleButton.backgroundColor = UIColor.purple
        default:
            yellowButton.tintColor = UIColor.white
            yellowButton.backgroundColor = UIColor.yellow
        }
        color = sender.backgroundColor
        sender.tintColor = sender.backgroundColor
        sender.backgroundColor = UIColor.white
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveSquare))
        let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSquare))
        guard nil != selected else {
            navigationItem.rightBarButtonItem = saveButton
            return
        }
        navigationItem.rightBarButtonItems = [saveButton, deleteButton]
        selectedInfo()
    }
    var selected: UIView?
    var color: UIColor?
    var square: ((_ view: UIView) -> Void)?
    func selectedInfo() -> Void{
        if let square = selected {
            textFieldWidth.text = square.frame.width.description
            textFieldHeight.text = square.frame.height.description
            textFieldX.text = square.frame.origin.x.description
            textFieldY.text = square.frame.origin.y.description
            switch square.backgroundColor {
            case redButton.backgroundColor:
                buttonPressed(redButton)
            case blueButton.backgroundColor:
                buttonPressed(blueButton)
            case purpleButton.backgroundColor:
                buttonPressed(purpleButton)
            default:
                buttonPressed(yellowButton)
            }
        }
    }
    @objc func saveSquare(){
        
        guard let a = textFieldWidth.text, let b = textFieldHeight.text, let c = textFieldX.text, let d = textFieldY.text, let color = color else {
            let alert = UIAlertController(title: "Ошибка", message: "Заполните все данные", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let width = Double(a), let height = Double(b), let x = Double(c), let y = Double(d) else {
            let alert = UIAlertController(title: "Ошибка", message: "Неверные данные", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if x + width > Double(UIScreen.main.bounds.width) || y + height > Double(UIScreen.main.bounds.height) || x < 0 || y < 0{
            let alert = UIAlertController(title: "Ошибка", message: "Координаты должны быть в пределах экрана", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let square = selected else {
            let square = UIView(frame: CGRect(x:x, y:y, width: width, height: height))
            square.backgroundColor = color
            self.square?(square)
            self.navigationController?.popViewController(animated: true)
            return
        }
        changeSquare(square, color, width, height, x, y)
        self.navigationController?.popViewController(animated: true)
    }
    @objc func deleteSquare(){
        guard let square = selected else {return}
        square.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    func changeSquare(_ square: UIView,_ color: UIColor,_ width: Double,_ height: Double,_ x: Double,_ y: Double){
        square.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
        square.backgroundColor = color
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

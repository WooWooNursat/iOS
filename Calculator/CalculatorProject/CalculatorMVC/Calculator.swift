//
//  Calculator.swift
//  CalculatorProject
//
//  Created by erumaru on 1/25/20.
//  Copyright © 2020 kbtu. All rights reserved.
//
import UIKit
import Foundation

class Calculator {
    // MARK: - Constants
    enum Operation {
        case equals
        case ac
        case c
        case constant(value: Double)
        case unary(function: (Double) -> Double)
        case binary(function: (Double, Double) -> Double)
    }
    
    var map: [String : Operation] = [
        "-" : .binary { $0 - $1 },
        "+" : .binary { $0 + $1 },
        "*" : .binary { $0 * $1},
        "/" : .binary {$0/$1},
        "sqrt": .unary {$0.squareRoot()},
        "pi" : .constant(value: .pi),
        "%" : .unary {$0/100},
        "rand" : .constant(value: .random(in: 0..<1)),
        "x!" : .unary{$0},
        "pow" : .binary{pow($0, $1)},
        "AC" : .ac,
        "C" : .c,
        "=" : .equals
    ]
        
    // MARK: - Variables
    var result: Double = 0
    var lastBinaryOperation: ((Double, Double) -> Double)?
    var reminder: Double = 0
    var check: Bool = true
    var acorc: Bool = false
    var repeatop: Bool = false
    var num: Double = 0
    var binaryPressed: String?
    var prevOp: ((Double, Double) -> Double)?
    var lastIsOp: Bool = false
    // MARK: - Methods
    func setOperand(number: Double) {
        result = number
        check = true
        acorc = true
    }
    
    func executeOperation(symbol: String) {
        guard let operation = map[symbol] else {
            print("ERROR: no such symbol in map")
            return
        }
        guard check == true || symbol == "AC" else{return}
        switch operation {
        case .constant(let value):
            result = value
        case .unary(let function):
            if symbol == "x!"{
                if result - result.rounded() == 0{
                    let number = abs(Int(result))+1
                    var x = Int(result/abs(result))
                    for i in 2 ..< number{
                        x = x * i
                    }
                    result = Double(x)
                }
                else {
                    check = false
                }
            }
            else if symbol == "%" {
                if reminder == 0 {
                    result = function(result)
                }
                else {result = reminder * function(result)}
            }
            else{
            result = function(result)
            }
        case .binary(let function):
            repeatop = false
            if lastBinaryOperation != nil{
                if symbol == binaryPressed && lastIsOp{
                    return
                }
                executeOperation(symbol: "=")
            }
            else {
                reminder = result
            }
            lastIsOp = true
            binaryPressed = symbol
            lastBinaryOperation = function
                
        case .equals:
            if let lastOperation = lastBinaryOperation {
                if !repeatop{
                    num = result
                    repeatop = true
                    prevOp = lastOperation
                }
                
                result = prevOp!(reminder, num)
                lastIsOp = false
                binaryPressed = ""
                lastBinaryOperation = nil
                reminder = result
            }
        
        case .c:
            result = 0
            acorc = false
        case .ac:
            lastBinaryOperation = nil
            reminder = 0
            result = 0
            acorc = false
            check = true
            repeatop = false
            binaryPressed = ""
            num = 0
        }
        
    }
}

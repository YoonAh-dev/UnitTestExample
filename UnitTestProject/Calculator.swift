//
//  Calculator.swift
//  UnitTestProject
//
//  Created by SHIN YOON AH on 8/11/24.
//

import Foundation

protocol Calculator {
    associatedtype T
    func sum(_ a: T, _ b: T) -> T
    func minus(_ a: T, _ b: T) -> T
}

final class MockCalculator: Calculator {
    
    public func sum(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    public func minus(_ a: Int, _ b: Int) -> Int {
        return a - b
    }
}

final class Student {
    private let calculator: any Calculator
    
    init(calculator: any Calculator) {
        self.calculator = calculator
    }
    
    func calculate(_ expression: String) -> Int {
        let chars = expression.split(separator: " ")
        var `operator`: [String] = []
        var operand: [Int] = []
        
        for char in chars {
            if let int = Int(char) {
                operand.append(int)
            }
        }
        
        return 0
    }
}

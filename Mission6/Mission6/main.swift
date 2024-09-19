//
//  main.swift
//  Mission6
//
//  Created by jaegu park on 9/19/24.
//

import Foundation

class StackCalculator {
    private var Stack: [Int] = []
    private var registerA: Int?
    private var registerB: Int?
    private var result: [String] = []

    private func popA() {
        if Stack.isEmpty {
            result.append("EMPTY")
        } else {
            registerA = Stack.removeLast()
        }
    }
    
    private func popB() {
        if Stack.isEmpty {
            result.append("EMPTY")
        } else {
            registerB = Stack.removeLast()
        }
    }
    
    private func add() {
        guard let a = registerA, let b = registerB else {
            result.append("ERROR")
            return
        }
        push(num: a + b)
    }
    
    private func sub() {
        guard let a = registerA, let b = registerB else {
            result.append("ERROR")
            return
        }
        push(num: a - b)
    }
    
    private func push(num: Int) {
        if Stack.count >= 8 {
            result.append("OVERFLOW")
        } else {
            Stack.append(num)
        }
    }
    
    private func swapRegisters() {
        guard let a = registerA, let b = registerB else {
            result.append("ERROR")
            return
        }
        registerA = b
        registerB = a
    }
    
    private func printLast() {
        if Stack.isEmpty {
            result.append("EMPTY")
        } else {
            let num = Stack.removeLast()
            result.append("\(num)")
        }
    }
    
    func calculate(commands: [String]) -> [String] {
        for input in commands {
            switch input {
            case "POPA":
                popA()
            case "POPB":
                popB()
            case "ADD":
                add()
            case "SUB":
                sub()
            case "PUSH0":
                push(num: 0)
            case "PUSH1":
                push(num: 1)
            case "PUSH2":
                push(num: 2)
            case "SWAP":
                swapRegisters()
            case "PRINT":
                printLast()
            default:
                result.append("UNKNOWN")
            }
        }
        return result
    }
}

let calculator = StackCalculator()

print("명령들을 띄어쓰기로 구분하여 입력하세요 ex) PUSH1 PUSH2 ADD PRINT:")
if let input = readLine() {
    let commands = input.split(separator: " ").map { String($0) }
    let result = calculator.calculate(commands: commands)
    print(result.joined(separator: ", "))
}

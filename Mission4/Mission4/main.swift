//
//  main.swift
//  Mission4
//
//  Created by jaegu park on 9/19/24.
//

import Foundation

var ladder: [[String]] = []

let oneLine = "---"
let rightDown = "\\-\\"
let leftDown = "/-/"
let empty = "   "

func reset() {
    ladder = Array(repeating: Array(repeating: empty, count: 4), count: 5)
}

func randomFill() {
    for i in 0..<5 {
        for j in 0..<4 {
            let randomNumber = Int.random(in: 0...3)
            switch randomNumber {
            case 1:
                ladder[i][j] = oneLine
            case 2:
                ladder[i][j] = rightDown
            case 3:
                ladder[i][j] = leftDown
            default:
                ladder[i][j] = empty
            }
        }
    }
}

func analyze() -> Bool {
    for i in 0..<5 {
        for j in 0..<4 - 1 {
            let currentStep = ladder[i][j]
            let nextStep = ladder[i][j + 1]
            
            if currentStep == oneLine && nextStep == oneLine {
                return false
            }
            if currentStep == rightDown && nextStep == leftDown {
                return false
            }
            if currentStep == leftDown && nextStep == rightDown {
                return false
            }
        }
    }
    return true
}

func display() -> String {
    var result = ""
    for row in ladder {
        result += "|"
        for column in row {
            result += column + "|"
        }
        result += "\n"
    }
    return result
}

reset()
print(display())

reset()
randomFill()
print(display())

reset()
randomFill()
let analyzeResult = analyze()
print("분석 결과: \(analyzeResult)")
print(display())

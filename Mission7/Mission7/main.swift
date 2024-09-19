//
//  main.swift
//  Mission7
//
//  Created by jaegu park on 9/19/24.
//

import Foundation

var marsCal = [Any]()

private func get_EarthDay(_ arr: [String]) -> Int {
    let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var day: Int = 0
    day = (Int(arr[0])! - 1) * 365 + Int((Double(Int(arr[0])! - 1) / 4.0).rounded(.down))
    for i in 0..<(Int(arr[1])! - 1) {
        if i == 1 && Int(arr[0])! % 4 == 0 {
            day += 1
        } else {
            day += days[i]
        }
    }
    day += Int(arr[2])!
    return day
}

private func get_MarsDay(_ earthDay: Int) {
    var year = earthDay / 668
    year -= 1
    var leapDay = earthDay - ((year + 1) / 2)
    var day = leapDay - year * 668
    var month = day / 28
    var marsDay = day - month * 28
    marsDay -= 1
    make_MarsCal(year, month + 1)

    var str = "\n지구날은  \(earthDay) => \(year) 화성년 \(month + 1)월 \(marsDay)일\n\n"
    str += "     \(year)년  \(month + 1)월\n"
    str += "Su Lu Ma Me Jo Ve Sa"
    
    for i in 0..<marsCal.count {
        if i % 7 == 0 {
            str += "\n"
        }
        if i < 9 {
            str += " \(marsCal[i]) "
        } else {
            str += "\(marsCal[i]) "
        }
    }
    print(str)
}

private func make_MarsCal(_ year: Int, _ month: Int) {
    for i in 1...28 {
        if month % 6 == 0 {
            if (year % 2 == 0) && (month == 24 ) {
                marsCal.append("(윤년)\(i)")
            }
        } else {
            marsCal.append(i)
        }
    }
}

private func bar() {
    let totalSteps = 10
    
    for i in 1...totalSteps {
        let progress = Double(i) / Double(totalSteps)
        let progressBar = String(repeating: "▓", count: i) + String(repeating: "░", count: totalSteps - i)
        print("\r\(progressBar) 화성까지 여행 \(Int(progress * 100))%", terminator: "")
        fflush(stdout)
        Thread.sleep(forTimeInterval: 0.5)
    }
}

func main() {
    print("지구날짜는? ", terminator: "")
    let arr = readLine()!.split(separator: "-").map { String($0) }
    bar()
    let earthDay = get_EarthDay(arr)
    get_MarsDay(earthDay)
}

main()

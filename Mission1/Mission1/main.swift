//
//  main.swift
//  Mission1
//
//  Created by jaegu park on 9/19/24.
//

import Foundation

func remove(from: String) -> String {
    let out = from.filter { $0.isNumber }
    return out
}

public extension StringProtocol {
    public subscript (i: Int) -> Element {
        return self[index(startIndex, offsetBy: i)]
    }
}

func solution(_ telno: String) -> [String] {
    let tel = remove(from: telno)
    let failure = ["전국","X"]
    let map = [ "010" : "휴대폰",
                "011" : "휴대폰","016" : "휴대폰","017" : "휴대폰","018" : "휴대폰", "019" : "휴대폰",
                "031" : "경기", "032" : "인천", "033" : "강원",
                "041" : "충청", "042" : "대전", "044" : "세종",
                "051" : "부산", "052" : "울산", "053" : "대구",
                "054" : "경북", "055" : "경남",
                "061" : "전남", "062" : "광주", "063" : "전북",
                "064" : "제주"
    ]
    
    let index0 = tel.index(tel.startIndex, offsetBy: 0)
    let index2 = tel.index(tel.startIndex, offsetBy: 2)

    let last0 = tel.index(tel.endIndex, offsetBy: -4)
    let last3 = tel.index(tel.endIndex, offsetBy: -1)

    if tel.count > 11 || tel.count < 9 { return failure }
    else if tel[0] != "0" { return failure }

    let top = String(tel[index0...index2])
    let ext = String(tel[last0...last3])

    if tel[1] == "2" {
        guard tel.count == 10 else { return ["서울", "X"] }
        guard !(ext[0] == ext[1] && ext[1] == ext[2]
            && ext[2] == ext[3]) else { return ["서울", "X"] }
        return ["서울", "O"]
    }
    else if top == "001" || top == "002" {
        let interTel = String(tel.dropFirst(3))
        if interTel.count >= 8 && interTel.count <= 12 {
            return ["국제전화", "O"]
        }
        return failure
    }
    else if tel[1] == "1" {
        guard map[top] != nil  else {
            return failure
        }
        let top2 = tel[2]
        guard top2 == "0" else { return ["휴대폰", "X"] }
        if tel.count == 11 && (Int(String(tel[3])) ?? 1) % 2 == 0 {
            return ["휴대폰", "O"]
        }
        return ["휴대폰", "X"]
    }
    else if let region = map[top] {
        if tel.count == 10 && tel[3] == "0" { return [region, "X"] }
        return [region, "O"]
    }
    
    return failure
}

print(solution("010-123-1234"))
print(solution("010-2234-1234"))
print(solution("02-1234-1234"))
print(solution("0212341111"))
print(solution("0311237890"))
print(solution("061-012-7890"))
print(solution("015-0157899"))
print(solution("042-2123-7890"))
print(solution("010.234.5678"))
print(solution("+82-10-2345-6789"))
print(solution("001-12345678"))
print(solution("002-123456789012"))
print(solution("001-1234567"))

//
//  main.swift
//  Mission2
//
//  Created by jaegu park on 9/19/24.
//

import Foundation

func play() -> [String: Int] {
    let players = ["A", "B", "C", "D"]
    var currentPosition = Array(repeating: 0, count: players.count) // 각 참가자의 현재 위치
    var ownership = Array(repeating: "", count: 15) // 각 장소의 소유자

    while ownership.contains(where: { $0.isEmpty }) { // 아직 소유하지 않은 장소가 있는 동안 반복
        // 사용자로부터 입력 받기
        print("입력(예: 1 2 3 4):")
        let param0 = readLine()!.split(separator: " ").compactMap { Int($0) }

        // 입력 값이 4개인지 확인
        if param0.count != 4 || param0.contains(where: { $0 < 1 || $0 > 4 }) {
            print("잘못된 입력입니다. 1-4 사이의 숫자 4개를 입력하세요.")
            continue
        }

        for (index, move) in param0.enumerated() {
            let player = players[index]
            let newPosition = (currentPosition[index] + move) % 15

            // 해당 위치의 소유 여부 확인
            if ownership[newPosition].isEmpty {
                ownership[newPosition] = player // 누가 처음 방문하면 소유권 획득
            }

            currentPosition[index] = newPosition

            // 모든 장소가 소유됐는지 확인
            if !ownership.contains(where: { $0.isEmpty }) {
                break // 모든 장소가 소유됐으면 더 이상 반복하지 않음
            }
        }
    }

    // 각 참가자의 소유한 장소 개수 계산
    var ownershipCount: [String: Int] = [:]
    for player in players {
        let count = ownership.filter { $0 == player }.count
        ownershipCount[player] = count
    }

    return ownershipCount
}

// 게임 실행
let result = play()
print(result)

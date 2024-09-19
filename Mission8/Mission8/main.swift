//
//  main.swift
//  Mission8
//
//  Created by jaegu park on 9/19/24.
//

import Foundation

struct LogData {
    var logLevel: String
    var timeStamp: String
    var process: String
    var message: String
}

// 파일을 읽는 함수
func parseLogFile(filePath: String) -> [LogData]? {
    do {
        // 파일 내용을 저장
        let Contents = try String(contentsOfFile: filePath, encoding: .utf8)
        var logDatas = [LogData]()
        
        // 한줄씩 줄바꿈으로 구분하여 저장
        let lines = Contents.split(separator: "\n")
        for line in lines {
            // 요소를 탭문자로 구분하여 저장
            let components = line.split(separator: "\t")
            if components.count >= 4 {
                let logLevel = String(components[0])
                let timeStamp = String(components[1])
                let process = String(components[2])
                // 나머지 문자열 저장
                let message = components[3...].joined(separator: "\t")
                let data = LogData(logLevel: logLevel, timeStamp: timeStamp, process: process, message: message)
                logDatas.append(data) // 데이터들을 배열로 저장
            }
        }
        
        return logDatas
    } catch {
        print("파일을 읽는 중 오류 발생: \(error)")
        return nil
    }
}

// 로그 레벨 유형별로 필터링하는 함수
func filterByLogLevel(datas: [LogData]) -> [String: [LogData]] {
    var filteredDatas = [String: [LogData]]()
    for data in datas {
        filteredDatas[data.logLevel, default: []].append(data)
    }
    return filteredDatas
}

// 로그 시각으로 정렬하는 함수
func sortByTimestamp(datas: [LogData]) -> [LogData] {
    return datas.sorted { $0.timeStamp < $1.timeStamp }
}

// 프로세스 이름별로 필터링하는 함수
func filterByProcess(datas: [LogData]) -> [String: [LogData]] {
    var filteredEntries = [String: [LogData]]()
    for data in datas {
        filteredEntries[data.process, default: []].append(data)
    }
    return filteredEntries
}

// 프로세스 이름으로 정렬하는 함수
func sortByProcess(datas: [LogData]) -> [LogData] {
    return datas.sorted { $0.process < $1.process }
}

// 로그 레벨 유형별로 카운트 하는 함수
func countByLogLevel(datas: [LogData]) -> [String: Int] {
    var count = [String: Int]()
    for data in datas {
        count[data.logLevel, default: 0] += 1
    }
    return count
}

// 프로세스 이름별로 카운트 하는 함수
func countByProcess(datas: [LogData]) -> [String: Int] {
    var count = [String: Int]()
    for data in datas {
        count[data.process, default: 0] += 1
    }
    return count
}

if let logDatas = parseLogFile(filePath: "/Users/jaegupark/Downloads/1701410305471system.log") {
    
    let logLevelFiltered = filterByLogLevel(datas: logDatas)
    print("로그 레벨별 필터링된 항목:")
    for (level, datas) in logLevelFiltered {
        print("\(level): \(datas)")
    }
    
    let sortedByTimestamp = sortByTimestamp(datas: logDatas)
    print("로그 시각 기준 정렬: \(sortedByTimestamp)")
    
    let processFiltered = filterByProcess(datas: logDatas)
    print("프로세스 이름별 필터링된 항목:")
    for (process, datas) in processFiltered {
        print("\(process): \(datas)")
    }
    
    let sortedByProcess = sortByProcess(datas: logDatas)
    print("프로세스 이름 기준 정렬: \(sortedByProcess)")
    
    let logLevelCounts = countByLogLevel(datas: logDatas)
    print("로그 레벨별 항목 수: \(logLevelCounts)")
    
    let processCounts = countByProcess(datas: logDatas)
    print("프로세스별 항목 수: \(processCounts)")
} else {
    print("로그 파일을 분석하지 못했습니다.")
}

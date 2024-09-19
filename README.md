# Mission1

<br>

## 1. 기능요구사항 분석하기
### 기존 코드의 구조와 작동 방식을 이해하기 위해 코드를 분석했습니다
#### remove(from:)함수
```swift
func remove(from: String) -> String {
    let out = from
    return out
}
```
##### 이 함수는 입력 문자열에서 그대로 문자열을 리턴하는 역할을 합니다. (이 함수는 왜 필요한가?)
#### solution 함수
```swift
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
```
##### 이 함수는 전화번호를 분석하여 특정 조건과 일치하는지 확인하고, 휴대폰 여부와 지역을 반환합니다.

<br>

## 2. 요구사항 역분석하기
### 서울 지역 판단 조건
1. 전화번호 두 번째 문자가 “2”이어야 한다.
2. 전화번호가 10자리이어야 한다.
3. 마지막 4자리 숫자가 동일한 숫자로 반복되지 않아야 한다.
### 휴대폰 번호 판단 조건
1. 전화번호 두 번째 문자가 “1”이어야 한다.
2. 전화번호 첫 번째 문자가 “0”이어야 한다.
3. 전화번호 세 번째 문자가 “0”이어야 한다.
4. 전화번호의 길이가 11자리이고 네 번째 숫자가 짝수이어야 한다.

<br>

## 3. 디버깅해서 개선하기
### 문자가 포함되어 있어도 동작해야 한다. 이 부분 코드를 찾아서 개선한다.
#### 기존 코드를 분석해본 결과 문자열에 “-“에 포함되어 있으면 solution함수에서 처리해주지 못하는 코드였다.
따라서 문자열에 “-“이 포함되어 있으면 “-“를 제거해주고 숫자로만 이루어진 문자열인지 판멸해주는 “isNumber”라는 기능을 remove함수에 추가해주었다.
#### 기존 코드
```swift
func remove(from: String) -> String {
    let out = from
    return out
}
```
#### 개선한 코드
```swift
func remove(from: String) -> String {
    let out = from.filter { $0.isNumber }
    return out
}
```
#### 입력/출력 조건 추가
```swift
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
```

<br>

## 4. 새로운 요구사항 추가하기
### 001과 002 로 시작하는 번호는 국제전화로 판단해서 앞 3자리를 제외하고 8자리~12자리까지만 허용하는 로직을 추가한다.
1. 전화번호 문자열이 001 또는 002로 시작하는지 확인합니다.
2. 시작 부분을 제외한 나머지 번호가 8자리에서 12자리 사이인지 확인합니다.
3. 조건을 만족하면 ["국제전화", "O"]를 반환하고, 그렇지 않으면 실패를 나타내는 ["전국", "X"]를 반환하도록 수정했습니다.
#### 추가 코드
```swift
if top == "001" || top == "002" {
  let interTel = String(tel.dropFirst(3))
    if interTel.count >= 8 && interTel.count <= 12 {
      return ["국제전화", "O"]
    }
    return failure
}
```
#### 입력/출력 조건 추가
```swift
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
```
<br>

# Mission2

<br>

## 기능요구사항 분석하기
### - A, B, C, D 4명의 참가자가 있다고 가정하고 매 턴마다 주사위 대신에 1-4 사이의 값이 입력으로 제공됩니다.
```swift
let players = ["A", "B", "C", "D"]

// 사용자로부터 입력 받기
print("입력(예: 1 2 3 4):")
let param0 = readLine()!.split(separator: " ").compactMap { Int($0) }

// 입력 값이 4개인지 확인
if param0.count != 4 || param0.contains(where: { $0 < 1 || $0 > 4 }) {
  print("잘못된 입력입니다. 1-4 사이의 숫자 4개를 입력하세요.")
  continue
}
```
<br>

### - 모든 참가자는 시작 지점에서 출발하고, 주어진 1-4 값만큼 이동합니다.
```swift
// 각 참가자의 이동 값을 순서대로 처리
for (index, move) in param0.enumerated() {
  let player = players[index] // 현재 참가자를 설정
  let newPosition = (currentPosition[index] + move) % 15 // 참가자의 새로운 위치를 계산. 보드가 이므로 15로 나눈 나머지를 사용
  currentPosition[index] = newPosition // 참가자의 현재 위치를 갱신
}
```
<br>

### - 한 번도 방문하지 않은 곳에 누군가 도착하면 그 곳을 소유하고 다른 사람이 이미 소유한 곳에 도착하면 뺏을 수 없습니다.
```swift
// 도착한 장소가 소유되지 않은 경우 소유권을 획득
if ownership[newPosition].isEmpty {
  ownership[newPosition] = player // 누가 처음 방문하면 소유권 획득
}
```
<br>

### - 여러 사람들이 모든 장소를 소유할 때까지 계속 입력으로 이동할 수 있고, 더 이상 이동할 입력값이 없거나, 더 이상 소유할 장소가 없으면 게임을 종료합니다.
```swift
// 모든 장소가 소유됐는지 확인
if !ownership.contains(where: { $0.isEmpty }) {
  break // 모든 장소가 소유되었는지 확인하고, 그렇다면 게임을 종료
}
```
<br>

### - 종료 시점에는 각 참가자별로 소유한 장소 개수를 리턴하세요.
```swift
// 각 참가자의 소유한 장소 개수 계산
var ownershipCount: [String: Int] = [:] // 각 참가자의 소유한 장소 개수를 저장할 딕셔너리를 초기화
for player in players {
  let count = ownership.filter { $0 == player }.count // 해당 참가자가 소유한 장소 개수 세기
  ownershipCount[player] = count
}

return ownershipCount
```
<br>

#### 입력/출력
```swift
입력(예: 1 2 3 4): 
1 2 3 4
입력(예: 1 2 3 4): 
4 4 4 4
입력(예: 1 2 3 4): 
4 4 4 4
입력(예: 1 2 3 4): 
4 4 4 4
["C": 4, "D": 3, "B": 4, "A": 4]
```
<br>

# Mission3

### 다음과 같이 특정 게임에 대한 검색 프로그램을 작성하려고 합니다.
### 검색 동작을 하는 find() 함수를 구현하세요.
### 게임별로 이름, 단종여부, 장르, 별점, 최대참여자, 게임을 판매한 기간이 주어져 있다.
<br>

## 1. Game 구조체 생성
```swift
struct Game {
  let name: String
  let discontinued: Bool
  let genre: String
  let rating: Double
  let maxPlayers: Int
  let startDate: Date
  let endDate: Date
}
```
<br>

## 2. 날짜 포맷터 설정
```swift
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyyMM"
```
<br>

## 3. 각 게임의 정보 초기화
```swift
let games = [
  Game(name: "Kong", discontinued: true, genre: "Adventure", rating: 4.1, maxPlayers: 1, startDate: dateFormatter.date(from: "197001")!, endDate: dateFormatter.date(from: "198104")!),
  Game(name: "Ace", discontinued: false, genre: "Board", rating: 3.8, maxPlayers: 4, startDate: dateFormatter.date(from: "198707")!, endDate: dateFormatter.date(from: "202407")!),
  Game(name: "Mario", discontinued: true, genre: "RPG", rating: 3.3, maxPlayers: 2, startDate: dateFormatter.date(from: "200109")!, endDate: dateFormatter.date(from: "200711")!),
  Game(name: "Prince", discontinued: true, genre: "RPG", rating: 4.8, maxPlayers: 1, startDate: dateFormatter.date(from: "198303")!, endDate: dateFormatter.date(from: "200205")!),
  Game(name: "Dragons", discontinued: true, genre: "Fight", rating: 3.4, maxPlayers: 4, startDate: dateFormatter.date(from: "199005")!, endDate: dateFormatter.date(from: "199512")!),
  Game(name: "Civil", discontinued: false, genre: "Simulation", rating: 4.2, maxPlayers: 1, startDate: dateFormatter.date(from: "200206")!, endDate: dateFormatter.date(from: "202407")!),
  Game(name: "Teken", discontinued: true, genre: "Fight", rating: 4.0, maxPlayers: 2, startDate: dateFormatter.date(from: "199807")!, endDate: dateFormatter.date(from: "200912")!),
  Game(name: "GoCart", discontinued: false, genre: "Sports", rating: 4.6, maxPlayers: 8, startDate: dateFormatter.date(from: "200612")!, endDate: dateFormatter.date(from: "202407")!),
  Game(name: "Football", discontinued: false, genre: "Sports", rating: 2.9, maxPlayers: 8, startDate: dateFormatter.date(from: "199406")!, endDate: dateFormatter.date(from: "202407")!),
  Game(name: "Brave", discontinued: true, genre: "RPG", rating: 4.2, maxPlayers: 1, startDate: dateFormatter.date(from: "198006")!, endDate: dateFormatter.date(from: "198501")!)
]
```
<br>

## 4. 기능요구사항 분석하기
### - find() 요구사항
#### 함수 시그니처는 다음과 같이 구현하세요.
```swift
func find(param0 : String, param1: Int) -> String
```
<br>

### - 게임에 대한 데이터 구조에서 판매 시작 시점과 판매 종료 시점을 param0와 비교해서 판매 중인 시점의 게임을 출력해야 합니다.
### - param1 참가자 인원수와 비교해서 참가 가능한 게임만 출력해야 합니다.
### - 최종 출력값은 게임 별점(내림차순)으로 정렬해야 합니다.
```swift
// param0을 Date객체로 변환
guard let findDate = dateFormatter.date(from: param0) else {
  return "Error" // 형식에 맞지 않으면 에러 변환
}
    
let findGames = games.filter { result in
  return result.startDate <= findDate && result.endDate >= findDate // 판매 기간 내에 있는 게임을 필터
                              && result.maxPlayers >= param1 // 참가 인원수를 만족하는 게임을 필터
}.sorted { $0.rating > $1.rating } // 필터된 게임을 별점 순으로 정렬
```
<br>

### - 단종된 게임의 경우는 이름 뒤에 * 문자를 붙여서 출력합니다.
```swift
let resultGames = findGames.map { result in
  // 단종된 게임의 이름 뒤에 *를 추가하여 변환
  let name = result.discontinued ? "\(result.name)*(\(result.genre))" : "\(result.name)(\(result.genre))"
  // 게임의 이름, 장르, 별점을 포함하는 문자열 변환                 
  let name = result.discontinued ? "\(result.name)*(\(result.genre))" : "\(result.name)(\(result.genre))"
  return "\(name) \(result.rating)"
}
```
<br>

### - 입력/출력
```swift
print(find(param0: "198402", param1: 1))
print(find(param0: "200008", param1: 8))
print(find(param0: "199004", param1: 5))
```
```swift
Prince*(RPG) 4.8, Brave*(RPG) 4.2
Football(Sports) 2.9
  
```
<br>

# Mission4

## 3가지 발판 유형을 가지는 사다리 게임을 구현하려고 한다.
### - 참가자는 5명으로, 사다리 높이는 5칸으로 고정한다.
### - 사다리 발판 종류
1. --- 1자 발판 : 좌→우, 우→좌 양쪽에서 모두 이동 가능하다.
2. \\-\ 우하향 발판 : 좌→우에서만 이동 가능하다.
3. /-/ 좌하향 발판 : 우→좌에서만 이동 가능하다.

<br>

## 1. reset() 함수
### - 사다리 데이터 구조를 초기화한다.
### - 모두 비어있는 상태로 만들어야 한다.
```swift
// 사다리를 나타내는 2차원 배열 선언
var ladder: [[String]] = []

// 사다리를 4X5 2차원 배열로 초기화
func reset() {
  ladder = Array(repeating: Array(repeating: empty, count: 4), count: 5)
}
```
<br>

## 2. randomFill() 함수
### - 랜덤하게 3가지 발판 종류를 선택해서 사다리 데이터 구조를 채운다.
### - 총 발판 몇 개를 채울지도 랜덤하게 결정한다.
```swift
// 발판의 종류
let oneLine = "---"
let rightDown = "\\-\\" // "\-\"를 입력하면 오류 발생
let leftDown = "/-/"
let empty = "   "

// 0~3까지 랜덤하게 숫자를 생성하여 사다리에 발판을 채움
func randomFill() {
  for i in 0..<5 {
    for j in 0..<4 {
      let randomNumber = Int.random(in: 0...3) // 랜덤 숫자 생성
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
```
<br>

## 3. analyze() 함수
### - 사다리 데이터 구조를 분석한 결과를 리턴한다.
#### 1. 좌우에 1자 발판이 연속으로 나오면 false
#### 2. 좌측에 우하향 발판 + 우측에 좌하향 발판이 연속으로 나오면 false
#### 3. 좌측에 좌하향 발판 + 우측에 우하향 발판이 연속으로 나오면 false
#### 4. 위에 해당하는 경우가 없으면 true를 return
```swift
func analyze() -> Bool {
  for i in 0..<5 {
    for j in 0..<4 - 1 { // j를 0까지 3까지 탐색하면 nextStep에서 인덱스 오류가 발생
      let currentStep = ladder[i][j]
      let nextStep = ladder[i][j + 1]
      
      // 두 개의 일자 발판이 연속으로 나오는 경우
      if currentStep == oneLine && nextStep == oneLine {
        return false
      }
      // 우하향 발판과 좌하향 발판이 나오는 경우
      if currentStep == rightDown && nextStep == leftDown {
        return false
      }
      // 좌하향 발판과 우하향 발판이 나오는 경우
      if currentStep == leftDown && nextStep == rightDown {
        return false
      }
    }
  }
  return true
}
```
<br>

## 4. display() 함수
### - 사다리 데이터 구조를 분석해서 문자열로 리턴한다.
### - 사다리 세로는 | 파이프 문자로 출력한다.
### - 한 줄 마지막 끝에는 줄바꿈 문자 \n을 붙여서 출력한다.
### - 출력은 analyze() 동작과 상관없이 동작한다.
```swift
func display() -> String {
    var result = ""
    for row in ladder {
        result += "|" // 각 행의 시작과 끝에 | 문자를 추가
        for column in row { // 각 발판 사이에 | 문자를 추가
            result += column + "|"
        }
        result += "\n" // 각 행의 끝에는 줄바꿈 문자 \n을 추가하여 출력
    }
    return result
}
```
<br>

## 5. 입력/출력
### 예시 1. reset() + display() 한 경우
```swift
reset()
print(display())
```
```swift
|   |   |   |   |
|   |   |   |   |
|   |   |   |   |
|   |   |   |   |
|   |   |   |   |
```
### 예시 2. reset() + randomFill() + display() 한 경우
```swift
reset()
randomFill()
print(display())
```
```swift
|---|/-/|   |---|
|---|/-/|\-\|/-/|
|---|   |/-/|\-\|
|\-\|/-/|\-\|\-\|
|---|\-\|/-/|   |
```
### 예시 3. reset() + randomFill() + analyze() false + display() 한 경우
```swift
reset()
randomFill()
let analyzeResult = analyze()
print("분석 결과: \(analyzeResult)")
print(display())
```
```swift
분석 결과: false
|/-/|   |/-/|\-\|
|/-/|---|   |\-\|
|---|\-\|   |---|
|---|\-\|---|/-/|
|   |---|/-/|/-/|
```
<br>

# 💡BasicTeamMission💡
## 목차
  ------ 미션 관련------
  * [팀원 소개](#팀원-소개)<br>
  * [요구사항 분석](#요구사항-분석)<br>
  * [설계](#설계)<br>
  * [요구사항 구현](#요구사항-구현)<br>
  * [pydot 기본 사용법](#pydot-기본-사용법)<br><br>

---- 🥳팀프로젝트의 묘미🥳----
  * [선택의 과정](#선택의-과정)<br>
  * [소감 및 느낀점](#소감-및-느낀점)
 
<br>

# 👫 팀원소개

|박재규[iOS]|이화진[iOS]|임형주[WEB]|윤상진[WEB]|
|:--:|:--:|:--:|:--:|
|<img src="https://gist.github.com/assets/97685264/82e6a115-f2e1-4797-b333-f26eee97dcd5" alt="재규" width="120" height="120">|<img src="https://gist.github.com/assets/97685264/bf40dfaf-e5f0-49b9-8f0d-21de1331fd74" alt="화진" width="120" height="120">|<img src="https://gist.github.com/assets/97685264/1910ce74-d294-45e7-9d90-ba02bab5f653" alt="형주" width="120" height="120">|<img src="https://gist.github.com/assets/97685264/2cfcd454-f936-4e7d-9a97-e53d638de6f6" alt="상진" width="120" height="120">|
| [Jeagu](https://github.com/Jaewift) | [Haena](https://github.com/boriiiborii) | [hjlim4u](https://github.com/hjlim4u) | [Sangjin Yoon](https://github.com/tkdwls4453 ) |

<br><br>
# 요구사항 분석
## 학습 목표
* graphviz 문법을 이해하고, dot 형식을 지원하는 그래프 생성 도구를 짝으로 함께 설계하는 것이 목표다.
* 코드를 구현하기 전에 무엇을 구현해야 하는가 이해도를 높이고 해결하려는 것에 집중한다.
  
<br><br>

## 기능요구사항

* 최소 2명 이상이 하나의 형식에 대해 도전하고 같이 학습하고 설계한다.
  * ``2명 이상``이라면 웹과 iOS를 분리해서 각자에 맞는 언어로 진행하는것이 좋을까?
    * ``팀프로젝트``라서 팀을 또 분리하는것은 옳지 않다고 판단하여, 모두가 사용할 수 있는 파이썬으로 진행하기로 하였다.
* 어떤 ``형식``을 기준으로 할 것인지 2명 이상이 함께 결정한다.
  * ``형식이 그래프 비즈의 형식을 말하는걸까?``
    * ``맞는거같음``
  * ``그래프 비즈 형식이 여러가지가 있나?``
    * 기능요구사항의 형식을 알려 주었으니 이 형식을 활용하여 적용시키라는 의미로 해석 했다.
* 프로그래밍 요구사항을 만족하는 그래프 생성 도구를 설계한다.
* 예시에 있는 구조와 속성, 이름 등이 바뀌어도 동작하도록 설계한다.
* 전달할 데이터 구조를 어떻게 표현할 것인가 결정한다.
* 설계 후에 구현을 해도 무방하지만 구현만 해서는 안된다.
* 구현하는 경우에 설계 결과물이 프로그래밍 결과물만큼 상세하거나 많아야 한다.
<br><br>

## 설계 결과 제출

* 해결하려는 문제와 동작 방식에 대해 이해한 내용을 요약한다.
* 설계는 데이터 구조와 데이터 흐름을 명시한 그림을 손으로 그린다.
* 손으로 그린 그림을 캡처해서 gist에 첨부한다.
* gist에 README.md 파일을 추가하고 설계 의도와 방향에 대해 간략하게 설명을 붙인다.
<br><br>

## 프로그래밍 요구사항

- [x] 다음과 같이 패키지 > 파일 > 타입 > 속성 단계별로 구성된 구조를 그래프로 데이터 구조를 넘기면 graphviz 출력 형식 문자열로 변환하는 프로그램을 작성한다.
  *  ``pydot의 graph.to_string()를 사용하기로 하였다.``

- [x] 패키지는 여러 파일을 포함한다.
- [x] 파일 하나에는 타입 하나를 포함한다.
- [x] 타입은 고유 이름과 여러 속성을 가진다.
- [x] 속성마다 특정 타입을 참조한다.
- [x] System 아래에는 Integer, String 타입이 이미 존재한다.
<br><br>

## 예상결과 및 동작예시

* 완벽하게 동일할 필요는 없고, 스타일이나 색상을 제외하고 필수 항목만 비슷하게 채우면 된다. 패키지 > 파일 > 타입 포함 관계를 볼 수 있으면 ``어떤`` 형식으로도 가능하다.
  * ``어떤 형식으로도 가능하다 >>  Product, Order타입은 예시일 뿐 다른 타입을 만들어도 된다고 이해했다.``
  * ``타입을 입력받으면 요구사항에 해당하는 코드를 dot코드로 변환하는 함수를 작성해야한다고 파악했다.``
  * ``함수의 입력과 출력은 이러한 형식을 띈다고 이해했다.``
```python
  //함수의 입력값 예시
  package Service

  Type Product {
    sku : String
    price : Int
    title : String
  }

  package Service

  Type Product {
    sku : String
    price : Int
    title : String
  }

  //함수의 출력값 예시
  digraph G {

   subgraph cluster_0 {
    style = tab;
    color=blue;
    label = "Service Package";
        subgraph cluster_1 {
            Product [shape=box style=filled color=cyan]
            sku;
            price;
            title;
            label = "Product.file";
            color=lightgrey;
        }
      
        subgraph cluster_2 {
            Order [shape=box style=filled color=cyan]
            orderId;
            product;
            label = "Order.file";
            color=lightgrey;
        }
    }
  
    subgraph cluster_9 {
        style = tab;
        label = "System Package";
        color=blue;
    
        subgraph cluster_10 {
            String [shape=box style=filled color=cyan]
            Int [shape=box style=filled color=cyan]
            label = "Source.file";
            color=lightgrey;
      }
    }
    
    sku -> String;
    price -> Int;
    title -> String;
    orderId -> String;
    product -> Product;
  }
  ```

<br><br>

# 설계
## 미션 접근
**패키지 > 파일 > 타입 > 속성 단계별로 구성된 구조를 그래프로 데이터 구조를 넘기면 `graphviz` 출력 형식 문자열로 변환하는 프로그램을 작성한다.**

처음 이 문장의 의미를 파악하는데 많은 시간이 걸렸다. **`graphviz` 는 그래프 이미지를 반환하는 거 아닌가?** 

``무슨 문자열을 반환하라는 거지?`` 이 부분을 해석하는데 시간이 걸렸다.

결론 데이터 구조에 맞는 그래프를 그릴 수 있는 **``graphviz 코드를 문자열로 반환하자!`` - 모두 동의**
<br><br>

## 그럼 graphviz 코드는 어떻게 만들어 낼까?
* 첫번째 접근, 데이터 구조를 입력 받아 **`graphviz`** 코드 형식에 맞게 문자열을 직접 생성하자!
  * 짧은 시간안에 규칙에 맞게 문자열을 조작하여 **`graphviz`** 코드를 직접 만드는 것이 가능할까? **`graphviz`** 관련 모듈을 이용하는 방법을 없을까?
* 두번째 접근, **`graphviz`** 모듈을 사용하면 그래프만 그릴 수 있는 것이 아닌 해당 그래프를 그릴 수 있는 **`graphviz`** 코드도 만들어 낼 수 있다는 것을 발견하였다. 
  * 외부 언어에 **`graphviz`** 모듈을 설치하고 입력된 데이터 구조에 따라 모듈을 통해 그래프를 만들어 내면 이를 코드로 추출하는 방법을 선택하였다.

<br><br>

## 데이터 구조를 어떻게 입력받고 해석하지? 
### 첫번째 접근
* 예시 형식의 텍스트 파일을 입력받아 문자열을 파싱하자!
  * 하지만 텍스트 파일을 입력받아 하나하나 파싱하는 것은 구현상 어려움이 있으며 ``텍스트 파일의 구조상 문제가 생기더라도 유저에게 피드백을 줄 방법이 없다``.
```python
package Service

Type Product {
    sku : String
    price : Int
    title : String
}

package Service

Type Order {
    orderId : String
    product : Product
}
```
<br><br>

### ✔ 두번째 접근
* ``실시간으로 데이터 구조에 맞게 사용자의 입력을 유도하자!``
  * 실시간으로 사용자의 입력을 받게 되면 잘못된 입력에 대해 바로 피드백을 주어 안전하게 그래프를 생성할 수 있다.
* **패키지 > 파일 > 타입 > 속성 단계로 사용자에게 정보를 입력받아 그래프를 생성한다.**
```python
추가할 패키지명을 입력하세요(패키지명 입력을 끝내려면 'exit'을 입력하세요): exit
추가된 패키지가 없습니다. 프로그램을 종료합니다.
➜  team01 python test.py
추가할 패키지명을 입력하세요(패키지명 입력을 끝내려면 'exit'을 입력하세요): System
System Package 에 들어갈 파일명을 입력하세요(파일명 입력을 끝내려면 'exit'을 입력하세요): Order
Order의 타입명을 입력하세요: Order
Order에 들어갈 속성명을 입력하세요(속성명 입력을 끝내려면 'exit'을 입력하세요): 
```

<br><br>

## 실행 흐름도
![KakaoTalk_Photo_2024-06-28-22-49-52](https://gist.github.com/assets/97685264/76331cb6-ae02-4b08-a9af-4accf14b83a0)

<br><br>

# 요구사항 구현
## 1. pydot 임포트

* pydot을 사용하기로 하였기 때문에 pydot을 임포트 시킨다.([pydot을 사용한 이유]((#외부-라이브러리pydot을-사용할지-여부)))
* pydot사용법은 [여기](#pydot-기본-사용법)를 클릭하세요.
```python
import pydot
```
<br><br>

## 2. 클래스 선언
* Property: 속성을 나타내는 클래스, 속성 이름(name)과 속성 타입(prop_Type)을 가진다.
* Type: 타입을 나타내는 클래스, 타입 이름(name)과 여러 속성(properties)을 가진다.
* File: 파일을 나타내는 클래스, 파일 이름(name)과 하나의 타입 객체(type_Obj)를 가진다.
* Package: 패키지를 나타내는 클래스, 패키지 이름(name)과 여러 파일(files)을 가진다.
```python
class Property:
    def __init__(self, name, prop_type):
        self.name = name
        self.prop_type = prop_type

class Type:
    def __init__(self, name, properties):
        self.name = name
        self.properties = properties

class File:
    def __init__(self, name, type_obj):
        self.name = name
        self.type_obj = type_obj

class Package:
    def __init__(self, name, files):
        self.name = name
        self.files = files
```

<br><br>

## 3. create_graph 함수
* graph = pydot.Dot(graph_type='digraph')
  * 유방향 그래프임으로 digraph타입을 지정하였다.
* System 패키지를 생성하고 String, Int 타입을 수동으로 추가
  * 미션 내용중 ``System 아래에는 Integer, String 타입이 이미 존재한다``을 참고하여 작업
* 사용자가 입력하는 패키지를 클러스터로 추가하고, 입력하는 파일을 서브클러스터로 추가
* 각 속성 노드와 속성이 참조하는 타입 간의 엣지를 추가
* 최종적으로 그래프를 Graphviz 형식 문자열로 변환하여 반환
```python
def create_graph(packages):
    graph = pydot.Dot(graph_type='digraph')

    system_package = pydot.Cluster('System Package', label='System Package', style='tab', color='blue')
    system_file = pydot.Cluster('System File', label='Source.file', style='filled', color='lightgrey')
    system_string = pydot.Node('String', shape='box', style='filled', color='cyan')
    system_int = pydot.Node('Int', shape='box', style='filled', color='cyan')
    system_file.add_node(system_string)
    system_file.add_node(system_int)
    system_package.add_subgraph(system_file)
    graph.add_subgraph(system_package)

    for package in packages:
        package_cluster = pydot.Cluster(package.name, label=f"{package.name} Package", style='tab', color='blue')
        for file in package.files:
            file_cluster = pydot.Cluster(file.name, label=file.name, style='filled', color='lightgrey')
            type_node = pydot.Node(file.type_obj.name, shape='box', style='filled', color='cyan')
            file_cluster.add_node(type_node)
            for prop in file.type_obj.properties:
                prop_node = pydot.Node(prop.name)
                file_cluster.add_node(prop_node)
                graph.add_edge(pydot.Edge(prop.name, prop.prop_type))
            package_cluster.add_subgraph(file_cluster)
        graph.add_subgraph(package_cluster)

    return graph.to_string()
```

<br><br>

## 4. get_user_input 함수
* 패키지 이름을 입력. ‘exit을 입력하면 입력을 종료. 입력이 끝나면 패키지 배열에 추가시킨다.
* 파일 이름을 입력. 'exit'을 입력하면 입력을 종료. 입력이 끝나면 파일 배열에 추가시킨다.
  * 파일은 하나 이상 존재해야하며, 생성을 하지 않을경우 ``Package 에는 하나 이상의 파일이 들어가야 합니다.`` 문구 후 재입력 받는다.
* 타입 이름을 입력하고, 속성 이름과 속성 타입을 입력받는다. 'exit'을 입력하면 속성 입력을 종료. 입력이 끝나면 속성 배열에 추가시킨다.
  * 입력받은 타입이 [유효한 타입](#유효타입-이란)인지 분기처리 한다.
    * 유효타입인 경우: 다음 챕터로 넘어간다.
    * 유효하지 않은 타입인 경우: 다시 입력하라는 문구를 띄우고, 다시 입력을 받는다.
* 입력받은 데이터를 바탕으로 Package 객체를 생성하여 반환한다.
```python
def get_user_input():
    packages = []
    types = {"Int", "String"}
    while True:
        package_name = input("추가할 패키지명을 입력하세요(패키지명 입력을 끝내려면 'exit'을 입력하세요): ")
        if package_name.lower() == 'exit':
            break

        files = []
        while True:
            file_name = input(package_name + " Package 에 들어갈 파일명을 입력하세요(파일명 입력을 끝내려면 'exit'을 입력하세요): ")
            if file_name.lower() == 'exit':
                if files.__len__() == 0:
                    print("Package 에는 하나 이상의 파일이 들어가야 합니다. ")
                    continue;
                break

            type_name = input(file_name + "의 타입명을 입력하세요: ")
            types.add(type_name);
            properties = []
            while True:
                property_name = input(file_name + "에 들어갈 속성명을 입력하세요(속성명 입력을 끝내려면 'exit'을 입력하세요): ")
                if property_name.lower() == 'exit':
                    break
                property_type = input(property_name + " 속성의 타입을 입력하세요: ")
                if property_type not in types:
                    print("존재하지 않는 타입입니다. 속성명 부터 다시 입력해주세요");
                    continue;
                properties.append(Property(property_name, property_type))
                type_obj = Type(type_name, properties)
            files.append(File(file_name+".file", type_obj))

        packages.append(Package(package_name, files))

    return packages
```

<br><br>

## 5. 실행 코드
```python
inputs = get_user_input()
graphviz_output = create_graph(inputs)
print(graphviz_output)
```
<br><br>

# 실행 결과
## 미션의 예제 동작시키기
성공
 ![IMG_D566F6A41509-1](https://gist.github.com/assets/97685264/2f166a27-3c89-4bdd-8120-f3d090cbb327)

<br><br>

## 임의로 동작시키기
### 설계
![IMG_AA418163BBE3-1](https://gist.github.com/assets/97685264/bcf91302-57eb-42a3-8a09-9bbf27c9e2ec)
### 결과
![IMG_7A6EF7C1E022-1](https://gist.github.com/assets/97685264/5c035753-6fdb-49a2-b494-f9fdf6ac5e66)

<br><br>

# pydot 기본 사용법
### 그래프 생성
* digraph은 'graph' 또는 'digraph'로 설정 가능
```python
pydot.Dot(graph_type='digraph')
```
<br>

### 그래프에 노드 추가
```python
graph.add_node(node)
```
<br>

### 그래프에 엣지 추가
```python
graph.add_edge(edge)
```
<br>

### 그래프를 PNG 파일로 저장
* 이번 미션에서는 PNG파일로 저장 기능이 없으므로 해당 문법은 사용하지 않았다.
```python
graph.write_png('filename.png')
```
<br>

### 새로운 노드 생성
```python
pydot.Node(name, **attributes)
```
<br>

### 두 노드 사이 엣지 생성
```python
pydot.Edge(node1, node2, **attributes)
```
<br><br>


# 선택의 과정

## 어떠한 코드로 진행할것인가?
### 파이썬으로 진행하였다.
iOS 2명과 Web 2명으로 이루어진 팀이라, 각자 전공하는 언어가 달랐음<br>
어떤 언어를 사용할지 선택해야하는데, 서로 언어가 다르다보니 조율의 필요성을 느낌<br>
* 파이썬
  * ``장점``: 모든 팀원이 조금씩은 접한 언어
  * ``단점``: 베이직 과정에서 파이썬을 쓰는것이 올바른가?
* 스위프트, 자바스크립트
  * ``최소 2명 이상``이 하나의 형식에 대해 도전하고 같이 학습하고 설계한다.라는 요구사항대로, 두명씩 나눠져서 주 전공 언어로 하는것이 어떤가?
    * ``장점``: 주 언어를 사용 할 수 있다.
    * ``단점``: 팀 프로젝트인데 팀에서도 인원을 나눠서 코드를 짜는것이 맞는가? 라는 생각이 들었다.
이번 미션은 ``팀프로젝트``인만큼 모두가 전공하는 언어는 아니지만, 서로 양보를 하여 ``파이썬``을 사용하는것이 좋겠다고 합의를 하였다. 

<br><br>

## 외부 라이브러리(pydot)을 사용할지 여부
### 사용하기로 하였다.
|pydot 찬성|pydot 반대|
|----------|---------|
|* 문자열만 반환해주면 되는 미션이라 모듈의 필요성을 못느끼겠다.<br>* 직접 구현하는것이 좋을것 같다. | * 비즈모듈은 해당 언어를 닷스트링으로 변환해주는 기능을 갖고있어 편리하다. <br>* 모듈을 지원하는데 모듈을 사용하는 방법도 익혀보자. 
|


미션 해결 시간이 짧은 점을 고려하여, pydot을 사용하고 모듈 사용법도 익혀보기로 하였다.
<br><br>

## 타입 정하기
System이 가지고 있는 타입도 아니고, 커스텀 한 타입도 아닐 경우<br>
1. 타입을 재입력 받자
2. 노드의 연결만 시키지 말자

두가지 중 한 가지를 선택해야 했다.<br>
프로그래밍 요구사항에서 "System 아래에는 Integer, String 타입이 이미 존재한다." 명시 후 Int와 String형만을 인풋의 예시로 작성하였기 때문에,<br>
``유효한 타입``을 정의하고, 유효 타입을 입력하지 않는다면, 재 입력을 받도록 설계하였다.<br>

### 유효타입 이란?
* System이 가지는 타입(String, Integer)
* 입력받은 타입 명 (해당 예시로는 Product, Order)

<br><br>

# 소감 및 느낀점
|이름|소감 및 느낀점|
|:--:|:--:|
|박재규(iOS)|문제를 이해하고 graphviz 문법을 이해하는 데에 오랜 시간이 걸렸지만 <br>완벽히 이해하고 난 후에는 문제를 막힘없이 풀 수 있었습니다. <br>하지만 작성한 코드에는 기본적인 기능만 제공하기 때문에, 실제 사용 환경에서는 더 많은 유효성 검사, 예외 처리, 그리고 사용자 편의성을 위한 추가 기능이 필요할 것이라고 생각합니다.<br>그리고 이번 처음 그룹미션을 하면서 문제를 이해하기 위해 팀원들 간의 소통과 지식공유가 이루어졌는데 그것이 무엇보다 도움이 되었던 것 같습니다.|
이화진(iOS)|이번 미션은 팀원들과 함께 하지 못했다면 과연 잘 마무리 지을 수 있었을까라는 생각이 듭니다. 첫 미션을 마주하고 어떤것부터 설계해야할지 막막했는데, 팀원들의 기발한 아이디어를 통하여 이런 문제를 이 방법으로도 접근 할 수 있구나. 라는 생각이 들었습니다. 이번 팀 미션은 모두가 열정적으로 참여하여 각자의 강점을 살려 지너지 효과를 내었던것 같아요.<br> 팀 미션은 개인 미션과 다르게 선택하는 부분에서 각자의 생각이 다양하기에 시간이 꽤나 걸렸지만, 이러한 선택의 과정마저도 학습의 기회가 되었다고 생각합니다. 모두들 수고하셨습니다 ☺️ |
임형주(WEB)| 문제를 해결하는 것보다 문제를 올바르게 정의하는게 정말 중요하다고 느꼈습니다. <br>팀원들과 소통을 하면서 어떤 문제를 해결해야 할지 더 명확해졌고 <br>문제 정의를 하다보니 어떻게 해결할지 방법에 대한 단서도 얻을 수 있었던 것 같습니다.|
윤상진(WEB)| 처음에는 문제를 이해하는 것조차 어려웠습니다. <br>하지만 팀원들과 조금씩 의견을 나누다 보니 점점 무엇을 해야 할지 명확해졌고, 문제를 해결할 수 있었습니다. <br>제한된 시간 안에 익숙하지 않은 언어를 분석하고 활용해야 했던 점이 쉽지 않았지만, 그 과정에서 많이 성장할 수 있었습니다. <br>무엇보다 팀원들과 함께 어려운 문제를 해결하기 위해 소통했던 것이 정말 재미있었습니다.|
<br>

# Mission6

# 스택 계산기 만들기 🧮
<br>

# - 기능요구사항
![1700731986654stack-register](https://gist.github.com/assets/106376249/2520d7b9-a969-447c-a742-a1359d2a384c)
### 1. 스택 내부 공간은 총 8칸만 존재합니다.
### 2. 레지스터는 A, B 두 개만 존재하며, ADD나 SUB 명령으로 계산하는 용도로 사용합니다. 레지스터나 스택 값은 모두 정수형을 기준으로 계산합니다.
```swift
private var registerA: Int?
private var registerB: Int?
```
<br>

# - 프로그래밍 요구사항
### 1. POPA 명령은 스택 메모리에서 값 하나를 꺼내서 A 레지스터로 복사합니다. 만약 스택에 꺼낼 값이 없으면 "EMPTY"를 출력합니다.
```swift
private func popA() {
  if Stack.isEmpty {
    result.append("EMPTY") // 스택이 비어있으면 "EMPTY" 출력
  } else {
    registerA = Stack.removeLast() // 스택에서 마지막값을 꺼내서 A 레지스터로 복사
  }
}
```
### 2. POPB 명령은 스택 메모리에서 값 하나를 꺼내서 B 레지스터로 복사합니다. 만약 스택에 꺼낼 값이 없으면 "EMPTY"를 출력합니다.
```swift
private func popB() {
  if Stack.isEmpty {
    result.append("EMPTY") // 스택이 비어있으면 "EMPTY" 출력
  } else {
    registerB = Stack.removeLast() // 스택에서 마지막값을 꺼내서 B 레지스터로 복사
  }
}
```
### 3. ADD 명령은 A와 B 레지스터 값을 더해서 스택에 PUSH합니다.
```swift
private func add() {
  // 레지스터 A나 B가 초기 상태로 값이 없으면, ADD, SUB, SWAP 연산을 수행할 수 없어서 "ERROR"를 출력
  guard let a = registerA, let b = registerB else {
    result.append("ERROR")
    return
  }
  push(num: a + b) // 값을 더해서 스택에 PUSH
}
```
### 4. SUB 명령은 A 레지스터 값에서 B 레지스터 값을 빼서 스택에 PUSH합니다.
```swift
private func sub() {
  // 레지스터 A나 B가 초기 상태로 값이 없으면, ADD, SUB, SWAP 연산을 수행할 수 없어서 "ERROR"를 출력
  guard let a = registerA, let b = registerB else {
    result.append("ERROR")
    return
  }
  push(num: a - b) // 값을 빼서 스택에 PUSH
}
```
### 5. PUSH0 명령은 스택에 0 값을 PUSH합니다.
### 6. PUSH1 명령은 스택에 1 값을 PUSH합니다.
### 7. PUSH2 명령은 스택에 2 값을 PUSH합니다.
```swift
private func push(num: Int) {
  if Stack.count >= 8 {
    result.append("OVERFLOW") // 8칸을 모두 채운 이후에는 "OVERFLOW"를 출력에 추가
  } else {
    Stack.append(num)
  }
}
```
### 8. SWAP 명령은 A 레지스터 값과 B 레지스터 값을 맞교환합니다.
```swift
private func swapRegisters() {
  // 레지스터 A나 B가 초기 상태로 값이 없으면, ADD, SUB, SWAP 연산을 수행할 수 없어서 "ERROR"를 출력
  guard let a = registerA, let b = registerB else {
    result.append("ERROR")
    return
  }
  // A 레지스터 값과 B 레지스터 값을 맞교환
  registerA = b
  registerB = a
}
```
### 9. PRINT 명령은 스택 마지막 값을 꺼내서 출력합니다. 이 때 스택은 하나 줄어듭니다. 만약 스택이 비어있으면 "EMPTY"를 출력에 추가합니다.
```swift
private func printLast() {
  if Stack.isEmpty {
    result.append("EMPTY") // // 스택이 비어있으면 "EMPTY" 출력
  } else {
    // 스택 마지막 값을 꺼내서 출력
    let num = Stack.removeLast()
    result.append("\(num)")
  }
}
```
<br>

# - 명령어 처리 함수 calculate()
```swift
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
      push(num: 0) // 스택에 0 값을 PUSH
    case "PUSH1":
      push(num: 1) // 스택에 1 값을 PUSH
    case "PUSH2":
      push(num: 2) // 스택에 2 값을 PUSH
    case "SWAP":
      swapRegisters()
    case "PRINT":
      printLast()
    default:
      result.append("UNKNOWN") // 입력한 명령 중에 처리할 수 없는 명령의 경우는 "UNKNOWN"을 출력
    }
  }
  return result
}
```
<br>

# - 입력/출력
```swift
let calculator = StackCalculator() // calculator 객체 생성

print("명령들을 띄어쓰기로 구분하여 입력하세요 ex) PUSH1 PUSH2 ADD PRINT:")
if let input = readLine() { 
  let commands = input.split(separator: " ").map { String($0) } // 명령어 입력
  let result = calculator.calculate(commands: commands)
  print(result.joined(separator: ", ")) // 결과 출력
}
```
<br>

## 예시 1
```swift
PRINT PUSH0 PRINT POPA
```
```swift
EMPTY, 0, EMPTY
```
### 처음 PRINT는 스택이 비어있으니 "EMPTY", 그 다음 PUSH0을 하고 PRINT하면 0을 출력합니다.
### 그 다음 POPA는 스택이 비어있으니 "EMPTY"를 출력합니다.
<br>

## 예시 2
```swift
PUSH1 PUSH1 PUSH2 POPA POPB SWAP ADD PRINT PRINT
```
```swift
3, 1
```
### 스택에 1, 1, 2 순서로 값을 넣고 POPA로 2를 꺼내서 A에 보관, 1을 꺼내서 B에 보관합니다.
### SWAP으로 A에 1, B에 2로 바뀌고 ADD로 1+2 = 3 값을 다시 스택에 넣고, PRINT로 꺼내서 3을 출력하고, 한 번 더 PRINT로 1을 꺼내서 출력합니다.
<br>

## 예시 3
```swift
PUSH2 PUSH2 PUSH1 POPA POPB SWAP SUB POPA POPB ADD PRINT
```
```swift
3
```
### 스택에 2, 2, 1 순서로 값을 넣고, POPA로 1을 꺼내서 A에 보관, POPB로 2를 꺼내서 B에 보관합니다.
### SWAP으로 A에 2로, B에 1로 바뀌고, SUB로 2-1 = 1 값을 다시 스택에 넣고, POPA로 1을 꺼내서 A에 보관, 2을 꺼내서 B에 보관합니다.
### ADD로 1+2 = 4 값을 스택에 넣고 PRINT로 꺼내서 3를 출력합니다.
<br>

## 예시 4
```swift
ADD PUSH2 PUSH1 PUSH0 PUSH2 PUSH1 PUSH2 PUSH2 PUSH0 PUSH2 PUSH3
```
```swift
ERROR, OVERFLOW, UNKNOWN
```
### 레지스터에 값이 없는 데 ADD는 실패해서 ERROR를 출력합니다.
### PUSH 명령을 9개 수행하면서 9번째 명령은 실패해서 OVERFLOW를 출력합니다.
### 마지막 PUSH3 명령은 수행하지 못하기 때문에 UNKNOWN을 출력합니다.
<br>

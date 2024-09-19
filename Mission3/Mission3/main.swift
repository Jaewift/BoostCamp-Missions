//
//  main.swift
//  Mission3
//
//  Created by jaegu park on 9/19/24.
//

import Foundation

struct Game {
    let name: String
    let discontinued: Bool
    let genre: String
    let rating: Double
    let maxPlayers: Int
    let startDate: Date
    let endDate: Date
}

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyyMM"

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

func find(param0: String, param1: Int) -> String {
    guard let findDate = dateFormatter.date(from: param0) else {
        return "Error"
    }
    
    let findGames = games.filter { result in
        return result.startDate <= findDate && result.endDate >= findDate && result.maxPlayers >= param1
    }.sorted { $0.rating > $1.rating }
    
    let resultGames = findGames.map { result in
        let name = result.discontinued ? "\(result.name)*(\(result.genre))" : "\(result.name)(\(result.genre))"
        return "\(name) \(result.rating)"
    }
    
    return resultGames.joined(separator: ", ")
}

print(find(param0: "198402", param1: 1))
print(find(param0: "200008", param1: 8))
print(find(param0: "199004", param1: 5))

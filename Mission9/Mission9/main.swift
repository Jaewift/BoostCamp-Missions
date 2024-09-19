//
//  main.swift
//  Mission9
//
//  Created by jaegu park on 9/19/24.
//

import Foundation

struct City: Hashable {
    let name: String
    let year: Int
    let latitude: Double
    let longitude: Double
    let population: Int
}

struct Cluster: Hashable, Equatable {
    
    static func == (lhs: Cluster, rhs: Cluster) -> Bool {
        return lhs.centroid == rhs.centroid && lhs.cities == rhs.cities
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(centroid.0)
        hasher.combine(centroid.1)
        hasher.combine(cities)
    }
    
    var cities: [City]
    var centroid: (Double, Double)
}

enum KmeansType {
    case pop
    case long
}

func getCities() -> [City] {
    return [
        City(name: "서울", year: 1946, latitude: 37.567, longitude: 126.978, population: 9720846),
        City(name: "부산", year: 1963, latitude: 35.18, longitude: 129.0756, population: 3413841),
        City(name: "인천", year: 1981, latitude: 37.456, longitude: 126.7052, population: 2938420),
        City(name: "대구", year: 1981, latitude: 35.871, longitude: 128.6014, population: 2414220),
        City(name: "대전", year: 1995, latitude: 36.35, longitude: 127.3845, population: 1475221),
        City(name: "광주", year: 1986, latitude: 35.16, longitude: 126.8526, population: 1454677),
        City(name: "울산", year: 1997, latitude: 35.538, longitude: 129.3114, population: 1159673),
        City(name: "세종", year: 2012, latitude: 36.488, longitude: 127.2816, population: 362259),
        City(name: "수원", year: 1949, latitude: 37.264, longitude: 127.0286, population: 1240374),
        City(name: "창원", year: 2010, latitude: 35.229, longitude: 128.6811, population: 1046188),
        City(name: "포항", year: 1949, latitude: 36.019, longitude: 129.3435, population: 511807),
        City(name: "전주", year: 1949, latitude: 35.824, longitude: 127.148, population: 658346),
        City(name: "청주", year: 1949, latitude: 36.642, longitude: 127.489, population: 847110),
        City(name: "제주", year: 1955, latitude: 33.5, longitude: 126.5312, population: 486306),
        City(name: "고양", year: 1992, latitude: 37.656, longitude: 126.835, population: 1075500),
        City(name: "용인", year: 1996, latitude: 37.241, longitude: 127.1776, population: 1081914),
        City(name: "천안", year: 1995, latitude: 36.815, longitude: 127.1139, population: 666417),
        City(name: "김해", year: 1995, latitude: 35.234, longitude: 128.8811, population: 559648),
        City(name: "평택", year: 1986, latitude: 36.992, longitude: 127.1122, population: 519075),
        City(name: "마산", year: 1949, latitude: 35.214, longitude: 128.5833, population: 424192),
        City(name: "군산", year: 1949, latitude: 35.967, longitude: 126.7364, population: 266569),
        City(name: "원주", year: 1955, latitude: 37.342, longitude: 127.9202, population: 364738),
        City(name: "의정부", year: 1963, latitude: 37.739, longitude: 127.0455, population: 442782),
        City(name: "김포", year: 1998, latitude: 37.624, longitude: 126.7145, population: 442453),
        City(name: "광명", year: 1981, latitude: 37.477, longitude: 126.8664, population: 345262),
        City(name: "춘천", year: 1995, latitude: 37.881, longitude: 127.7298, population: 285584),
        City(name: "안산", year: 1995, latitude: 36.79, longitude: 127.0049, population: 321355),
        City(name: "성남", year: 1973, latitude: 37.42, longitude: 127.1265, population: 944626),
        City(name: "구미", year: 1978, latitude: 36.12, longitude: 128.3446, population: 402607),
        City(name: "시흥", year: 1989, latitude: 37.38, longitude: 126.8031, population: 446420),
        City(name: "목포", year: 1949, latitude: 34.812, longitude: 126.3922, population: 238718),
        City(name: "익산", year: 1947, latitude: 35.948, longitude: 126.9577, population: 292524),
        City(name: "경주", year: 1955, latitude: 35.856, longitude: 129.2247, population: 257041),
        City(name: "의왕", year: 1986, latitude: 37.345, longitude: 126.9688, population: 157346),
        City(name: "부천", year: 1973, latitude: 37.499, longitude: 126.7831, population: 843794),
        City(name: "남양주", year: 1995, latitude: 37.637, longitude: 127.2143, population: 736287),
        City(name: "파주", year: 1997, latitude: 37.76, longitude: 126.7805, population: 453589),
        City(name: "거제", year: 1989, latitude: 34.881, longitude: 128.6216, population: 241253),
        City(name: "화성", year: 2001, latitude: 37.2, longitude: 126.831, population: 791057),
        City(name: "강릉", year: 1995, latitude: 37.752, longitude: 128.8761, population: 213658)
    ]
}

// K-Means 알고리즘
func kmeans(cities: [City], k: Int, type: KmeansType) -> [Cluster] {
    var clusters = [Cluster]()
    
    // 초기 클러스터 설정: 무작위로 K개의 도시를 선택하여 초기 중심점으로 설정
    for _ in 0..<k {
        let randomCity = cities.randomElement()!
        let centroid: (Double, Double)
        switch type {
        case .pop:
            centroid = (Double(randomCity.year), Double(randomCity.population))
        case .long:
            centroid = (Double(randomCity.year), randomCity.longitude)
        }
        clusters.append(Cluster(cities: [], centroid: centroid))
    }
    var isChanged = true
    
    // 중심점이 더 이상 변하지 않을 때까지 반복
    while isChanged {
        // 각 클러스터의 도시 리스트 초기화
        for i in 0..<clusters.count {
            clusters[i].cities.removeAll()
        }
        
        // 도시를 가장 가까운 클러스터에 할당
        switch type {
        case .pop:
            for city in cities {
                addCityToClosestClusterbyPop(clusters: &clusters, city: city)
            }
        case .long:
            for city in cities {
                addCityToClosestClusterByLon(clusters: &clusters, city: city)
            }
        }
        
        // 이전 중심점 저장
        let oldCentroids = clusters.map { $0.centroid }
        
        // 클러스터의 중심점 업데이트
        for i in 0..<clusters.count {
            clusters[i].centroid = calculateCenterpoint(cluster: clusters[i], type: type)
        }
        
        // 중심점이 변경되었는지 확인
        let newCentroids = clusters.map { $0.centroid }
        isChanged = !comparisonCenterPoints(oldCentroids, newCentroids)
    }
    return clusters
}

func kmeans_long(k: Int) -> [Cluster] {
    let cities = getCities()
    return kmeans(cities: cities, k: k, type: .long)
}

func kmeans_pop(k: Int) -> [Cluster] {
    let cities = getCities()
    return kmeans(cities: cities, k: k, type: .pop)
}

func addCityToClosestClusterbyPop(clusters: inout [Cluster], city: City) {
    var minDistance = Double.greatestFiniteMagnitude
    var closestClusterIndex = 0
    
    for (index, cluster) in clusters.enumerated() {
        let yearDifference = cluster.centroid.0 - Double(city.year)
        let populationDifference = cluster.centroid.1 - Double(city.population)
        let distance = sqrt(yearDifference * yearDifference + populationDifference * populationDifference)
        
        if distance < minDistance {
            minDistance = distance
            closestClusterIndex = index
        }
    }
    
    clusters[closestClusterIndex].cities.append(city)
}

func addCityToClosestClusterByLon(clusters: inout [Cluster], city: City) {
    var minDistance = Double.greatestFiniteMagnitude
    var closestClusterIndex = 0
    
    for (index, cluster) in clusters.enumerated() {
        let yearDifference = cluster.centroid.0 - Double(city.year)
        let longitudeDifference = cluster.centroid.1 - city.longitude
        let distance = sqrt(yearDifference * yearDifference + longitudeDifference * longitudeDifference)
        
        if distance < minDistance {
            minDistance = distance
            closestClusterIndex = index
        }
    }
    
    clusters[closestClusterIndex].cities.append(city)
}

func calculateCenterpoint(cluster: Cluster, type: KmeansType) -> (Double, Double) {
    let totalCities = cluster.cities.count
    let sumYear = cluster.cities.reduce(0) { $0 + $1.year }
    let centerX = Double(sumYear) / Double(totalCities)
    var centerY = 0.0
    
    switch type {
    case .pop:
        let sumPopulation = cluster.cities.reduce(0) { $0 + $1.population }
        centerY = Double(sumPopulation) / Double(totalCities)
    case .long:
        let sumLongitude = cluster.cities.reduce(0.0) { $0 + $1.longitude }
        centerY = sumLongitude / Double(totalCities)
    }
    
    return (centerX, centerY)
}

func comparisonCenterPoints(_ a: [(Double, Double)], _ b: [(Double, Double)]) -> Bool {
    for i in 0..<a.count {
        if a[i] != b[i] {
            return false
        }
    }
    return true
}

func printClusters(clusters: [Cluster]) {
    for (index, cluster) in clusters.enumerated() {
        print("그룹#\(index + 1) 중심값: \(cluster.centroid)")
        print("그룹#\(index + 1) 도시들: \(cluster.cities.map { $0.name })")
    }
}

printClusters(clusters: kmeans_pop(k: 2))
printClusters(clusters: kmeans_long(k: 4))

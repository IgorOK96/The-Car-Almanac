//
//  Networking.swift
//  The Car Almanac
//
//  Created by user246073 on 9/26/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL // User mistake
    case noData //net data
    case decodingError // not can compare keys JSON in model
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping(Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) {data, _, error in        //вход в фоно поток
            guard let data else {
                print(error ?? "No error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataModel = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataModel))}
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchCars(from url: URL, completion: @escaping (Result<[Car], NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error ?? "No error description")
                completion(.failure(.decodingError))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let cars = try decoder.decode([Car].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(cars))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}


//    private func fetchCars() {
//        networkManager.fetch([Car].self, from: linkCars) { [weak self] result in
//            switch result {
//            case .success(let fetchedCars):
//                self?.cars.append(contentsOf: fetchedCars)
//                print(fetchedCars)
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            case .failure(let error):
//                print("Error fetching cars: \(error)")
//            }
//        }
//    }

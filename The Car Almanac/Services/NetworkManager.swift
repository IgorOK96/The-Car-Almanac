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
}

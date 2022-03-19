//
//  NetworkManager.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 18.03.2022.
//

import UIKit

class NetworkManager {
    static let shared   = NetworkManager()
    private let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    let cache           = NSCache<NSString, UIImage>()
    let decoder         = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy  = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    
    func getGeneralPokemonData() async throws -> PokeNameURLModel {
        let endpoint = baseURL
        guard let url = URL(string: endpoint) else {
            throw MDTError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw MDTError.invalidResponse
        }
        
        do {
            let decodedData = try decoder.decode(PokeNameURLModel.self, from: data)
            return decodedData
        } catch {
            throw MDTError.invalidData
        }
    }
    
    
    func getPokemonStats(for url:String) async throws -> PokeStatsModel {
        let endpoint = url
        //print("running")
        guard let url = URL(string: endpoint) else {
            print("Error in url")
            throw MDTError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Error in response")
            throw MDTError.invalidResponse
        }
        
        do {
            let decodedData = try decoder.decode(PokeStatsModel.self, from: data)
            return decodedData
        } catch {
            print("Error, Invalid data")
            throw MDTError.invalidData
        }
    }
    
    

    
    
    func getPokemonStatsOldWay(for url: String, completed: @escaping (Result<PokeStatsModel, MDTError>) -> Void) {
            let endpoint = url

            guard let url = URL(string: endpoint) else {
                completed(.failure(.invalidURL))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in

                if let _ = error {
                    completed(.failure(.unableToComplete))
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completed(.failure(.invalidResponse))
                    return
                }

                guard let data = data else {
                    completed(.failure(.invalidData))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let retrievedStats = try decoder.decode(PokeStatsModel.self, from: data)
                    completed(.success(retrievedStats))
                } catch {
                    print(error)
                    completed(.failure(.invalidData))
                }
            }

            task.resume()
        }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image }
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }

    
}

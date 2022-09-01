//  Created by Eyup Selek on 18.03.2022.
//

import UIKit

class NetworkManager {
    static let shared   = NetworkManager()
    private let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    let cache           = NSCache<NSString, UIImage>()
    let decoder         = JSONDecoder()
    
    private init() {
        cache.countLimit = 100
        decoder.keyDecodingStrategy  = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    
    func getGeneralPokemonData(offset:Int?,limit:Int, url:String?) async throws -> PokeNameURLModel {
        var endpoint  = String()
        if let offset = offset {
            endpoint  = baseURL + "?offset=\(offset)&limit=\(limit)"
        }
        
        let isNextURLGiven = url != nil ? true : false
        if let nextURL = url {
            if isNextURLGiven {
                endpoint = nextURL
            }
        }
        
        guard let url = URL(string: endpoint) else {
            throw PBError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response   = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PBError.invalidResponse
        }
        
        do {
            let decodedData = try decoder.decode(PokeNameURLModel.self, from: data)
            return decodedData
        } catch {
            throw PBError.invalidData
        }
    }
    
    
    func getPokemonStats(for url:String) async throws -> PokeStatsModel {
        let endpoint = url
        
        guard let url = URL(string: endpoint) else {
            throw PBError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PBError.invalidResponse
        }
        
        do {
            let decodedData = try decoder.decode(PokeStatsModel.self, from: data)
            return decodedData
        } catch {
            throw PBError.invalidData
        }
    }
    
    func getPokemonStatsWithName(for name:String) async throws -> PokeStatsModel {
        let endpoint = baseURL + name
        
        guard let url = URL(string: endpoint) else {
            throw PBError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw PBError.invalidResponse
        }
        
        do {
            let decodedData = try decoder.decode(PokeStatsModel.self, from: data)
            return decodedData
        } catch {
            print("Error, Invalid data")
            throw PBError.invalidData
        }
    }
    
    
    func downloadImage(from urlString: String) async throws -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            return image
        }
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            print(error)
            throw PBError.errorDownloadingImage
        }
    }
}

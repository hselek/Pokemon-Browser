//
//  PokeStatsModel.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 18.03.2022.
//

import Foundation

struct PokeStatsModel:Decodable {
    let stats:[Stat]
    let sprites:Sprites
    let id:Int
    let name:String
    let order:Int
    
    struct Sprites:Decodable {
        let backDefault: String?
        let backFemale: String?
        let frontDefault: String?
    }
    
    struct Stat:Decodable {
        let baseStat: Int
        let effort: Int
        let stat: NameAndURL
        
        struct NameAndURL:Decodable {
            let name: String
            let url: String
        }
    }
}


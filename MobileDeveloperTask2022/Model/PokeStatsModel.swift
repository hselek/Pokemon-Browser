//  Created by Eyup Selek on 18.03.2022.
//

import Foundation

struct PokeStatsModel:Codable {
    let stats:[Stat]
    let sprites:Sprites
    let id:Int
    let name:String
    let order:Int
    
    struct Sprites:Codable {
        let backDefault: String?
        let backFemale: String?
        let frontDefault: String?
    }
    
    struct Stat:Codable {
        let baseStat: Int
        let effort: Int
        let stat: NameAndURL
        
        struct NameAndURL:Codable {
            let name: String
            let url: String
        }
    }
}


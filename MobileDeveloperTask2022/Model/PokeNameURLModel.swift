//  Created by Eyup Selek on 17.03.2022.
//

import Foundation

struct PokeNameURLModel:Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokeResult]
}

struct PokeResult:Codable {
    var name: String
    var url: String
}



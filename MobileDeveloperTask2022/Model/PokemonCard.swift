//  Created by Eyup Selek on 17.03.2022.
//

import UIKit

struct PokemonCard:Identifiable {
    var id: Int
    var order: Int
    var name: String
    var imageURL: String?
    var hp: Int?
    var attack: Int?
    var defense: Int?
    
    init(id:Int, order:Int, name:String) {
        self.id = id
        self.order = order
        self.name = name
    }
    
    init(id:Int, order:Int, name:String,imageURL:String, hp:Int, attack:Int, defense:Int) {
        self.id = id
        self.order = order
        self.name = name
        self.imageURL = imageURL
        self.hp = hp
        self.attack = attack
        self.defense = defense
    }
}


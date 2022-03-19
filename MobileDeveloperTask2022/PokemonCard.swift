//
//  PokemonCard.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 17.03.2022.
//

import UIKit

struct PokemonCard:Identifiable {
    var id: Int
    var name: String
    var image: UIImage?
    var imageURL: String?
    var detailURL: String
    var hp: Int?
    var attack: Int?
    var defense: Int?
    
   init(id:Int, name:String, url:String) {
        self.id = id
        self.name = name
        self.detailURL = url
    }
    
    init(id:Int,name:String,image:UIImage,detailURL:String,hp:Int,attack:Int,defense:Int) {
        self.id = id
        self.name = name
        self.image = image
        self.detailURL = detailURL
        self.hp = hp
        self.attack = attack
        self.defense = defense
    }
    
    
}


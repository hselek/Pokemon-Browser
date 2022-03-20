//
//  Constants.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 16.03.2022.
//

import Foundation
import UIKit

enum Images {
    static let placeholder = UIImage(named: "placeholder")
    static let tempPokemon = UIImage(named: "132")
}

struct Settings {
    static let shared = Settings()
    var activeDownloads = 0

    private init() { }
}

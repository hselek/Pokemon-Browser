//
//  MDTCardPokemonImageView.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class MDTCardPokemonImageView: UIImageView {
    
    let placeholderImage = Images.placeholder
    let tempPokemonImage = Images.tempPokemon

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        contentMode = .scaleAspectFit
        tintColor = .label
        clipsToBounds = true
        image = tempPokemonImage
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([heightAnchor.constraint(equalToConstant: 300),
                                     widthAnchor.constraint(equalToConstant: 300)])
    }
    
}

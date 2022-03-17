//
//  MDTCardView.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class MDTCardView: UIView {
    let cardNameLabel = MDTCardNameLabel(textAlignment: .center, fontSize: 22)
    let pokemonImage = MDTCardPokemonImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    let pokemonHPView = MDTCardPokemonStatsView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
    let pokemonAttackView = MDTCardPokemonStatsView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
    let pokemonDefenseView = MDTCardPokemonStatsView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
    
    let verticalStackView = UIStackView()
    let horizontalStackView = UIStackView()
    let mainVerticalStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(cardNameLabel)
        addSubview(pokemonImage)
        
        addSubview(pokemonHPView)
        addSubview(pokemonAttackView)
        addSubview(pokemonDefenseView)
        cardNameLabel.text = "Deneme"
        pokemonHPView.set(pokemonStatsType: .hp, value: 50)
        pokemonAttackView.set(pokemonStatsType: .attack, value: 90)
        pokemonDefenseView.set(pokemonStatsType: .defense, value: 150)
       
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = CGFloat(30)
        clipsToBounds = true
        addToVerticalStackView()
        addToHorizontalStackView()
        addToMainVerticalStackView()
        
        NSLayoutConstraint.activate([
            cardNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainVerticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    func addToVerticalStackView() {
        verticalStackView.axis  = NSLayoutConstraint.Axis.vertical
        verticalStackView.distribution  = UIStackView.Distribution.fill
        verticalStackView.alignment = UIStackView.Alignment.center
        verticalStackView.spacing   = 0
        verticalStackView.addArrangedSubview(cardNameLabel)
        verticalStackView.addArrangedSubview(pokemonImage)
        //verticalStackView.addArrangedSubview(horizontalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(verticalStackView)
    }
    
    func addToHorizontalStackView() {
        horizontalStackView.axis  = NSLayoutConstraint.Axis.horizontal
        horizontalStackView.distribution  = UIStackView.Distribution.fill
        horizontalStackView.alignment = UIStackView.Alignment.center
        horizontalStackView.spacing   = 20
        horizontalStackView.addArrangedSubview(pokemonHPView)
        horizontalStackView.addArrangedSubview(pokemonAttackView)
        horizontalStackView.addArrangedSubview(pokemonDefenseView)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalStackView)
    }
    
    func addToMainVerticalStackView() {
        mainVerticalStackView.axis  = NSLayoutConstraint.Axis.vertical
        mainVerticalStackView.distribution  = UIStackView.Distribution.fill
        mainVerticalStackView.alignment = UIStackView.Alignment.center
        mainVerticalStackView.spacing   = 0
        mainVerticalStackView.addArrangedSubview(verticalStackView)
        mainVerticalStackView.addArrangedSubview(horizontalStackView)
        
        
        mainVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainVerticalStackView)
    }
}

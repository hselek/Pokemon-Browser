//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class PBCardView: UIView {
    let cardNameLabel      = PBCardNameLabel(textAlignment: .center, fontSize: 22)
    let pokemonImage       = PBCardPokemonImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    let pokemonHPView      = PBCardPokemonStatsView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
    let pokemonAttackView  = PBCardPokemonStatsView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
    let pokemonDefenseView = PBCardPokemonStatsView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
    
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
        
        backgroundColor    = .white
        layer.cornerRadius = DeviceTypes.isiPad ? 60 : 30    //(30)
        clipsToBounds      = true
        
        addToHorizontalStackView()
        addToVerticalStackView()
        addToMainVerticalStackView()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainVerticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainVerticalStackView.topAnchor.constraint(equalTo: self.topAnchor,constant: 20),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    private func addToVerticalStackView() {
       // verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis          = NSLayoutConstraint.Axis.vertical
        verticalStackView.distribution  = UIStackView.Distribution.fill
        verticalStackView.alignment     = UIStackView.Alignment.center
        verticalStackView.spacing       = 0
        verticalStackView.addArrangedSubview(cardNameLabel)
        verticalStackView.addArrangedSubview(pokemonImage)
        
        
        addSubview(verticalStackView)
    }
    
    private func addToHorizontalStackView() {
        //horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        let adaptiveDistribution:UIStackView.Distribution = DeviceTypes.isiPad ? .fillEqually : .fill
        let adaptiveSpacing:CGFloat = DeviceTypes.isiPad ? 75 : 20
        horizontalStackView.axis          = .horizontal
        horizontalStackView.distribution  =  adaptiveDistribution
        horizontalStackView.alignment     = .center
        horizontalStackView.spacing       = adaptiveSpacing
        horizontalStackView.addArrangedSubview(pokemonHPView)
        horizontalStackView.addArrangedSubview(pokemonAttackView)
        horizontalStackView.addArrangedSubview(pokemonDefenseView)
        
        addSubview(horizontalStackView)
    }
    
    private func addToMainVerticalStackView() {
        mainVerticalStackView.axis          = NSLayoutConstraint.Axis.vertical
        mainVerticalStackView.distribution  = UIStackView.Distribution.fill
        mainVerticalStackView.alignment     = UIStackView.Alignment.center
        mainVerticalStackView.spacing       = 0
        mainVerticalStackView.addArrangedSubview(verticalStackView)
        mainVerticalStackView.addArrangedSubview(horizontalStackView)
        mainVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainVerticalStackView)
    }
    
    func updateCard(name:String,imageURL:String,hp:Int,attack:Int,defense:Int) {
        DispatchQueue.main.async {
            self.cardNameLabel.text = name
            self.pokemonImage.downloadImage(fromURL: imageURL)
            self.pokemonHPView.set(pokemonStatsType: .hp, value: hp)
            self.pokemonAttackView.set(pokemonStatsType: .attack, value: attack)
            self.pokemonDefenseView.set(pokemonStatsType: .defense, value: defense)
        }
    }
}

//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class PBCardPokemonStatsView: UIView {
    
    enum PokemonStatsType {
        case hp,attack,defense
    }
    
    let statNameLabel  = PBCardPokemonStatsLabel(textAlignment: .center, fontSize: 24, fontWeight: .regular)
    let statValueLabel = PBCardPokemonStatsLabel(textAlignment: .center, fontSize: 33, fontWeight: .bold)
    
    
    let verticalStackView   = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(statNameLabel)
        addSubview(statValueLabel)
        addToVerticalStackView()
        addSubview(verticalStackView)
        statNameLabel.text = "hp"
        translatesAutoresizingMaskIntoConstraints = false
        
       NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    func set(pokemonStatsType:PokemonStatsType, value:Int) {
        switch pokemonStatsType {
        case .hp:
            statNameLabel.text  = "hp"
            statValueLabel.text = String(value)
        case .attack:
            statNameLabel.text  = "attack"
            statValueLabel.text = String(value)
        case .defense:
            statNameLabel.text  = "defense"
            statValueLabel.text = String(value)
        }
    }
    
    
    func addToVerticalStackView() {
        verticalStackView.axis          = NSLayoutConstraint.Axis.vertical
        verticalStackView.distribution  = UIStackView.Distribution.fill
        verticalStackView.alignment     = UIStackView.Alignment.center
        verticalStackView.spacing       = 20
        verticalStackView.addArrangedSubview(statNameLabel)
        verticalStackView.addArrangedSubview(statValueLabel)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    }
}

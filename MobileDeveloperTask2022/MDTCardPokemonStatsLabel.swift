//
//  MDTCardPokemonStatsLabel.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class MDTCardPokemonStatsLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment:NSTextAlignment,fontSize:CGFloat,fontWeight:UIFont.Weight) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize,weight: fontWeight)
    }
    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}

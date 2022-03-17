//
//  MDTButton.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class MDTRestartButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        configuration = .plain()
        configuration?.cornerStyle = .medium
        set(foregroundColor: .white)
        let config = UIImage.SymbolConfiguration(textStyle: .largeTitle, scale: .large)
        configuration?.image = UIImage(systemName: "arrow.clockwise.circle.fill",withConfiguration: config)?.withRenderingMode(.automatic)
    }
    
    final func set(foregroundColor:UIColor) {
        configuration?.baseForegroundColor = foregroundColor
    }
}

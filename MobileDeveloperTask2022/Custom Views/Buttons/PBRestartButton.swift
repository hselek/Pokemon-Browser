//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class PBRestartButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        configuration              = .plain()
        configuration?.cornerStyle = .medium
        set(foregroundColor: .white)
        let normalConfig           = UIImage.SymbolConfiguration(textStyle: .largeTitle, scale: .large)
        let ipadConfig             = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let configToUse            = DeviceTypes.isiPad ? ipadConfig : normalConfig
        configuration?.image       = UIImage(systemName: "arrow.clockwise.circle.fill",withConfiguration: configToUse)?.withRenderingMode(.automatic)
    }
    
    final func set(foregroundColor:UIColor) {
        configuration?.baseForegroundColor = foregroundColor
    }
}

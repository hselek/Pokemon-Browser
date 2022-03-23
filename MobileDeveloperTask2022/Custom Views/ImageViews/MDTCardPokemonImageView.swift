//
//  MDTCardPokemonImageView.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class MDTCardPokemonImageView: UIImageView {
    
    let placeholderImage = Images.placeholder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 10
        contentMode        = .scaleAspectFill
        tintColor          = .label
        clipsToBounds      = true
        image              = nil
        translatesAutoresizingMaskIntoConstraints = false
        
        let heightAnchorConstraintConstant:CGFloat =  DeviceTypes.isiPad ? 300 : 300
        let widthAnchorConstraintConstant: CGFloat =  DeviceTypes.isiPad ? 300 : 300
        
        NSLayoutConstraint.activate([heightAnchor.constraint(equalToConstant: heightAnchorConstraintConstant),
                                     widthAnchor.constraint(equalToConstant:  widthAnchorConstraintConstant)])
    }
    
    
    func downloadImage(fromURL url: String) {
        Task {
            do {
                image = try await NetworkManager.shared.downloadImage(from: url) ?? placeholderImage
            } catch {
                print(error)
                throw MDTError.errorDownloadingImage
            }
        }
    }
    
}

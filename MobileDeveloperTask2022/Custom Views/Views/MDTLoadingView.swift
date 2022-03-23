//
//  MDTLoadingView.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 20.03.2022.
//

import UIKit

class MDTLoadingView: UIView {
    let loadingLabel = MDTLoadingLabel(textAlignment: .center, fontSize: 24)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor    = .systemBackground
        layer.cornerRadius =  DeviceTypes.isiPad ? 60 : 30
        loadingLabel.text  = "Loading..."
        loadingLabel.font  = UIFont.systemFont(ofSize: 24, weight: .regular)
        addSubview(loadingLabel)
        NSLayoutConstraint.activate([loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     loadingLabel.centerYAnchor.constraint(equalTo: centerYAnchor)])
     
    }
}

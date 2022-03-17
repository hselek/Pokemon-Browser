//
//  ViewController.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var cardView: MDTCardView!
    let restartButton = MDTRestartButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor (red: 168.0/255.0, green: 160.0/255.0, blue: 248/255.0, alpha: 1.0)
        cardView = MDTCardView()
        configureRestartButton()
        configureCardView()
    }
    
    
    @objc func restartButtonPressed() {
        print("Restart button pressed")
    }
    
    func configureCardView() {
        view.addSubview(cardView)
        NSLayoutConstraint.activate([cardView.widthAnchor.constraint(equalToConstant: 300),
                                     cardView.heightAnchor.constraint(equalToConstant: 500),
                                     cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    func configureRestartButton() {
        view.addSubview(restartButton)
        restartButton.addTarget(self, action: #selector(restartButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            restartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            restartButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            restartButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
}


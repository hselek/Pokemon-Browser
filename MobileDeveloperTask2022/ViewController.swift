//
//  ViewController.swift
//  MobileDeveloperTask2022
//
//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var cardView:UIView!
    var cardFront: MDTCardView!
    var cardBack: MDTCardView!
    var loadingView:MDTLoadingView!
    let restartButton = MDTRestartButton()
    
    var pokemonData:PokeNameURLModel!
    var pokeDetails:PokeStatsModel!
    var pokeDetailsArray = [PokeStatsModel]()
    var pokemonCards = [PokemonCard]()
    
    var pokemonImage:UIImage!
    var cardIndex = 0
    var offset = 1
    var limit = 10
    var activeRequests = NetworkManager.shared.activeDownloads
    private var isFlipped: Bool = false
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor (red: 168.0/255.0, green: 160.0/255.0, blue: 248/255.0, alpha: 1.0)
        pokemonCards.removeAll()
        cardFront = MDTCardView()
        cardBack = MDTCardView()
        configureRestartButton()
        getGeneralPokemonData(offset: 0, limit: limit)
        configureCardView()
        configureLoadingView()
        showLoadingView()
        addtapGestureRecognizer()
        
    }
    
    
    func configureLoadingView() {
        loadingView = MDTLoadingView(frame: cardFront.frame)
        view.addSubview(loadingView)
        loadingView.isHidden = true
        NSLayoutConstraint.activate([loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     loadingView.heightAnchor.constraint(equalTo: cardFront.heightAnchor),
                                     loadingView.widthAnchor.constraint(equalTo: cardFront.widthAnchor)])
    }
    
    func showLoadingView() {
        cardFront.isHidden = true
        loadingView?.isHidden = false
        restartButton.isEnabled = false
    }
    
    func hideLoadingView() {
        if pokemonCards.count > 9 {
            cardFront.isHidden = false
        }
        restartButton.isEnabled = true
        loadingView?.isHidden = true
    }
    
    func getGeneralPokemonData(offset:Int,limit:Int) {
        activeRequests += 1
        showLoadingView()
        
        print("Active Requests \(activeRequests)")
        Task {
            do {
                let generalPokemonData = try await NetworkManager.shared.getGeneralPokemonData(offset: offset, limit: limit)
                updateUI(with: generalPokemonData)
                if activeRequests >= 1 {
                    activeRequests -= 1
                    print("Active Requests \(activeRequests)")
                } else {
                    hideLoadingView()
                }
            } catch {
                if let mdtError = error as? MDTError {
                    //  presentGFAlert(title: "Bad Stuff Happend", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    //   presentDefaultError()
                }
                hideLoadingView()
            }
        }
        print("Active Requests \(activeRequests)")
    }
    
    func getPokeStatsData(id:Int, for url:String) {
        activeRequests += 1
        if activeRequests > 0 {
            showLoadingView()
        }
        
        print("Active Requests \(activeRequests)")
        Task {
            do {
                let pokeStatsData = try await NetworkManager.shared.getPokemonStats(for: url)
                updateUIP(id: id, with: pokeStatsData)
                if activeRequests >= 1 {
                    activeRequests -= 1
                    print("Active Requests \(activeRequests)")
                }else {
                    hideLoadingView()
                }
            } catch {
                if let mdtError = error as? MDTError {
                    print(error)
                    //  presentGFAlert(title: "Bad Stuff Happend", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    print(error)
                    //   presentDefaultError()
                }
               hideLoadingView()
            }
            
        }
    }
    
    func downloadImage(id:Int, url:String) {
        activeRequests += 1
        if activeRequests > 0 {
            showLoadingView()
        }
        print("Active Image Download Requests \(activeRequests)")
        Task {
            pokemonImage = await NetworkManager.shared.downloadImage(from: url) ?? Images.placeholder!
            addImageToPokemonCards(id: id, image: pokemonImage)
        }
        
    }
    
    
    func makePokemonCard(id: Int, name: String, url: String) {
        let pokemonCard = PokemonCard(id: id, name: name, url: url)
        pokemonCards.append(pokemonCard)
    }
    
    func addStatsToPokemonCard(id: Int, hp: Int, attack: Int, defense: Int, imageURL:String) {
        if pokemonCards.count > 0 {
            pokemonCards[id].hp = hp
            pokemonCards[id].attack = attack
            pokemonCards[id].defense = defense
            pokemonCards[id].imageURL = imageURL
            downloadImage(id: id, url: imageURL)
        }
        
        if pokemonCards.count-1 == id {
            //print("Buldum")
            updateCardUI()
        }
        
    }
    
    func addImageToPokemonCards(id:Int, image:UIImage) {
        if pokemonCards.count > 0 {
            self.pokemonCards[id].image = image
            self.activeRequests -= 1
            print("Active Image Download Requests \(activeRequests)")
            if activeRequests == 0 {
                hideLoadingView()
            }
        }
    }
    
    
    func updateUI(with generalPokemonData: PokeNameURLModel) {
        if let previousData = generalPokemonData.previous {
            var idToContinue = pokemonCards.last!.id + 1
            self.pokemonData.results.append(contentsOf: generalPokemonData.results)
           // print("New count " + "\(pokemonData.results.count)")
           // print(previousData)
            for pokemon in generalPokemonData.results {
                makePokemonCard(id: idToContinue, name: pokemon.name, url: pokemon.url)
                idToContinue += 1
            }
            for pokemonCard in pokemonCards {
                getPokeStatsData(id: pokemonCard.id, for: pokemonCard.detailURL)
            }
            
        }else {
            //Means we do not have previous data therefore we will start from 0.
            self.pokemonData = generalPokemonData
            if pokemonCards.count == 0 {
                for pokemon in generalPokemonData.results.enumerated() {
                    makePokemonCard(id: pokemon.offset, name: pokemon.element.name, url: pokemon.element.url)
                }
                for pokemonCard in pokemonCards {
                    getPokeStatsData(id: pokemonCard.id, for: pokemonCard.detailURL)
                }
            }
        }
    }
    
    func updateUIP(id:Int, with stat: PokeStatsModel) {
        self.pokeDetails = stat
        
        let currentStat = stat.stats
        guard let imageURL = stat.sprites.frontDefault else {return}
        
        let hp = currentStat[0].baseStat
        let attack = currentStat[1].baseStat
        let defense = currentStat[2].baseStat
        
        addStatsToPokemonCard(id: id, hp: hp, attack: attack, defense: defense, imageURL: imageURL)
    }
    
    
    
    func addtapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cardFront.addGestureRecognizer(tap)
        cardFront.isUserInteractionEnabled = true
    }
    
    func updateCardUI() {
        let card = pokemonCards[cardIndex]
        guard let hp = card.hp else {return}
        guard let attack = card.attack else {return}
        guard let defense = card.defense else {return}
        guard let imageURL = card.imageURL else {return}
        DispatchQueue.main.async {
            self.cardFront.updateCard(name: card.name, imageURL: imageURL, hp: hp, attack: attack, defense: defense)
        }
        
    }
    
    // - MARK: TAP
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let totalPokemonCount = self.pokemonData.count
        cardIndex += 1
        offset += 1
        if cardIndex < pokemonCards.count-1 {
            self.updateCardUI()
        }else {
            if cardIndex == pokemonCards.count-1 {
                getGeneralPokemonData(offset: offset, limit: limit)
            }
        }
       // print(pokemonCards)
        
        //deneme()
    }
    
    @objc func restartButtonPressed()  {
        print("Restart button pressed")
        isFlipped = !isFlipped
        let cardToFlip = isFlipped ? cardFront : cardBack
        let bottomCard = isFlipped ? cardBack : cardFront
        cardIndex = 0
        updateCardUI()
        
    }
    
    func deneme() {
        
        var rotationAndPerspectiveTransform = CATransform3DIdentity
        rotationAndPerspectiveTransform.m34 = 1.0 / -500.0;
        
        
        let card1HorizontalD0 = CATransform3DRotate(rotationAndPerspectiveTransform, 0, 0, 0, 0)
        
        let card1HorizontalD1 = CATransform3DRotate(rotationAndPerspectiveTransform, 4, 0, -6, 1)
        
        let card1HorizontalD2 = CATransform3DRotate(rotationAndPerspectiveTransform, 11, 0, 73, -1)
        
        let card1HorizontalD3 = CATransform3DRotate(rotationAndPerspectiveTransform, 13, 0, 99.8, -0.8)
        
        // rotationAndPerspectiveTransform = card1HorizontalD0
        
        let card2HorizontalD0 = CATransform3DRotate(rotationAndPerspectiveTransform, 13, 0, 99.8, -0.8)
        
        let card2HorizontalD1 = CATransform3DRotate(rotationAndPerspectiveTransform, 19, 0, 180, 0)
        
        let card2HorizontalD2 = CATransform3DRotate(rotationAndPerspectiveTransform, 22, 0, 185, 0)
        
        let card2HorizontalD3 = CATransform3DRotate(rotationAndPerspectiveTransform, 25, 0, 180, 0)
        self.cardFront.layer.isDoubleSided = false
        self.cardBack.layer.isDoubleSided = false
        
        
        UIView.animateKeyframes(withDuration: 5, delay: 0, options: .calculationModeCubic) {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                self.cardFront.layer.transform = card1HorizontalD0
                self.cardBack.layer.transform = card2HorizontalD0
            }
            
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.cardFront.layer.transform = card1HorizontalD1
                self.cardBack.layer.transform = card2HorizontalD1
                
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.25) {
                self.cardFront.layer.transform = card1HorizontalD2
                self.cardBack.layer.transform = card2HorizontalD2
                
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                self.cardFront.layer.transform = card1HorizontalD3
                self.cardBack.layer.transform = card2HorizontalD3
                
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.95, relativeDuration: 0.2) {
                self.cardFront.layer.transform = card1HorizontalD0
                self.cardBack.layer.transform = card2HorizontalD0
                
            }
        } completion: { completed in
            
        }
        
        
        /*    UIView.animateKeyframes(withDuration: 5, delay: 0, options: .calculationModeCubic, animations: {
         
         
         }
         
         )*/
        
        
        /* UIView.animate(withDuration: 1.0) {
         // self.cardBack.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
         self.cardBack.layer.transform = rotationAndPerspectiveTransform
         } completion: { finished in
         print("Flip completed")
         }*/
        
    }
    
    func configureCardView() {
        cardBack.isHidden = true
        view.addSubview(cardFront)
        view.addSubview(cardBack)
        
        NSLayoutConstraint.activate([cardFront.widthAnchor.constraint(equalToConstant: 300),
                                     cardFront.heightAnchor.constraint(equalToConstant: 500),
                                     cardFront.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     cardFront.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        NSLayoutConstraint.activate([cardBack.widthAnchor.constraint(equalToConstant: 300),
                                     cardBack.heightAnchor.constraint(equalToConstant: 500),
                                     cardBack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     cardBack.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
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



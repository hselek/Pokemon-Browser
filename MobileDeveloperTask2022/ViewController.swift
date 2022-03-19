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
    var pokemonData:PokeNameURLModel!
    var pokeDetails:PokeStatsModel!
    var pokeDetailsArray = [PokeStatsModel]()
    var pokemonImage:UIImage!
    var pokemonCards = [PokemonCard]()
    var nextID = 0
    private var isFlipped: Bool = false
    
    let restartButton = MDTRestartButton()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor (red: 168.0/255.0, green: 160.0/255.0, blue: 248/255.0, alpha: 1.0)
        
        cardFront = MDTCardView()
        cardBack = MDTCardView()
        configureRestartButton()
        
        
        getGeneralPokemonData()
        getPokeStatsData(id: 0, for: "https://pokeapi.co/api/v2/pokemon/1/")
       
        
       
      //  oldway()
        
        configureCardView()
    }
    
    
    func getGeneralPokemonData() {
        Task {
            do {
                let generalPokemonData = try await NetworkManager.shared.getGeneralPokemonData()
                updateUI(with: generalPokemonData)
                
                
               // print(generalPokemonData.results.first?.name)
              //  dismissLoadingView()
            } catch {
                if let mdtError = error as? MDTError {
                  //  presentGFAlert(title: "Bad Stuff Happend", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                 //   presentDefaultError()
                }
            }
        }
    }
    
    func getPokeStatsData(id:Int, for url:String) {
        Task {
            do {
                let pokeStatsData = try await NetworkManager.shared.getPokemonStats(for: url)
                updateUIP(id: id, with: pokeStatsData)
                
               // print(generalPokemonData.results.first?.name)
              //  dismissLoadingView()
            } catch {
                if let mdtError = error as? MDTError {
                    print(error)
                  //  presentGFAlert(title: "Bad Stuff Happend", message: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    print(error)
                 //   presentDefaultError()
                }
            }
        }
    }
    
    func downloadImage(id:Int, url:String) {
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
            let card = pokemonCards[nextID]
            guard let hp = card.hp else {return}
            guard let attack = card.attack else {return}
            guard let defense = card.defense else {return}
            guard let imageURL = card.imageURL else {return}
            cardFront.updateCard(name:card.name , imageURL: imageURL, hp: hp, attack: attack, defense: defense)
        }
            
    }
    
    func addImageToPokemonCards(id:Int, image:UIImage) {
        if pokemonCards.count > 0 {
        self.pokemonCards[id].image = image
        }
       /* for pokemonCard in pokemonCards {
            print(pokemonCard)
        }*/
    }
    
    
    func updateUI(with generalPokemonData: PokeNameURLModel) {
       // if generalPokemonData.count < 100 { self.hasMoreFollowers = false }
        self.pokemonData = generalPokemonData
        for pokemon in generalPokemonData.results.enumerated() {
            print(pokemon.offset)
            print(pokemon.element.name)
            print(pokemon.element.url)
            
           makePokemonCard(id: pokemon.offset, name: pokemon.element.name, url: pokemon.element.url)
        }
        for pokemonCard in pokemonCards {
            getPokeStatsData(id: pokemonCard.id, for: pokemonCard.detailURL)
        }
   
        

    //   self.cardFront.updateCard(name: pokemonData.results.first!.name, image: Images.tempPokemon!, hp: 10, attack: 20, defense: 30)
        
       // cardBack.updateCard(name: "Deneme2", image: Images.placeholder!, hp: 150, attack: 200, defense: 250)
    }
    
    func updateUIP(id:Int, with stat: PokeStatsModel) {
       // if generalPokemonData.count < 100 { self.hasMoreFollowers = false }
        self.pokeDetails = stat
       // print("Stats \(stat)")
       // print(pokeDetails)
        let currentStat = stat.stats
        guard let imageURL = stat.sprites.frontDefault else {return}
      //  print("Image url is:\(imageURL)")
        
        let hp = currentStat[0].baseStat
        let attack = currentStat[1].baseStat
        let defense = currentStat[2].baseStat
        
        addStatsToPokemonCard(id: id, hp: hp, attack: attack, defense: defense, imageURL: imageURL)
        
       // self.cardFront.updateCard(name: pokemonData.results[id].name, imageURL: imageURL, hp: hp, attack: attack, defense: defense)
        
        
      //  cardBack.updateCard(name: "Deneme2", image: Images.placeholder!, hp: 150, attack: 200, defense: 250)
    }
    
    
    
    
    
    
    @objc func restartButtonPressed()  {
        print("Restart button pressed")
        isFlipped = !isFlipped
        let cardToFlip = isFlipped ? cardFront : cardBack
        let bottomCard = isFlipped ? cardBack : cardFront

        
      // deneme()
        if nextID < pokemonCards.count-1 {
        nextID += 1
        }else {
            nextID = 0
        }
        print(pokemonCards)
         let card = pokemonCards[nextID]
        guard let hp = card.hp else {return}
        guard let attack = card.attack else {return}
        guard let defense = card.defense else {return}
        guard let imageURL = card.imageURL else {return}
        
        self.cardFront.updateCard(name: card.name, imageURL: imageURL, hp: hp, attack: attack, defense: defense)
       
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
        
       

        UIView.animateKeyframes(withDuration: 5, delay: 0, options: .calculationModeCubic, animations: {
           
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
            
        })
        
        
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



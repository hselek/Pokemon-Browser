//  Created by Eyup Selek on 16.03.2022.
//

import UIKit

class CardVC: UIViewController {
    
    var restartButton: PBRestartButton!
    var cardContainerView: UIView!
    var cardFront:PBCardView!
    var singleCard:PBCardView!
    var loadingView:PBLoadingView!
    var pokemonData:PokeNameURLModel!
    var pokeDetails:PokeStatsModel!
    var pokeDetailsArray        = [PokeStatsModel]()
    var pokemonCards            = [PokemonCard]()
    var tapGestureRecognizer    = UITapGestureRecognizer()
    var apiReportedPokemonCount = Int()
    var nextURL                 = String()
    var cardIndex               = 0
    var offset                  = 0
    var limit                   = 20
    var activeRequests          = 0 {
        didSet {
            if activeRequests > 0 || pokemonCards.count == 0 {
                showLoadingView()
            }else {
                hideLoadingView()
                updateCardUI()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle   = .light
        view.backgroundColor         = Colors.customBackgroundColor
        
        pokemonCards.removeAll()
        cardFront      = PBCardView()
        singleCard     = PBCardView()
        restartButton  = PBRestartButton()
        configureRestartButton()
        getGeneralPokemonData(offset: offset, limit: limit, url: nil)
        configureCardContainerView()
        configureCardView()
        configureLoadingView()
        showLoadingView()
        addTapGestureRecognizer()
    }
    
    
    func checkActiveRequestsAndDecrement() {
        if activeRequests >= 1 {
            activeRequests -= 1
        }
    }
    
    
    func checkActiveRequestsAndIncrement() {
        activeRequests += 1
        if activeRequests > 0 {
            showLoadingView()
        }
    }
    
    
    func getGeneralPokemonData(offset:Int?,limit:Int,url:String?) {
        checkActiveRequestsAndIncrement()
        Task {
            do {
                let generalPokemonData = try await NetworkManager.shared.getGeneralPokemonData(offset: offset, limit: limit, url: url)
                updateUI(with: generalPokemonData)
                checkActiveRequestsAndDecrement()
            } catch {
                if let pbError = error as? PBError {
                    presentPBAlert(title: "Something Went Wrong", message: pbError.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultError()
                }
                checkActiveRequestsAndDecrement()
            }
        }
    }
    
    
    func getPokemonStatsWithName(for name:String) {
        checkActiveRequestsAndIncrement()
        Task {
            do {
                let pokemonStatsData = try await NetworkManager.shared.getPokemonStatsWithName(for: name)
                updatePokemonStatsWith(data:pokemonStatsData)
                checkActiveRequestsAndDecrement()
            } catch {
                if let pbError = error as? PBError {
                    presentPBAlert(title: "Something Went Wrong", message: pbError.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultError()
                }
                checkActiveRequestsAndDecrement()
            }
        }
    }
    
    
    func downloadImage(id:Int, url:String) {
        checkActiveRequestsAndIncrement()
        Task {
            do {
                _ = try await NetworkManager.shared.downloadImage(from: url)
                checkActiveRequestsAndDecrement()
            } catch {
                if let pbError = error as? PBError {
                    presentPBAlert(title: "Something Went Wrong", message: pbError.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultError()
                }
                checkActiveRequestsAndDecrement()
            }
        }
    }
    
    
    func createPokemonCard(id:Int, order:Int, name:String,imageURL:String, hp:Int, attack:Int, defense:Int) {
        let pokemonCard = PokemonCard(id: id, order: order, name: name, imageURL: imageURL, hp: hp, attack: attack, defense: defense)
        self.pokemonCards.append(pokemonCard)
        self.pokemonCards.sort {
            $0.id < $1.id
        }
    }
    
    //@MainActor is a singleton actor whose executor is equivalent to the main dispatch queue so DispatchQueue.main.async is not needed
    @MainActor
    func updateUI(with generalPokemonData: PokeNameURLModel) {
        self.apiReportedPokemonCount = generalPokemonData.count
        if let nextURL   = generalPokemonData.next {
            self.nextURL = nextURL
        }
        
        for result in generalPokemonData.results {
            getPokemonStatsWithName(for: result.name)
        }
    }
    
    
    func updatePokemonStatsWith(data:PokeStatsModel) {
        let id      = data.id
        let order   = data.order
        let name    = data.name
        let hp      = data.stats[0].baseStat
        let attack  = data.stats[1].baseStat
        let defense = data.stats[2].baseStat
        guard let imageURL = data.sprites.frontDefault else {return}
        downloadImage(id: id, url: imageURL) //The image will be downloaded to the cache.
        
        createPokemonCard(id: id, order: order, name: name, imageURL: imageURL, hp: hp, attack: attack, defense: defense)
    }
    
    
    func addTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        singleCard.addGestureRecognizer(tapGestureRecognizer)
        singleCard.isUserInteractionEnabled = true
    }
    
    
    // - MARK: UpdateCardUI
    func updateCardUI() {
        let card           = pokemonCards[cardIndex]
        guard let hp       = card.hp else {return}
        guard let attack   = card.attack else {return}
        guard let defense  = card.defense else {return}
        guard let imageURL = card.imageURL else {return}
        
        self.singleCard.updateCard(name: card.name.firstUppercased, imageURL: imageURL, hp: hp, attack: attack, defense: defense)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if cardIndex + 2 >= self.pokemonCards.count-1 {
            getGeneralPokemonData(offset: nil, limit: limit, url: nextURL)
            
            updateCardUI()
        }
        if cardIndex < self.apiReportedPokemonCount-1 && cardIndex < self.pokemonCards.count-1 {
            cardIndex += 1
            updateCardUI()
        }
    }
    
    
    @objc func restartButtonPressed()  {
        cardIndex = 0
        updateCardUI()
    }
    
    
    func configureCardContainerView() {
        let widthAnchorConstant:  CGFloat = DeviceTypes.isiPad ? 570 : 300
        let heightAnchorConstant: CGFloat = DeviceTypes.isiPad ? 475 : 500
        cardContainerView = UIView(frame: cardFront.frame)
        view.addSubview(cardContainerView)
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.cardFront.layer.isDoubleSided = false
       
        
        NSLayoutConstraint.activate([cardContainerView.widthAnchor.constraint(equalToConstant: widthAnchorConstant),
                                     cardContainerView.heightAnchor.constraint(equalToConstant: heightAnchorConstant),
                                     cardContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     cardContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    
    func configureCardView() {
        let widthAnchorConstant:  CGFloat = DeviceTypes.isiPad ? 570 : 300
        let heightAnchorConstant: CGFloat = DeviceTypes.isiPad ? 475 : 500
        
        self.view.addSubview(singleCard)
        NSLayoutConstraint.activate([singleCard.widthAnchor.constraint(equalToConstant: widthAnchorConstant),
                                     singleCard.heightAnchor.constraint(equalToConstant: heightAnchorConstant),
                                     singleCard.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor),
                                     singleCard.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor)])
    }
    
    func configureRestartButton() {
        let widthAnchorConstant:  CGFloat = DeviceTypes.isiPad ? 50 : 50
        let heightAnchorConstant: CGFloat = DeviceTypes.isiPad ? 50 : 50
        let topAnchorConstant:    CGFloat = DeviceTypes.isiPad ? 25 : 5
        let leadingAnchorConstant:CGFloat = DeviceTypes.isiPad ? 20 : 15
        
        view.addSubview(restartButton)
        restartButton.addTarget(self, action: #selector(restartButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            restartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topAnchorConstant),
            restartButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingAnchorConstant),
            restartButton.heightAnchor.constraint(equalToConstant: heightAnchorConstant),
            restartButton.widthAnchor.constraint(equalToConstant: widthAnchorConstant)
        ])
    }
    
    
    func configureLoadingView() {
        loadingView = PBLoadingView(frame: cardContainerView.frame)
        view.addSubview(loadingView)
        loadingView.isHidden = true
        NSLayoutConstraint.activate([loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     loadingView.heightAnchor.constraint(equalTo: cardContainerView.heightAnchor),
                                     loadingView.widthAnchor.constraint(equalTo: cardContainerView.widthAnchor)])
    }
    
    
    func showLoadingView() {
        tapGestureRecognizer.isEnabled = false
        cardFront.isHidden             = true
        loadingView?.isHidden          = false
        restartButton.isEnabled        = false
    }
    
    
    func hideLoadingView() {
        tapGestureRecognizer.isEnabled = true
        cardFront.isHidden             = false
        loadingView?.isHidden          = true
        restartButton.isEnabled        = true
    }
    
}

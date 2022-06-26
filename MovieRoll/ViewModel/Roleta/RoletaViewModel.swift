//
//  RoletaViewModel.swift
//  MovieRoll
//
//  Created by Artur Franca on 04/06/22.
//

import Foundation

protocol RoletaViewModelDelegate {
    func carregaFilme(movie: Movie)
    func estrelaVazia(tag: Int)
    func estrelaCheia(tag: Int)
    func botaoGeneroSelecionado(tag: Int)
    func botaoGeneroSemSelecao(tag: Int)
    func exibirAlerta()
}

class RoletaViewModel {
    //MARK: - Variaveis
    
    var delegate: RoletaViewModelDelegate?
    private let service = Service.shared
    private let coreDataService: CoreDataService = .init()
    
    private var anos: [[String]] = [
        [
            "De:"
        ],
        [
            "2022",
            "2021",
            "2020",
            "2015",
            "2010",
            "2005",
            "2000",
            "1995",
            "1990",
            "1980",
            "1970",
            "1960",
            "1950",
            "1940",
            "1930"
        ],
        [
            "Até:"
        ],
        [
            "2022",
            "2021",
            "2020",
            "2015",
            "2010",
            "2005",
            "2000",
            "1995",
            "1990",
            "1980",
            "1970",
            "1960",
            "1950",
            "1940",
            "1930"
        ]
    ]
    
    private var notasFiltrosEstrela = 0.0
    private var dataInicial = "1930"
    private var dataFinal = "2022"
    private var generosFiltro: [String] = []
    
    //MARK: - Variaveis computadas
    var getPlataformas: [Int] {
        return service.plataformas
    }
    
    var numberOfItems: Int {
        return service.plataformas.count
    }
    
    var numberComponents: Int {
        return anos.count
    }
    
    //MARK: -  Variaveis Computadas Privadas
    
    private var yearLte: String {
        return "\(dataFinal)-12-31"
    }
    
    private var yearGte: String {
        return "\(dataInicial)-01-01"
    }
    
    private var average: String {
        return String(notasFiltrosEstrela)
    }
    //MARK: - Funções Públicas
    func getImagePlataformas(index: Int) -> String {
        return String(service.plataformas[index])
    }
    
    func numberOfRows(component: Int) -> Int {
        return anos[component].count
    }
    
    func titleForRow(row: Int, component: Int) -> String {
        return anos[component][row]
    }
    
    func getTitleForTextField(row: Int, componente: Int) -> String {
        if componente == 1 {
            dataInicial = anos[componente][row]
        } else if componente == 3 {
            dataFinal = anos[componente][row]
        }
        return "De \(dataInicial) Até \(dataFinal)"
    }
    
    func botaoRoletarMovie() {
        service.fetchDiscover(genre: genres(), average,  yearLte, yearGte, provider: providers()) { movies in
            if movies.count == 0 {
                DispatchQueue.main.async {
                    self.delegate?.exibirAlerta()
                    return
                }
            }
            guard let movie = movies.randomElement() else { return }
            self.service.getImageFromUrl(movie: movie) { image in
                movie.posterImage = image
                self.service.fetchProvidersBy(id: movie.id) { providerId in
                    DispatchQueue.main.async {
                        movie.providersId.append(contentsOf: providerId)
                        self.coreDataService.adicionarFilmeRoletadoCoreData(movie: movie)
                        self.delegate?.carregaFilme(movie: movie)
                    }
                }
            }
        }
    }
    
    func limparFiltroDaData() {
        dataInicial = "1930"
        dataFinal = "2022"
    }
    
    func generoPressionado(_ genero: String?, alpha: Float, tag: Int) {
        guard let genero = genero else { return }
        if alpha == 1 {
            generosFiltro.append(genero)
            delegate?.botaoGeneroSelecionado(tag: tag)
        } else {
            generosFiltro.removeAll { generoFiltro in
                return genero == generoFiltro
            }
            delegate?.botaoGeneroSemSelecao(tag: tag)
        }
    }
    
    func estrelaNotaPressionada(_ tag: Int) {
        for index in 0...4 {
            if index > tag {
                delegate?.estrelaVazia(tag: index)
                
            } else {
                delegate?.estrelaCheia(tag: index)
            }
        }
        notasFiltrosEstrela = Double(tag) * 1.875
    }
    
    func adicionaPlataformaFiltro(indexPath: IndexPath) {
        let plataforma = service.plataformas[indexPath.item]
        service.plataformaFiltro.append(plataforma)
    }
    
    func removePlataformaFiltro(indexPath: IndexPath) {
        let plataforma = service.plataformas[indexPath.item]
        service.plataformaFiltro.removeAll { plataformaFiltro in
            return  plataforma == plataformaFiltro
        }
    }
    
    func verificaFavorito(movie: Movie) -> Bool {
        return coreDataService.pegarListaDeFavoritosNoCoreData().contains { favorito in
            movie.id == favorito.id
        }
    }
    
    func verificaAssistido(movie: Movie) -> Bool {
        return coreDataService.pegarListaDeAssistidosNoCoreData().contains { assistido in
            movie.id == assistido.id
        }
    }
    //MARK: -  Funções Privadas
    
    private func genres() -> String {
        var idGenre = ""
        
        for genero in generosFiltro {
            switch genero {
            case "Ação": idGenre += "%7C28"
            case "Aventura": idGenre += "%7C12"
            case "Comédia": idGenre += "%7C35"
            case "Drama": idGenre += "%7C18"
            case "Suspense": idGenre += "%7C53"
            case "Ficção": idGenre += "%7C878"
            case "Família": idGenre += "%7C10751"
            case "Romance": idGenre += "%7C10749"
            case "Terror": idGenre += "%7C27"
            default: idGenre = ""
            }
        }
        if idGenre.count > 0 {
            idGenre =  String(idGenre.dropFirst(3))
        }
        return idGenre
    }
    
    private func providers() -> String {
        var idProvider = "350%7C337%7C307%7C384%7C8%7C531%7C119%7C619%7C227"
        
        if service.plataformaFiltro.count > 0 {
            idProvider = ""
            for provider in service.plataformaFiltro {
                idProvider += "%7C\(provider)"
            }
            idProvider =  String(idProvider.dropFirst(3))
        }
        return idProvider
    }
}

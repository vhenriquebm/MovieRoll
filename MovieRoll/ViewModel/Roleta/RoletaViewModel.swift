//
//  RoletaViewModel.swift
//  MovieRoll
//
//  Created by Artur Franca on 04/06/22.
//

import Foundation

protocol RoletaViewModelDelegate {
    func estrelaVazia(tag: Int)
    func estrelaCheia(tag: Int)
    func botaoSelecionado(tag: Int)
    func botaoSemSelecao(tag: Int)
    func exibirAlerta()
}

class RoletaViewModel {
    
    private let service = Service.shared
    
    var delegate: RoletaViewModelDelegate?
    
    private var anos: [[String]] = [
        [
            "De:"
        ],
        [
            "2022",
            "2021",
            "2020",
            "2010",
            "2000",
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
            "2010",
            "2000",
            "1990",
            "1980",
            "1970",
            "1960",
            "1950",
            "1940",
            "1930"
        ]
    ]
    
    private var notasFiltrosEstrela = 0
    
    private var generosFiltro: [String] = []
    private var plataformaFiltro: [String] = []
    private var dataInicial = "1930"
    private var dataFinal = "2022"
    
    
    var getPlataformas: [String] {
        return service.plataformas
    }
    
    var numberOfItems: Int {
        return service.plataformas.count
    }
    
    func getImage(index: Int) -> String {
        return service.plataformas[index]
    }
    
    var numberComponents: Int {
        return anos.count
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
    
    func limparAnos(){
        dataInicial = "1930"
        dataFinal = "2022"
    }
    
    func roletaFilmeFiltrado() -> Filme {
        var filme: Filme?
        var filmesFiltrados: [Filme] = filmesQueSeraoRoletados()
        
        if generosFiltro.count > 0 {
            let filmeFiltradoGenero = filtraPorGenero(generos: generosFiltro, filmes: filmesFiltrados)
            filmesFiltrados = filmeFiltradoGenero
        }
        
        if notasFiltrosEstrela > 0 {
            let filmeFiltradoNota = filtrarPorNota(nota: notasFiltrosEstrela, filmes: filmesFiltrados)
            filmesFiltrados = filmeFiltradoNota
        }
        if dataInicial > anos[1].last ?? "" || dataFinal < anos[3].first ?? ""{
            let filmeFiltradoData = filtrarPorData(dataInicial: dataInicial, dataFinal: dataFinal, filmes: filmesFiltrados)
            filmesFiltrados = filmeFiltradoData
        }
        if plataformaFiltro.count > 0 {
            let filmeFiltradoPlataforma = filtraPorPlataforma(plataformas: plataformaFiltro, filmes: filmesFiltrados)
            filmesFiltrados = filmeFiltradoPlataforma
        }
        
        filme = filmesFiltrados.randomElement()
        
        if filme == nil {
            delegate?.exibirAlerta()
        }
        
        return filme ?? service.filmeNil
    }
    
    private func filtrarPorData(dataInicial: String, dataFinal: String, filmes: [Filme]) -> [Filme] {
        let filmesData = filmes.filter { filmesData in
            filmesData.ano >= dataInicial && filmesData.ano <= dataFinal
        }
        return filmesData
    }
    
    private func filtrarPorNota(nota: Int, filmes: [Filme]) -> [Filme] {
        let filmesNota = filmes.filter { filmesNota in
            filmesNota.nota >= notasFiltrosEstrela
        }
        return filmesNota
    }
    
    private func filtraPorGenero(generos: [String], filmes: [Filme]) -> [Filme] {
        var filme: [Filme] = []
        
        for genero in generos {
            let filmesFiltrados = filmes.filter { filme in
                filme.genero == genero
            }
            filme.append(contentsOf: filmesFiltrados)
        }
        return filme
    }
    
    private func filtraPorPlataforma(plataformas: [String], filmes: [Filme]) -> [Filme]{
        var filme: [Filme] = []
        
        for plataforma in plataformas {
            let filmesFiltradosPlataforma = filmes.filter { filme in
                filme.plataforma == plataforma
            }
            filme.append(contentsOf: filmesFiltradosPlataforma)
        }
        return filme
    }
    
    func estrelaNotaPressionada(_ tag: Int) {
        for index in 0...4 {
            if index > tag {
                delegate?.estrelaVazia(tag: index)
                
            } else {
                delegate?.estrelaCheia(tag: index)
            }
        }
        notasFiltrosEstrela = tag * 2
    }
    
    func generoPressionado(_ genero: String?, alpha: Float, tag: Int) {
        guard let genero = genero else { return }
        if alpha == 1 {
            generosFiltro.append(genero)
            delegate?.botaoSelecionado(tag: tag)
        } else {
            generosFiltro.removeAll { generoFiltro in
                return genero == generoFiltro
            }
            delegate?.botaoSemSelecao(tag: tag)
        }
    }
    
    func adicionaPlataformaFiltro(indexPath: IndexPath) {
        let plataforma = service.plataformas[indexPath.item]
        plataformaFiltro.append(plataforma)
    }
    
    func removePlataformaFiltro(indexPath: IndexPath) {
        let plataforma = service.plataformas[indexPath.item]
        plataformaFiltro.removeAll { plataformaFiltro in
            return  plataforma == plataformaFiltro
        }
    }

    func verificaFavorito(filme: Filme) -> Bool {
        return service.filmesFavoritos.contains { filmeFavorito in
            filme.nome == filmeFavorito.nome
        }
    }
    
    func verificaAssistido(filme: Filme) -> Bool {
        return service.filmesAssistidos.contains { filmeFavorito in
            filme.nome == filmeFavorito.nome
        }
    }
    
    func adicionarListaFilmesRoletados(filme: Filme?) {
        guard let filme = filme else { return }
        
        if filme.nome != "" {
            service.filmesRoletados.append(filme)
        }
    }
    
    private func filmesQueSeraoRoletados() -> [Filme] {
        var filmesARoletar = service.filmes
        
        for roletado in service.filmesRoletados {
            filmesARoletar.removeAll { filme in
                roletado.nome == filme.nome
            }
        }
       
        
            
        return filmesARoletar
    }
        
//        if service.filmesRoletados.count == 0 {
//            filmesARoletar = service.filmes
//        } else {
//            for filmeARoletar in service.filmes {
//                for roletado in service.filmesRoletados {
//                    if filmeARoletar.nome != roletado.nome {
//                        filmesARoletar.append(filmeARoletar)
//                    }
//                }
//            }
//        }
//        return filmesARoletar
//    }
}

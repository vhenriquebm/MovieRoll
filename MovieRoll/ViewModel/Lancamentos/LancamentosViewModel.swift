//
//  LancamentosTableViewModel.swift
//  MovieRoll
//
//  Created by Raul Felippe on 04/06/22.
//

import Foundation

class LancamentosViewModel {
    
    let service: Service
    var filmes: [Filme] = []
    var generos: [String] = []
    
    init(service: Service = Service() ){
        self.service = service
        
    }
    
    var numberOfSection: Int {
        return generos.count
    }
    
    func pegarFilmesEGeneros() {
        filmes = service.filmes
        generos = service.generos
    }
    
    
    func numberOfItems(section: Int) -> Int {
        //fazer filtro de genero
        //        let filmesFiltrado = service.filmes.filter { filmes in
        //            service.generos[section]
        //        }
        
        let filmesFiltrado = filmes
        
        return filmesFiltrado.count
    }
    
    func retornaTitulo(section: Int) -> String {
        return generos[section]
    }
    
    func retornaFilmes(index: Int) -> Filme {
        
        return filmes[index]
    }
    
//    func getCellViewModel(index: Int) -> UmLancamentoCollectionViewModel {
//        let filme = filmes[index]
//
//        let cellViewModel = UmLancamentoCollectionViewModel(filme: filme)
//
//        return cellViewModel
//    }
    
    
}
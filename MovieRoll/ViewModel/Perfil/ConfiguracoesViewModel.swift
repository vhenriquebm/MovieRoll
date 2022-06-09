//
//  ConfiguracoesViewModel.swift
//  MovieRoll
//
//  Created by Renato Yoshinari on 06/06/22.
//

import Foundation

protocol ConfiguracoesViewModelDelegate {
    func exibeAlertaRoletado()
    func exibeAlertaFavorito()
    func exibeAlertaAssistido()
    func exibeAlertaDesconectar()
}

class ConfiguracoesViewModel {
    var delegate: ConfiguracoesViewModelDelegate?
    
    func resetarRoletadosButton() {
        delegate?.exibeAlertaRoletado()
    }
    
    func resetarFavoritosButton() {
        delegate?.exibeAlertaFavorito()
    }
    
    func resetarAssistidosButton() {
        delegate?.exibeAlertaAssistido()
    }
    func desconectarContaButton() {
        delegate?.exibeAlertaDesconectar()
    }
    
    func resetarFilmesRoletados() {
        Service.shared.filmesRoletados.removeAll()
    }
    
    func resetarFilmesFavoritos() {
        Service.shared.filmesFavoritos.removeAll()
    }
    
    func resetarFilmesAssistidos() {
        Service.shared.filmesAssistidos.removeAll()
    }
    
    func desconectarConta() {
        
    }
}

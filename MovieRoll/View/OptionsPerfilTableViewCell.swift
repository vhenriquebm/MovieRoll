//
//  OptionsPerfilTableViewCell.swift
//  MovieRoll
//
//  Created by Renato Yoshinari on 03/06/22.
//

import UIKit

class OptionsPerfilTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOptions: UIImageView!
    @IBOutlet weak var tituloOptionsLabel: UILabel!
    @IBOutlet weak var subtitleOptionsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupOptionCell(viewModel: OptionsPerfilTableViewCellViewModel ) {
        imageOptions.image = UIImage(systemName: viewModel.getImage)
        imageOptions.layer.cornerRadius = 5
        imageOptions.layer.borderWidth = 0.2
        tituloOptionsLabel.text = viewModel.getTitulo
        subtitleOptionsLabel.text = viewModel.getSubtitulo
    }
}
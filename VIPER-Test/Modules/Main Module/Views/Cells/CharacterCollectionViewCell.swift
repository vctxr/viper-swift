//
//  CharacterCollectionViewCell.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "characterCell"
    
    @IBOutlet var characterImageView: AsyncLoadedImageView!
    @IBOutlet var characterNameLabel: UILabel!
    @IBOutlet var gradientView: UIView!
    
    private let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func configure(with character: RickAndMortyCharacter) {
        if let url = URL(string: character.image) {
            characterImageView.loadImage(from: url)
        }
        characterNameLabel.text = character.name
    }
}


// MARK: - Setups
extension CharacterCollectionViewCell {
    
    private func setGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.5).cgColor]
        gradientLayer.locations = [0, 1]
        gradientView.layer.addSublayer(gradientLayer)
    }
}

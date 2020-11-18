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
        setBorder()
        setGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Border color doesnt change automatically when switching light/dark mode. Need to change manually
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.systemGray6.cgColor
        }
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
    
    private func setBorder() {
        layer.borderColor = UIColor.systemGray6.cgColor
        layer.borderWidth = 1
    }
    
    private func setGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.5).cgColor]
        gradientLayer.locations = [0, 1]
        gradientView.layer.addSublayer(gradientLayer)
    }
}

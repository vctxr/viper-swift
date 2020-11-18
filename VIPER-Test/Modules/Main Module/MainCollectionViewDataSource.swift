//
//  MainCollectionViewDataSource.swift
//  VIPER-Test
//
//  Created by Victor Samuel Cuaca on 18/11/20.
//

import UIKit

struct MainCollectionViewDataSource {
    
    let entity: MainEntity
    
    /// The number of items of the character
    var numberOfItems: Int {
        return entity.characters.count
    }
    
    func cellForItem(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let character = entity.characters[safe: indexPath.row],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as? CharacterCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.configure(with: character)
        return cell
    }
    
    func footerView(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterActivityIndicatorCollectionReusableView.identifier, for: indexPath) as? FooterActivityIndicatorCollectionReusableView
        else { return UICollectionReusableView() }
        
        return footer
    }
}

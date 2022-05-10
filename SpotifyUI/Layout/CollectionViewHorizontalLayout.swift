//
//  CollectionViewHorizontalLayout.swift
//  SpotifyUI
//
//  Created by Gerry Gao on 10/5/2022.
//

import UIKit

class CollectionViewHorizontalLayout: UICollectionViewCompositionalLayout {
    
    override init(section: NSCollectionLayoutSection) {
        super.init(section: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

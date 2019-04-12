//
//  AddCellAnimation.swift
//  CSGOFloat
//
//  Created by Tomas Martins on 05/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import UIKit

class AddCellAnimation: UICollectionViewFlowLayout {
    var insertingIndexPath = [IndexPath]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertingIndexPath.removeAll()
        
        guard let cv = collectionView else { return }
        
        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate,
                update.updateAction == .insert {
                insertingIndexPath.append(indexPath)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertingIndexPath.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItem(
        at itemIndexPath: IndexPath
        ) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        if insertingIndexPath.contains(itemIndexPath) {
            attributes?.alpha = 0.0
            attributes?.transform = CGAffineTransform(
                scaleX: 0.1,
                y: 0.1
            )
        }
        
        return attributes
    }
}

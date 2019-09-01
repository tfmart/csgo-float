//
//  SkinHistoryCollectionViewCell.swift
//  CSGOFloat
//
//  Created by Tomas Martins on 17/12/18.
//  Copyright © 2018 Tomas Martins. All rights reserved.
//

import UIKit

class SkinHistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var skinImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var floatLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initialSetup()
    }
    
    func initialSetup() {
        self.skinImageView.image = nil
        self.nameLabel.text = ""
        self.floatLabel.text = ""
        self.layer.backgroundColor =  UIColor.clear.cgColor
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0.0
    }
}

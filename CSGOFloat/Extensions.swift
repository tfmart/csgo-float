//
//  Extensions.swift
//  CSGOFloat
//
//  Created by Tomas Martins on 03/01/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func styleByRarity(rarity: Int){
        switch rarity {
        case 1:
            //Consumer Grade
            self.layer.borderColor = UIColor(red:0.67, green:0.76, blue:0.84, alpha:1.0).cgColor
            self.layer.backgroundColor = UIColor(red:0.89, green:0.95, blue:1.00, alpha:1.0).cgColor
        case 2:
            //Industrial Grade
            self.layer.borderColor = UIColor(red:0.41, green:0.60, blue:0.83, alpha:1.0).cgColor
            self.layer.backgroundColor = UIColor(red:0.77, green:0.94, blue:0.97, alpha:1.0).cgColor
        case 3:
            //Mil-Spec
            self.layer.borderColor = UIColor(red:0.29, green:0.44, blue:0.96, alpha:1.0).cgColor
            self.layer.backgroundColor = UIColor(red:0.54, green:0.77, blue:0.96, alpha:1.0).cgColor
        case 4:
            //Contraband
            self.layer.borderColor = UIColor(red:0.49, green:0.33, blue:0.96, alpha:1.0).cgColor
            self.layer.backgroundColor = UIColor(red:0.84, green:0.72, blue:1.00, alpha:1.0).cgColor
        case 5:
            //Classified
            self.layer.borderColor = UIColor(red:0.75, green:0.28, blue:0.87, alpha:1.0).cgColor
            self.layer.backgroundColor = UIColor(red:0.89, green:0.77, blue:0.88, alpha:1.0).cgColor
        case 6:
            //Covert
            self.layer.borderColor = UIColor(red:0.86, green:0.34, blue:0.32, alpha:1.0).cgColor
            self.layer.backgroundColor = UIColor(red:0.95, green:0.66, blue:0.63, alpha:1.0).cgColor
        case 7:
            //Contraband
            self.layer.borderColor = UIColor(red:0.93, green:0.67, blue:0.31, alpha:1.0).cgColor
            self.layer.backgroundColor = UIColor(red:1.00, green:0.93, blue:0.55, alpha:1.0).cgColor
            
        default:
            print("Error getting skin's rarity")
        }
    }
}


extension UIImageView {
    //Extension to download an image from a URL
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

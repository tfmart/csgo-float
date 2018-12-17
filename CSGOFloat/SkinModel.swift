//
//  SkinModel.swift
//  CSGOFloat
//
//  Created by Tomas Martins on 08/11/18.
//  Copyright © 2018 Tomas Martins. All rights reserved.
//

import Foundation
import UIKit

class SkinModel {
    func getSkin(endpoint: String, callback: @escaping ((_ skin: WeaponSkin) -> Void)) {
        if let url = URL(string: endpoint) {
            URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { (data, response, error) in
                if error != nil {
                    print("Error = \(String(describing: error))")
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    let skin = try JSONDecoder().decode(WeaponSkin.self, from: data)
                    callback(skin)
                } catch let jsonError {
                    print(jsonError)
                }
                
                
            }).resume()
        } else {
            //URL is invalid
        }
    }
    
    func skinName(skin: WeaponSkin) -> String {
        var name: String = ""
        if(skin.iteminfo?.name == "-") {
            name = skin.iteminfo?.weapon ?? ""
        } else {
            name = "\(skin.iteminfo?.weapon ?? "") | \(skin.iteminfo?.name ?? "")"
        }
        if(skin.iteminfo?.stattrak != nil) {
            name = "StatTrak™ \(name)"
        }
        return name
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

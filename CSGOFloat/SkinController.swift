//
//  SkinModel.swift
//  CSGOFloat
//
//  Created by Tomas Martins on 08/11/18.
//  Copyright © 2018 Tomas Martins. All rights reserved.
//

import Foundation
import UIKit

class SkinController {
    /**
     Fetches a weapon's info from an inspect link, using CSGOFloat's API
     
     - Parameters:
       - inspectLink: The weapon's in-game inspect link
    */
    func fetchSkin(inspectLink: String, callback: @escaping ((_ skin: WeaponSkin) -> Void)) {
        let base = "https://api.csgofloat.com/?url=\(inspectLink)"
        guard let requestUrl = URL(string: base) else {
            //handle invalid endpoint error
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: requestUrl), completionHandler: { (data, response, error) in
            guard let fetchedData = data else {
                if let error = error {
                    print("Error = \(String(describing: error))")
                } else {
                    print("Unknown error")
                }
                return
            }
            do {
                let skin = try JSONDecoder().decode(WeaponSkin.self, from: fetchedData)
                callback(skin)
            } catch let decodeError {
                print(decodeError)
            }
        }).resume()
    }
    
    /**
     Uses an weapon's info to format it's name just like it is in in-game and on Steam
     
     - Parameters:
       - skin: The weapon object to get the information from
     - Returns: A string with the weapon's formatted name
    */
    func setSkinName(skin: WeaponSkin) -> String {
        var name: String = ""
        if skin.isVanilla() {
            name = skin.iteminfo?.weapon ?? ""
        } else {
            name = "\(skin.iteminfo?.weapon ?? "") | \(skin.iteminfo?.name ?? "")"
        }
        if skin.isStatTrak() {
            name = "StatTrak™ \(name)"
        }
        return name
    }
}

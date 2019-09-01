//
//  WeaponSkin.swift
//  CSGOFloat
//
//  Created by Tomas Martins on 07/11/18.
//  Copyright © 2018 Tomas Martins. All rights reserved.
//

import Foundation

class WeaponSkin: Decodable {
    let iteminfo: ItemInfo?
    let error: String?
}

struct ItemInfo: Decodable {
    let floatValue: Float?
    let name: String?
    let weapon: String?
    let imageURL: String?
    let statTrak: Int?
    let rarity: Int?
    
    private enum CodingKeys: String, CodingKey {
        case floatValue = "floatvalue"
        case name = "item_name"
        case weapon = "weapon_type"
        case imageURL = "imageurl"
        case statTrak = "killeatervalue"
        case rarity = "rarity"
    }
}

// MARK: - Extension

extension WeaponSkin {
    /// Boolean value indicating whether the skin is StatTrak
    func isStatTrak() -> Bool {
        guard let weaponInfo = self.iteminfo, weaponInfo.statTrak != nil else {
            return false
        }
        return true
    }
    
    /// Boolean value indicating whether the skin has painting applied
    func isVanilla() -> Bool {
        guard let weaponInfo = self.iteminfo, weaponInfo.name == "-" else {
            return false
        }
        return true
    }
}

//
//  AvatarColorHelper.swift
//  UserLookUp
//
//  Created by Dhilip R on 25/10/25.
//


import UIKit

struct AvatarColorHelper {
    
    static func getColor(for character: Character) -> UIColor {
        let colors: [UIColor] = [
            UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0),
            UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0),
            UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0),
            UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0),
            UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0),
            UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0),
            UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0),
            UIColor(red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0),
            UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0),
            UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        ]
        
        let uppercaseCharacter = String(character).uppercased()
        guard let unicodeValue = uppercaseCharacter.unicodeScalars.first?.value else {
            return .systemBlue
        }
        
        if (65...90).contains(unicodeValue) {
            return colors[Int(unicodeValue - 65) % colors.count]
        }
        
        if (97...122).contains(unicodeValue) {
            return colors[Int(unicodeValue - 97) % colors.count]
        }
        
        if (48...57).contains(unicodeValue) {
            return colors[Int(unicodeValue - 48) % colors.count]
        }
        
        return .systemBlue
    }
}

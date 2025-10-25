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
            UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0),    // Red - A
            UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0),    // Orange - B
            UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0),    // Yellow - C
            UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0),   // Green - D
            UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0),    // Green2 - E
            UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0),   // Cyan - F
            UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0),    // Blue - G
            UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0),    // Indigo - H
            UIColor(red: 175/255, green: 82/255, blue: 222/255, alpha: 1.0),   // Purple - I
            UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0),    // Pink - J
            UIColor(red: 162/255, green: 132/255, blue: 94/255, alpha: 1.0),   // Brown - K
            UIColor(red: 255/255, green: 109/255, blue: 0/255, alpha: 1.0),    // DeepOrange - L
            UIColor(red: 48/255, green: 209/255, blue: 88/255, alpha: 1.0),    // Mint - M
            UIColor(red: 94/255, green: 92/255, blue: 230/255, alpha: 1.0),    // Purple2 - N
            UIColor(red: 255/255, green: 159/255, blue: 10/255, alpha: 1.0),   // Orange2 - O
            UIColor(red: 191/255, green: 90/255, blue: 242/255, alpha: 1.0),   // Purple3 - P
            UIColor(red: 255/255, green: 55/255, blue: 95/255, alpha: 1.0),    // Pink2 - Q
            UIColor(red: 255/255, green: 69/255, blue: 58/255, alpha: 1.0),    // Red2 - R
            UIColor(red: 50/255, green: 173/255, blue: 230/255, alpha: 1.0),   // Cyan2 - S
            UIColor(red: 0/255, green: 199/255, blue: 190/255, alpha: 1.0),    // Teal - T
            UIColor(red: 10/255, green: 132/255, blue: 255/255, alpha: 1.0),   // Blue2 - U
            UIColor(red: 99/255, green: 230/255, blue: 226/255, alpha: 1.0),   // Teal2 - V
            UIColor(red: 172/255, green: 142/255, blue: 104/255, alpha: 1.0),  // Brown2 - W
            UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0),   // Purple4 - X
            UIColor(red: 255/255, green: 214/255, blue: 10/255, alpha: 1.0),   // Yellow2 - Y
            UIColor(red: 64/255, green: 156/255, blue: 255/255, alpha: 1.0)    // Blue3 - Z
        ]
        
        let uppercaseCharacter = String(character).uppercased()
        guard let unicodeValue = uppercaseCharacter.unicodeScalars.first?.value else {
            return .systemBlue
        }
        
        if (65...90).contains(unicodeValue) {
            return colors[Int(unicodeValue - 65)]
        }
        
        if (97...122).contains(unicodeValue) {
            return colors[Int(unicodeValue - 97)]
        }
        
        if (48...57).contains(unicodeValue) {
            return colors[Int(unicodeValue - 48) % colors.count]
        }
        
        return .systemBlue
    }
}

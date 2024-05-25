//
//  Extensions.swift
//  Netflix
//
//  Created by M7md  on 20/05/2024.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        let words = self.components(separatedBy: .whitespaces)
        let capitalizedWords = words.map { $0.capitalized }
        return capitalizedWords.joined(separator: " ")
    }
}

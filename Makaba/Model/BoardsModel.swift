//
//  CategoryList.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 29.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct Boards: Codable {
    struct Board: Codable {
        let id: String
        let name: String
        let pages: Int
    }
    
    let adult: [Board]
    let games: [Board]
    let politics: [Board]
    let custom: [Board]
    let random: [Board]
    let creation: [Board]
    let subjects: [Board]
    let technology: [Board]
    let japanCulture: [Board]
    
    private enum CodingKeys: String, CodingKey {
        case adult = "Взрослым"
        case games = "Игры"
        case politics = "Политика"
        case custom = "Пользовательские"
        case random = "Разное"
        case creation = "Творчество"
        case subjects = "Тематика"
        case technology = "Техника и софт"
        case japanCulture = "Японская культура"
    }
    
    var dictionary: [String: [Board]] {
        return [
            CodingKeys.adult.rawValue: adult,
            CodingKeys.games.rawValue: games,
            CodingKeys.politics.rawValue: politics,
            CodingKeys.custom.rawValue: custom,
            CodingKeys.random.rawValue: random,
            CodingKeys.creation.rawValue: creation,
            CodingKeys.subjects.rawValue: subjects,
            CodingKeys.technology.rawValue: technology,
            CodingKeys.japanCulture.rawValue: japanCulture,
        ]
    }
}

// MARK: - Extension Dictionary
// Converts all dictionary keys to array
extension Dictionary {
    var allKeys: [Dictionary<Key, Value>.Keys.Element] {
        return Array(self.keys)
    }
}

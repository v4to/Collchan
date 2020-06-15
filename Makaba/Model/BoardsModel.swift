//
//  CategoryList.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 29.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct BoardsCategories: Decodable {
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
}

extension BoardsCategories {
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
    
    var array: [BoardCategory] {
        let arr = [
            BoardCategory(name: CodingKeys.adult.rawValue, boards: adult),
            BoardCategory(name: CodingKeys.games.rawValue, boards: games),
            BoardCategory(name: CodingKeys.politics.rawValue, boards: politics),
            BoardCategory(name: CodingKeys.custom.rawValue, boards: custom),
            BoardCategory(name: CodingKeys.random.rawValue, boards: random),
            BoardCategory(name: CodingKeys.creation.rawValue, boards: creation),
            BoardCategory(name: CodingKeys.subjects.rawValue, boards: subjects),
            BoardCategory(name: CodingKeys.technology.rawValue, boards: technology),
            BoardCategory(name: CodingKeys.japanCulture.rawValue, boards: japanCulture)
            ].sorted { $0.name < $1.name}
        
        return arr.map { boardCategory in
            var boardCategory = boardCategory
            boardCategory.boards = boardCategory.boards.sorted { $0.id < $1.id}
            return boardCategory
        }
    }
}


struct BoardCategory {
    let name: String
    var boards: [Board]
}

struct Board: Decodable {
    let id: String
    let name: String
    let pages: Int
}


// MARK: - Extension Dictionary
// Converts all dictionary keys to array
extension Dictionary {
    var allKeys: [Dictionary<Key, Value>.Keys.Element] {
        return Array(self.keys)
    }
}

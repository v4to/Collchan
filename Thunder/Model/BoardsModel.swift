//
//  CategoryList.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 29.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct BoardsWrapper: Decodable {
    let boards: [Board]
}

extension BoardsWrapper {
    var sortedArray: [BoardCategory] {
        var dictionary = [String: [Board]]()
        
        boards.forEach {
            if dictionary[$0.category] == nil {
                dictionary[$0.category] = [$0]
            } else {
                dictionary[$0.category]?.append($0)
            }
        }
        
        var categories = [BoardCategory]()
        for (key, value) in dictionary {
            let category = BoardCategory(name: key, boards: value)
            categories.append(category)
        }
        
        return categories
            .sorted(by: {
                return $0.name < $1.name
            })
            .map({ boardCategory in
                var boardCategory = boardCategory
                boardCategory.boards = boardCategory.boards.sorted { $0.id < $1.id}
                return boardCategory
            })
    }
}

struct BoardCategory: Hashable {
    let name: String
    var boards: [Board]
}

struct Board: Decodable, Hashable {
    let id: String
    let name: String
    let category: String
}


//
//  BoardsService.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 31.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct BoardsService {
    // MARK: - Instance properties
    let networkService = NetworkService.shared
    
    // MARK: - Instance methods
    func getBoards(onSuccess: @escaping (Boards) -> Void, onFailure: @escaping (Error) -> Void) {
        networkService.GET(
            endPoint: EndPoints.boards,
            parameters: ["task": "get_boards"],
            decodeModelType: Boards.self,
            onSuccess: onSuccess,
            onFailure: onFailure
        )
    }
}

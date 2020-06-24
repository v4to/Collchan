//
//  BoardsService.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 31.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct BoardsService {
    let boardsRequest = APIRequest(resource: BoardsResource())
    
    func getBoardsList(completion: @escaping (BoardsResource.ModelType?) -> Void) {
        boardsRequest.load(withCompletion: completion)
    }
}

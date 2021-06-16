//
//  BoardsResource.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 15.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct BoardsResource: APIResource {
    typealias ModelType = BoardsWrapper
    
    let methodPath = EndPoints.boards
    let queryItems: [URLQueryItem] = []
}

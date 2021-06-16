//
//  PostsResource.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 15.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct PostsResource: APIResource {
    typealias ModelType = PostsWrapper
    
    var methodPath: String
    var queryItems: [URLQueryItem] = []
    
    init(boardId: String, threadId: String, postId: String) {
        methodPath = "/\(boardId)/res/\(threadId).json"
    }
}

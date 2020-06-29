//
//  NetworkService.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 31.05.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation
import UIKit

struct NetworkService {
    static let shared = NetworkService()
    
    let boardsRequest = APIRequest(resource: BoardsResource())
    
    var threadsRequest: APIRequest<ThreadsResource>?
    
    var imageRequest: ImageRequest?
    
    private init() {}
    
    func getBoards(completion: @escaping (BoardsResource.ModelType?) -> Void) {
        boardsRequest.load(withCompletion: completion)
    }
    
//    mutating func getThreads(from boardId: String, completion: @escaping (Threads?) -> Void) {
//       threadsRequest = APIRequest(resource: ThreadsResource(threadId: boardId, page: ))
//       threadsRequest!.load(withCompletion: completion)
//    }
    
    mutating func getImageAtPath(_ path: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: BaseUrls.dvach + path)!
        imageRequest = ImageRequest(url: url)
        imageRequest?.load(withCompletion: completion)
    }
    
    var threadRequest: APIRequest<ThreadResource>?
    
    mutating func getPostsFrom(boardId: String, threadId: String, completion: @escaping (Thread?) -> Void) {
        threadRequest = APIRequest(resource: ThreadResource(boardId: boardId, threadId: threadId, postId: threadId))
        threadRequest?.load(withCompletion: completion)
    }
}

/*
struct ThreadsResource: APIResource {
    typealias ModelType = Threads
        
    let methodPath: String
    
    let queryItems: [URLQueryItem] = []
    
    init(threadId: String, page: String) {
        self.methodPath = "/" + threadId + "/" + page + ".json"
    }
}*/


struct ThreadsResource: APIResource {
    typealias ModelType = Threads
        
    let methodPath: String
    
    let queryItems: [URLQueryItem] = []
    
    init(threadId: String, page: String) {
//        init(threadId: String) {

        self.methodPath = "/" + threadId + "/" + page + ".json"

//        self.methodPath = "/" + threadId + EndPoints.threads
    }
}


struct BoardsResource: APIResource {
    typealias ModelType = BoardsCategories
    
    let methodPath = EndPoints.boards
    
    let queryItems = [
           URLQueryItem(name: "task", value: "get_boards"),
    ]
}


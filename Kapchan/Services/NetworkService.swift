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
    static var shared = NetworkService()
    
    let boardsRequest = APIRequest(resource: BoardsResource())
    var threadsRequest: APIRequest<ThreadsResource>?
    var imageRequest: ImageRequest?
    var threadRequest: APIRequest<PostsResource>?
    
    private init() {}
    
    func getBoards(completion: @escaping (BoardsWrapper?) -> Void) {
        boardsRequest.load(withCompletion: completion)
    }
    
    mutating func getThreads(fromBoard boardId: String, onPage page: Int, completion: @escaping (Threads?) -> Void) {
        let page = page == 0 ? "index" : String(page)
        
        // threadsRequest = APIRequest(resource: ThreadsResource(threadId: boardId))
        threadsRequest = APIRequest(resource: ThreadsResource(threadId: boardId, page: page))
        threadsRequest!.load(withCompletion: completion)
    }
    
    mutating func getImageAtPath(_ path: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: BaseUrls.dvach + path)!
        imageRequest = ImageRequest(url: url)
        imageRequest?.load(withCompletion: completion)
    }

//    mutating func getPostsFrom(boardId: String, threadId: String, completion: @escaping ([Post]?) -> Void) {
    mutating func getPostsFrom(boardId: String, threadId: String, completion: @escaping (PostsWrapper?) -> Void) {

        threadRequest = APIRequest(resource: PostsResource(boardId: boardId, threadId: threadId, postId: threadId))
        threadRequest?.load(withCompletion: completion)
    }
    
    

    func createPostFrom(boardId: String, threadId: String, comment: String, googleRecaptchId: String, captchaId: String, completion:  @escaping (Result<PostResponse>) -> Void) {
        let postService = PostService(
            boardId: boardId,
            threadId: threadId,
            commentText: comment,
            googleRecaptchId: googleRecaptchId,
            captchaId: captchaId
        )
        let provider = ServiceProvider<PostService>()
//        provider.load(service: postService, completion: completion)
        provider.load(service: postService, decodeType: PostResponse.self, completion: completion)
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
    typealias ModelType = BoardsWrapper

    let methodPath = EndPoints.boards
    
    let queryItems: [URLQueryItem] = []
}

class PostsResource: APIResource {
//    typealias ModelType = [Post]
    typealias ModelType = PostsWrapper
    var methodPath: String
    
    

//    var methodPath = EndPoints.makabaMobile
    var queryItems: [URLQueryItem] = []
    
    init(boardId: String, threadId: String, postId: String) {
        methodPath = "/\(boardId)/res/\(threadId).json"
//        queryItems = [
//            URLQueryItem(name: "task", value: "get_thread"),
//            URLQueryItem(name: "board", value: boardId),
//            URLQueryItem(name: "thread", value: threadId),
//            URLQueryItem(name: "num", value: postId)
//        ]
    }
}

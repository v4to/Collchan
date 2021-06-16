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
    var createNewPostRequest: CreateNewPostRequest?
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
    
    

    mutating func createPostFrom(
        boardId: String,
        threadId: String,
        comment: String,
        captchaType: CaptchaType,
        captchaId: String,
        completion:  @escaping (PostResponse?) -> Void

    )
    {
        self.createNewPostRequest = CreateNewPostRequest(
            boardId: boardId,
            threadId: threadId,
            postText: comment,
            captchaType: captchaType,
            captchaId: captchaId
        )
        self.createNewPostRequest?.load(withCompletion: completion)
    }
}

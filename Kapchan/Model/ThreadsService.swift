//
//  ThreadsService.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 07.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation
import UIKit

struct ThreadsService {
    // MARK: - Instance Properties
    var threadsRequest: APIRequest<ThreadsResource>?
    
    var imageRequest: ImageRequest?
    
    // MARK: - Instance methods
    mutating func getThreads(fromBoard boardId: String, onPage page: Int, completion: @escaping (Threads?) -> Void) {
        let page = page == 0 ? "index" : String(page)
        
        threadsRequest = APIRequest(resource: ThreadsResource(threadId: boardId, page: page))
        threadsRequest!.load(withCompletion: completion)
    }

    mutating func getImageAtPath(_ path: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: BaseUrls.dvach + path)!
        imageRequest = ImageRequest(url: url)
        imageRequest?.load(withCompletion: completion)
    }
}

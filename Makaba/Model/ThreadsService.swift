//
//  ThreadsService.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 07.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct ThreadsService {
    // MARK: - Instance properties
    let networkService = NetworkService.shared
    
    // MARK: - Instance methods
    func getThreads(
        from boardId: String,
        onSuccess: @escaping (Threads) -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        let endPoint = "/\(boardId)\(EndPoints.threads)"
        
        networkService.GET(
            endPoint: endPoint,
            parameters: [:],
            decodeModelType: Threads.self,
            onSuccess: onSuccess,
            onFailure: onFailure
        )
    }
}

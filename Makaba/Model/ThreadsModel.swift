//
//  ThreadsModel.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 07.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct Threads: Decodable {
    let threads: [Thread]

    struct Thread: Decodable {
        let comment: String
        let date: String
        let files: [File]
        let filesCount: Int
        let num: String
        let postsCount: Int

        struct File: Decodable {
            let fullname: String?
            let path: String
        }
        
        private enum CodingKeys: String, CodingKey {
            case comment
            case date
            case files
            case filesCount = "files_count"
            case num
            case postsCount = "posts_count"
        }
    }
    
}

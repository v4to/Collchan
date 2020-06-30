//
//  ThreadsModel.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 07.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation
import UIKit

import UIKit


struct Threads: Decodable {
    let threads: [Thread]
    let pages: [Int]
    let currentPage: Int

    private enum CodingKeys: String, CodingKey {
        case threads
        case pages
        case currentPage = "current_page"
    }
}

extension Threads {
    var isCurrentPageTheLast: Bool {
        return currentPage == lastPage
    }

    var lastPage: Int {
        return pages.last! - 1
    }

    var thumbnailCount: Int {
        var count = 0
        for thread in threads {
            if thread.thumbnailURL != nil {
                count += 1
            }
        }
        return count
    }
}


//struct Threads: Decodable {
//    let threads: [Thread]
//}




struct Thread: Decodable {
    let filesCount: Int
    let postsCount: Int
    var posts: [Post]
    let threadId: String

    var image: UIImage?

    private enum CodingKeys: String, CodingKey {
        case filesCount = "files_count"
        case postsCount = "posts_count"
        case posts
        case threadId = "thread_num"
    }
}
extension Thread {
    var thumbnailURL: String? {
        guard posts[0].files.count > 0 else {
            return nil
        }
        return posts[0].files[0].thumbnail
    }
}

//struct Thread: Decodable {
//    let heading: String
//    let filesCount: Int
//    let postsCount: Int
//    let threadId: String
//    let files: [File]
//    var image: UIImage?
//    let creationDate: Date
//    var comment: String
//
//    private enum CodingKeys: String, CodingKey {
//        case heading = "subject"
//        case filesCount = "files_count"
//        case postsCount = "posts_count"
//        case threadId = "num"
//        case files
//        case creationDate = "timestamp"
//        case comment
//    }
//}
//
//
//
//extension Thread {
//    var thumbnailURL: String? {
//        guard files.count > 0 else {
//            return nil
//        }
//        return files[0].thumbnail
//    }
//
//    var dateString: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.YYYY, HH:mm"
//        return dateFormatter.string(from: creationDate)
//    }
//}




struct File: Decodable {
    let fullname: String?
    let path: String
    let thumbnail: String
}

struct Post: Decodable {
    let files: [File]
    var comment: String
    let subject: String
    let creationDate: Date
   
    var images: [UIImage]? = nil
    
    private enum CodingKeys: String, CodingKey {
        case files
        case comment
        case subject
        case creationDate = "timestamp"
    }
}

extension Post {
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY, HH:mm"
        return dateFormatter.string(from: creationDate)
    }
}

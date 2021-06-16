//
//  PostingNewPost.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 16.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct PostingNewPost: Decodable {
    let appResponseId: String?
    let error: APIError?
    
    enum CodingKeys: String, CodingKey {
        case appResponseId = "id"
        case error
    }
    
    enum ErrorCodingKeys: String, CodingKey {
        case code
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.appResponseId = try? container.decode(String.self, forKey: .appResponseId)
        if let errorContainer = try? container.nestedContainer(
            keyedBy: ErrorCodingKeys.self,
            forKey: .error
        )
        {
        	self.error = try errorContainer.decode(APIError.self, forKey: .code)
        } else {
            self.error = nil
        }
    }
}

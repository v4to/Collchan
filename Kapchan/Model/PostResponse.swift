//
//  PostResponse.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 16.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct PostResponse: Decodable {
    let error: APIError?
    
    let status: String?
    let num: Int?
    
    enum CodingKeys: String, CodingKey {
        case error = "Error"
        case status = "Status"
        case num = "Num"
    }
}

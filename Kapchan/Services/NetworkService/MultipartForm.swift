//
//  MultipartForm.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 15.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation

struct MultipartForm {
    var formData = Data()
    struct Part {
        let name: String
        let value: String
    }
    
    init(parts: [Part], boundary: String) {
        for part in parts {
            self.formData.append("--\(boundary)\r\n".data(using: .utf8)!)
            self.formData.append(
                "Content-Disposition: form-data; name=\"\(part.name)\"\r\n\r\n"
                    .data(using: .utf8)!
            )
            self.formData.append("\(part.value)\r\n".data(using: .utf8)!)
        }
        self.formData.append("--\(boundary)--\r\n".data(using: .utf8)!)
    }
}

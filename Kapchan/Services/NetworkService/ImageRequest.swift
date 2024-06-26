//
//  ImageRequest.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 14.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation
import UIKit

class ImageRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension ImageRequest: NetworkRequest {
    func decode(_ data: Data) -> UIImage? {
        var image = UIImage(data: data)
        image = image?.resized(to: CGSize(width: 90.0, height: 90.0))
        return image
    }
    
    func load(withCompletion completion: @escaping (UIImage?) -> Void) {
        let request = URLRequest(url: self.url)
        load(request, withCompletion: completion)
    }
}

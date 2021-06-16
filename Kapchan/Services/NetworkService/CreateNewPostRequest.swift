//
//  CreateNewPostRequest.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 15.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation
import CryptoKit


class CreateNewPostRequest {
    let boardId: String
    let threadId: String
    let postText: String
    let captchaType: CaptchaType
    let captchaId: String
    let email: String
    let subject: String
    
    init(
        boardId: String,
        threadId: String,
        postText: String,
        captchaType: CaptchaType,
        captchaId: String,
        email: String? = nil,
        subject: String? = nil
	)
    {
        self.boardId = boardId
        self.threadId = threadId
        self.postText = postText
        self.captchaType = captchaType
        self.captchaId = captchaId
        self.email = email ?? ""
        self.subject = subject ?? ""
    }
}


extension CreateNewPostRequest: NetworkRequest {
    func load(withCompletion completion: @escaping (PostResponse?) -> Void) {
        let boundary = UUID().uuidString

        var urlComponents = URLComponents(string: BaseUrls.dvach + EndPoints.createPost)!
        urlComponents.query = "json=1"
       
        let appResponse = SHA256.hash(
            data: Data("\(self.captchaId)|MGfFLDCXvpfn39Yv41Pz0hsF2pxartQB".utf8)
        ).map { (element) in
            return String(format: "%02x", element)
        }.joined()
   
        var captchaParts = [
            MultipartForm.Part(name: "task", value: "post"),
            MultipartForm.Part(name: "board", value: self.boardId),
            MultipartForm.Part(name: "thread", value: self.threadId),
            MultipartForm.Part(name: "email", value: self.email),
            MultipartForm.Part(name: "subject", value: self.subject),
            MultipartForm.Part(name: "comment", value: self.postText),
            MultipartForm.Part(name: "captcha_type", value: self.captchaType.rawValue)
        ]
        
        switch self.captchaType {
        case .app:
            captchaParts.append(
                MultipartForm.Part(name: "app_response_id", value: self.captchaId)
            )
            captchaParts.append(
                MultipartForm.Part(name: "app_response", value: appResponse)
            )
        case .invisibleRecaptcha:
            captchaParts.append(
                MultipartForm.Part(name: "g-recaptcha-response", value: self.captchaId)
            )
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        request.httpMethod = "POST"
        request.httpBody = MultipartForm(parts: captchaParts, boundary: boundary).formData
        
        self.load(request, withCompletion: completion)
    }

    func decode(_ data: Data) -> PostResponse? {
        let decoder = JSONDecoder()
        do {
            let wrapper = try decoder.decode(PostResponse.self, from: data)
            return wrapper
        } catch {
            return nil
            
        }
    }
}


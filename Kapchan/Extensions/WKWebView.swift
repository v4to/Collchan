//
//  File.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 25.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {

    func cleanAllCookies(completionHandler: (() -> Void)? = nil) {
        let storage = HTTPCookieStorage.shared
        let cookies = HTTPCookieStorage.shared.cookies
        for cookie in cookies ?? [] {
            print("DELETING .... \(cookie)")
            storage.deleteCookie(cookie)
        }
        print("All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Cookie ::: \(record) deleted")
            }
            completionHandler?()
        }
    }

    func loadCookies() {
        print("LOADCOOKIES")
        var request = URLRequest(url: URL(string: (BaseUrls.dvach))!)
        request.setValue("\(WKWebView().value(forKey: "userAgent")!)", forHTTPHeaderField: "User-Agent")
        self.load(request)
    }
}

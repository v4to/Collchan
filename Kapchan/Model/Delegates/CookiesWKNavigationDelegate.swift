//
//  SetCookieView.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 25.06.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import UIKit
import WebKit

class CookiesWKNavigationDelegate: NSObject, WKNavigationDelegate {
    let didLoadCookiesCallback: () -> Void

    init(didLoadCookiesCallback: @escaping () -> Void) {
        self.didLoadCookiesCallback = didLoadCookiesCallback

        super.init()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let response = navigationResponse.response as? HTTPURLResponse else {
            decisionHandler(.cancel)
            return
        }

        if (500...511).contains(response.statusCode) {
            print("SERVER ERROR")
            self.didLoadCookiesCallback()
        }

        let cookieStorage = WKWebsiteDataStore.default()
        cookieStorage.httpCookieStore.getAllCookies { $0.forEach({ HTTPCookieStorage.shared.setCookie($0) }) }

        decisionHandler(.allow)
    }


    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title", completionHandler: { (value: Any!, error: Error!) -> Void in

            if error != nil { return }

            // Hack to check that cloudflare check wac successful and all needed cookies are set
            if let result = value as? String, result == "Два.ч — Свободное общение" {
                print("RESULT --- \(result)")
                self.didLoadCookiesCallback()
            } else {
                print("Check currently in progress or invalid server response")
            }
        })
    }

}


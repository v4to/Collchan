//
//  String.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 12.02.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

extension String {
    func rectThatFits(_ size: CGSize, and font: UIFont) -> CGRect{
        let textContainer = NSTextContainer(size: size)
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(string: self, attributes: [NSAttributedString.Key.font : font])
        textContainer.lineFragmentPadding = 0.0
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        return layoutManager.usedRect(for: textContainer)
    }
    
    
    
        func sha256() -> String {
            guard let stringData = self.data(using: String.Encoding.utf8) else { return "" }
            return hexStringFromData(input: digest(input: stringData as NSData))
        }

        private func digest(input : NSData) -> NSData {
            let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
            var hash = [UInt8](repeating: 0, count: digestLength)
            CC_SHA256(input.bytes, UInt32(input.length), &hash)
            return NSData(bytes: hash, length: digestLength)
        }

        private  func hexStringFromData(input: NSData) -> String {
            var bytes = [UInt8](repeating: 0, count: input.length)
            input.getBytes(&bytes, length: input.length)

            var hexString = ""
            for byte in bytes {
                hexString += String(format:"%02x", UInt8(byte))
            }

            return hexString
        }
}


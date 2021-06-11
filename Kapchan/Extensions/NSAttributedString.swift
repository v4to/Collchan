//
//  NSAttributedString.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 12.02.2021.
//  Copyright © 2021 Andrii Yehortsev. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    func rectThatFits(_ size: CGSize) -> CGRect{
        let textContainer = NSTextContainer(size: size)
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: self)
        textContainer.lineFragmentPadding = 0.0
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        return layoutManager.usedRect(for: textContainer)
    }
    
    func image(with size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIGraphicsGetCurrentContext()
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Trims new lines and whitespaces off the beginning and the end of attributed strings
    func trimmedAttributedString() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.lowerBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }
        
        let trimmedRange = startLocation...endLocation
        return attributedSubstring(from: NSRange(trimmedRange, in: string))
    }
}

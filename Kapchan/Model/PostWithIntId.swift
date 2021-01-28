//
//  PostWithIndId.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 13.07.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation
import Fuzi

struct PostWithIntId: Decodable {
    let files: [File]
    var subject: String
    var comment: String
    var creationDate: Date {
        didSet {
//            print("didSet")
        }
    }
    let postId: Int
    var images = [UIImage]()
    var replies = [PostWithIntId]()
    
    private enum CodingKeys: String, CodingKey {
        case files
        case comment
        case subject
        case creationDate = "timestamp"
        case postId = "num"
    }
    
    var thumbnailUrls = [URL]()
    
    mutating func setupThumbnailUrls() {
        for file in self.files {
            let url = URL(string: BaseUrls.dvach + file.path)!
            thumbnailUrls.append(url)
        }
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY, HH:mm"
        return dateFormatter.string(from: creationDate)
    }
    
    var creationDateString: String = ""
    
    mutating func mapDateToString() {
        let relativeDateFormatter = RelativeDateTimeFormatter()
        relativeDateFormatter.unitsStyle = .full
        creationDateString = relativeDateFormatter.localizedString(for: creationDate, relativeTo: Date())
    }
    
    
    var attributedComment = NSMutableAttributedString()
//    lazy var attibutedComment: NSMutableAttributedString? = {
//
//        let comment = self.comment
////        let comment = self.comment.replacingOccurrences(of: "<br>", with: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
//
//        guard comment.count > 0 else {
//            return nil
//        }
//
//        do {
//            let doc = try HTMLDocument(string: comment)
//            if let body = doc.body {
//                return self.attributedStringFromHtml(body)
//            } else {
//
//                return NSMutableAttributedString(string: comment)
//            }
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }()
    
    mutating func setupAttributedComment() {
        let comment = self.comment
        //        let comment = self.comment.replacingOccurrences(of: "<br>", with: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard comment.count > 0 else {
            self.attributedComment = NSMutableAttributedString(string: comment)
            return
        }
        
        do {
            let doc = try HTMLDocument(string: comment)
            if let body = doc.body {
                self.attributedComment = self.attributedStringFromHtml(body)
            } else {
                self.attributedComment = NSMutableAttributedString(string: comment)
//                return NSMutableAttributedString(string: comment)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func attributedStringFromHtml(_ root: XMLNode) -> NSMutableAttributedString {
        if let root = root as? XMLElement {
            var attributedText: NSMutableAttributedString
//            attributedText = NSMutableAttributedString()
            if root.attr("class") == "spoiler" {
                attributedText = NSMutableAttributedString(
                    string: root.stringValue,
                    attributes: [
                        NSAttributedString.Key.backgroundColor: #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1),
                        NSAttributedString.Key.font :  UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
                        NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1608105964, green: 0.1608105964, blue: 0.1608105964, alpha: 1)
                    ]
                )
            }
            
            if root.tag == "br" {
//                print(root.stringValue)
                attributedText = NSMutableAttributedString(string: "\n")
            } else {
                attributedText = NSMutableAttributedString()
            }
            for node in root.childNodes(ofTypes: [.Element, .Text]) {
                attributedText.append(attributedStringFromHtml(node))
            }
            
            if root.attr("class") == "spoiler" {
                let firstCharIndex = attributedText.string.firstIndex {
                    if $0 == " " {
                        return false
                    } else if $0 == "\n" {
                        return false
                    } else {
                        return true
                    }
                    
                }?.utf16Offset(in: attributedText.string)
    
                
                let lastChardIndex = attributedText.string.lastIndex {
                    if $0 == " " {
                        return false
                    } else if $0 == "\n" {
                        return false
                    } else {
                        return true
                    }
                }?.utf16Offset(in: attributedText.string)
                
                if let firstCharIndex = firstCharIndex, let lastCharIndex = lastChardIndex {
                    let range = NSRange(location: firstCharIndex, length: lastCharIndex - firstCharIndex + 1)

                    attributedText.addAttributes([
                        NSAttributedString.Key.backgroundColor: #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1),
                        NSAttributedString.Key.font :  UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
                        NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1608105964, green: 0.1608105964, blue: 0.1608105964, alpha: 1)
                    ],
                    range: range)
                }
                
                return attributedText
//                let range = NSRange(location: firstCharIndex!, length: attributedText.string.count - firstCharIndex!)
                
            }
            
            if root.attr("class") == "unkfunc" {
                let firstCharIndex = attributedText.string.firstIndex {
                    if $0 == " " {
                        return false
                    } else if $0 == "\n" {
                        return false
                    } else {
                        return true
                    }
                    
                    }?.utf16Offset(in: attributedText.string)
                
                
                let lastChardIndex = attributedText.string.lastIndex {
                    if $0 == " " {
                        return false
                    } else if $0 == "\n" {
                        return false
                    } else {
                        return true
                    }
                    }?.utf16Offset(in: attributedText.string)
                
                if let firstCharIndex = firstCharIndex, let lastCharIndex = lastChardIndex {
                    let range = NSRange(location: firstCharIndex, length: lastCharIndex - firstCharIndex + 1)
                    attributedText.addAttributes([
                        NSAttributedString.Key.foregroundColor: Constants.Design.Color.green
                    ],
                    range: range)
                }
            }
            
            return attributedText
        }
        
        if root.parent?.tag == "a" && root.parent?.attr("class") != "post-reply-link" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
                    NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                    NSAttributedString.Key.link: URL(string:root.parent!.attr("href")!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
                ]
            )
        }
        
        if root.parent?.attr("class") == "s" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    //                    NSAttributedString.Key.strikethroughColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1),
                    NSAttributedString.Key.strikethroughColor: UIColor.label,
                    
                    NSAttributedString.Key.font :  UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
                    //                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
                    NSAttributedString.Key.foregroundColor: UIColor.label
                    
                ]
            )
        }
        
        if root.parent?.attr("class") == "spoiler" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.backgroundColor: #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1),
                    NSAttributedString.Key.font :  UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1608105964, green: 0.1608105964, blue: 0.1608105964, alpha: 1)
                ]
            )
        }
        
        if root.parent?.attr("class") == "unkfunc" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.font :  UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
                    NSAttributedString.Key.foregroundColor: UIColor.systemGreen
                ]
            )
        }
        
        if root.parent?.attr("class") == "post-reply-link" {
            //            print(root.parent?.attr("data-thread"))
            let postReply = root.parent!.attr("data-num")!
            //                print("URL ---", URL(string: "thunder://\(postReply)"))
            
            //            }
            
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline).withSize(14.0),
                    NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                    NSAttributedString.Key.link: URL(string: "thunder://\(postReply)")!
                ]
            )
        }
        
        if root.parent?.attr("class") == "u" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.underlineColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1),
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline).withSize(15.0),
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
                ]
            )
        }
        
        if root.parent?.tag == "strong" {
            return NSMutableAttributedString(
                string: root.stringValue,
                attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline).withSize(15.0),
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1)
                ]
            )
        }
        
        return NSMutableAttributedString(
            string: root.stringValue,
            attributes: [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body).withSize(15.0),
                //                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.831299305, green: 0.8314197063, blue: 0.8391151428, alpha: 1) .label
                NSAttributedString.Key.foregroundColor: UIColor.label
                
            ]
        )
    }

}


//
//  Constants.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 06.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//

import Foundation
import UIKit

struct BaseUrls {
//    static let dvach = "https://2ch.pm"
    static let dvach = "https://2ch.hk"

}

struct EndPoints {
    static let boards = "/boards.json"
    static let makabaMobile = "/makaba/mobile.fcgi"
    static let threads = "/catalog.json"
    static let createPost = "/makaba/posting.fcgi"
}

enum Constants {
    enum Design {
        enum Color {
            static let background = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.129, green: 0.145, blue: 0.180, alpha: 1.0)
                } else {
                    return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
            }
            
            static let backgroundWithOpacity = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return Color.background.withAlphaComponent(0.8)
                } else {
                    return Color.background.withAlphaComponent(0.1)
                }
            }
            
            static let gap = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.176, green: 0.192, blue: 0.227, alpha: 1.0)
                } else {
                    return UIColor(red: 0.945, green: 0.949, blue: 0.968, alpha: 1.0)
                    
                }
            }
//            #colorLiteral(red: 0.9490327239, green: 0.3647238612, blue: 0.0002184533805, alpha: 1)
            static let orange = UIColor(red: 0.949, green: 0.364, blue: 0.0, alpha: 1.0)
//            #colorLiteral(red: 0.4862266779, green: 0.4980691671, blue: 0.5254244804, alpha: 1)
            static let secondaryGray = UIColor(red:  0.486, green: 0.498, blue: 0.525, alpha: 1.0)
//            #colorLiteral(red: 0, green: 0.6353240609, blue: 0, alpha: 1)
            static let green = UIColor(red: 0.0, green: 0.635, blue: 0.0, alpha: 1)
            
            static let backgroundReplyAction = UIColor(red: 0.136, green: 0.709, blue:  0.999, alpha: 1)
        }
        
        enum Image {
            static let iconBoards = UIImage(systemName: "rectangle.stack.fill")
            static let iconFavorites = UIImage(systemName: "star.fill")!
            static let iconRemoveFromFavorites = UIImage(systemName: "star.slash.fill")!
            static let iconThreadsHistory = UIImage(systemName: "clock.fill")
            static let iconSettings = UIImage(systemName: "gear")
            static let iconAdd = UIImage(systemName: "plus")
            static let iconCatalog = UIImage(systemName: "square.grid.2x2")
            static let iconCreateNewThread = UIImage(systemName: "square.and.pencil")
            static let iconReply =  UIImage(systemName: "arrowshape.turn.up.left.fill")!
        }
        
    }
}

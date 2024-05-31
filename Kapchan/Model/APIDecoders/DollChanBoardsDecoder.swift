//
//  DollChanParser.swift
//  Kapchan
//
//  Created by Andrii Yehortsev on 25.04.2024.
//  Copyright © 2024 Andrii Yehortsev. All rights reserved.
//

import Foundation
import Fuzi

//struct DollChanBoardParser: HTMLParsing {
struct DollChanBoardsDecoder: APIDecoding {
    func decode(data: Data) -> [Board]? {
        let html = String(decoding: data, as: UTF8.self)
        let search = #/<tr>[\t\n\r]+<td class="navigation-link">[\t\n\r\W\w]+<td>Video Games board</td>[\t\n\r]+</tr>/#
        var boards = [Board]()
        
        if let result = try? search.firstMatch(in: html) {
            do {
                let document = try HTMLDocument(string: String(result.0))
                let trs = document.css("tr")
                
                boards = trs.map { tr in
                    return Board(
                        id: tr.children[0].stringValue,
                        name: tr.children[1].stringValue
                    )
                }
            } catch {
//                print(error.localizedDescription)
//                return nil
                
                fatalError(error.localizedDescription)
            }
            
        }

        return boards
    }
    
    typealias ModelType = [Board]
    func parse(data: Data) -> [Board] {
        let html = String(decoding: data, as: UTF8.self)
        let search = #/<tr>[\t\n\r]+<td class="navigation-link">[\t\n\r\W\w]+<td>Video Games board</td>[\t\n\r]+</tr>/#
        var boards = [Board]()
        
        if let result = try? search.firstMatch(in: html) {
            do {
                let document = try HTMLDocument(string: String(result.0))
                let trs = document.css("tr")
                
                boards = trs.map { tr in
                    return Board(
                        id: tr.children[0].stringValue,
                        name: tr.children[1].stringValue
                    )
                }
            } catch {
//                print(error.localizedDescription)
//                return nil
                
                fatalError(error.localizedDescription)
            }
            
        }

        return boards
    }
}

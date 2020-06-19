//
//  FavoriteBoard+CoreDataClass.swift
//  Thunder
//
//  Created by Andrii Yehortsev on 16.06.2020.
//  Copyright © 2020 Andrii Yehortsev. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FavoriteBoard)
public class FavoriteBoard: NSManagedObject {
    static func findFavoriteBoards(in context: NSManagedObjectContext) throws -> [FavoriteBoard] {
        let request: NSFetchRequest<FavoriteBoard> = FavoriteBoard.fetchRequest()
        
        do {
            let matches = try context.fetch(request)
            return matches
        } catch {
            throw error
        }
    }
    
    static func createFavoriteBoard(withId id: String, andName name: String, in context: NSManagedObjectContext) -> FavoriteBoard {
        let favoriteBoard = FavoriteBoard(context: context)
        favoriteBoard.id = id
        favoriteBoard.name = name
        return favoriteBoard
    }
    
    static func checkIfFavoriteBoardExists(withId id: String, in context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<FavoriteBoard> = FavoriteBoard.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let matches = try context.fetch(request)
            return matches.count > 0
        } catch {
            fatalError("checkIfFavoriteBoardsExists: INTERNAL DATABASE ERROR")
        }
    }
    
    static func removeFavoriteBoardWithId(_ id: String, in context: NSManagedObjectContext) {
        let request: NSFetchRequest<FavoriteBoard> = FavoriteBoard.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let matches = try context.fetch(request)
            
            if let target = matches.first {
                context.delete(target)
            }
        } catch {
            fatalError("removeFavoritesBoardWithId: INTERNAL DATABASE ERROR")

        }
    }
}

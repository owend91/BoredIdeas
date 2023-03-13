//
//  SeenActivity.swift
//  BoredIdeas
//
//  Created by David Owen on 3/7/23.
//

import Foundation
import CoreData

final class SeenActivity: NSManagedObject, Identifiable {
    @NSManaged var key: String
    @NSManaged var name: String
    @NSManaged var isLiked: Bool
    @NSManaged var insertedDate: Date
    @NSManaged var updatedDate: Date
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
//        setPrimitiveValue(UUID(), forKey: "itemId")
        setPrimitiveValue(Date.now, forKey: "insertedDate")
    }
    
    
    
}

extension SeenActivity {
    private static var itemsFetchRequest: NSFetchRequest<SeenActivity> {
        NSFetchRequest(entityName: "SeenActivity")
    }
    
    static func all() ->NSFetchRequest<SeenActivity> {
        let request: NSFetchRequest<SeenActivity> = itemsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \SeenActivity.insertedDate, ascending: true)
        ]
        return request
    }
    
    static func liked() ->NSFetchRequest<SeenActivity> {
        let request: NSFetchRequest<SeenActivity> = itemsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \SeenActivity.key, ascending: true)
        ]
        request.predicate = NSPredicate(format: "isLiked == %@", NSNumber(value: true))
        return request
    }
    
    static func disliked() ->NSFetchRequest<SeenActivity> {
        let request: NSFetchRequest<SeenActivity> = itemsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \SeenActivity.key, ascending: true)
        ]
        request.predicate = NSPredicate(format: "isLiked == %@", NSNumber(value: false))
        return request
    }
    
    static func filter(with config: SearchConfig) -> NSPredicate {
        switch config.filter {

//        case .all:
//            return config.query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", config.query)
//        case .liked:
//            return config.query.isEmpty ?  NSPredicate(format: "isFavorite == %@", NSNumber(value: true)) : NSPredicate(format: "name CONTAINS[cd] %@ AND isFavorite == %@", config.query, NSNumber(value: true))
//        case .disliked:
//            <#code#>
            
        case .all:
            return NSPredicate(value: true)
        case .liked:
            return NSPredicate(format: "isLiked == %@", NSNumber(value: true))
        case .disliked:
            return NSPredicate(format: "isLiked == %@", NSNumber(value: false))
        }
    }
//
//    static func sort(order: Sort) -> [NSSortDescriptor] {
//        [NSSortDescriptor(keyPath: \Contact.name, ascending: order == .asc)]
//    }
}


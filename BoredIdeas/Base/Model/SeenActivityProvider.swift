//
//  SeenActivityProvider.swift
//  BoredIdeas
//
//  Created by David Owen on 3/7/23.
//

import Foundation
import CoreData
import SwiftUI

final class SeenActivityProvidor {
    
    static let shared = SeenActivityProvidor()
    
    private let persistentContainer:NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "SeenActivitiesModel")
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count - 1] as URL)
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load store with error: \(error)")
            }
        }
    }
    
//    func exists(_ item: BucketListItem, in context: NSManagedObjectContext) -> BucketListItem? {
//
//        try? context.existingObject(with: item.objectID) as? BucketListItem
//    }
//
//    func delete(_ item: BucketListItem, in context: NSManagedObjectContext) throws {
//        if let existingBucketListItem = exists(item, in: context) {
//            context.delete(existingBucketListItem)
//            Task(priority: .background) {
//                try await context.perform {
//                    try context.save()
//                }
//            }
//        }
//    }
    
    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

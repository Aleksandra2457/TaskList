//
//  CoreDataManager.swift
//  TaskList
//
//  Created by Александра Лесовская on 19.04.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Static Properties
    static let shared = CoreDataManager()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Public Methods
    func fetchData(_ completion: @escaping ([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()
        do {
            let taskList = try CoreDataManager
                .shared
                .persistentContainer
                .viewContext
                .fetch(fetchRequest)
            completion(taskList)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ task: Task) {
        CoreDataManager.shared.persistentContainer.viewContext.delete(task)
        if CoreDataManager.shared.persistentContainer.viewContext.hasChanges {
            do {
                try CoreDataManager.shared.persistentContainer.viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveChanges() {
        if CoreDataManager.shared.persistentContainer.viewContext.hasChanges {
            do {
                try CoreDataManager.shared.persistentContainer.viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

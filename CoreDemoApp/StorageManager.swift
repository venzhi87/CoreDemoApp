//
//  StorageManager.swift
//  CoreDemoApp
//
//  Created by Pavel Kuzovlev on 22.04.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDemoApp")
        container.loadPersistentStores(completionHandler: { ( _, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    func fetchData(completion: (Result<[TaskToDo], Error>) -> Void) {
        let fetchRequest = TaskToDo.fetchRequest()
        
        do {
            let tasks = try self.viewContext.fetch(fetchRequest)
            completion(.success(tasks))
            
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func create(_ taskName: String, completion: (TaskToDo) -> Void) {
        let task = TaskToDo(context: viewContext)
        task.title = taskName
        completion(task)
        saveContext()
    }
    
    func update(_ task: TaskToDo, newName: String) {
        task.title = newName
        saveContext()
    }
    
    func delete(_ task: TaskToDo) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

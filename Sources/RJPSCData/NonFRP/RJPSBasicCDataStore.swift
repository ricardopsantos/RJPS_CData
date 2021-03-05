//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

//
// https://codeburst.io/how-to-use-nsfetchedresultscontroller-with-swiftui-de5b75f1b8d0
// How to use NSFetchedResultsController with SwiftUI
//

class CoreDataManager {

    // MARK: - Properties
    
    private let modelName: String
    private let writeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()

    // MARK: - Initializers
    
    init(modelName: String) {
        self.modelName = modelName
        self.writeContext.persistentStoreCoordinator = storeContainer.persistentStoreCoordinator
    }
    
    // MARK: - Public methods
    
    func saveContext () {
        guard mainContext.hasChanges else { return }
        
        do {
            try mainContext.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
      
    func newDerivedContext() -> NSManagedObjectContext {
        let context = self.storeContainer.newBackgroundContext()
        return context
    }
    
}

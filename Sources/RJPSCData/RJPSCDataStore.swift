import CoreData


public class RJPSCDataStore: RJPSCDataStoringProtocol {
    
    private let container: NSPersistentContainer
        
    public var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    public func reset() {
        viewContext.reset()
    }
    
    public convenience init(name: String, in storageType: RJPSCDataStorageType = .persistent, bundle: String) {
        guard let managedObjectModel = RJPSCDataStoreUtils.tryManagedObjectModelWith(dbName: name, bundle: bundle) else {
            fatalError("Invalid name or bundle")
        }
        self.init(name: name, in: storageType, managedObjectModel: managedObjectModel)
    }
    
    public init(name: String, in storageType: RJPSCDataStorageType = .persistent, managedObjectModel: NSManagedObjectModel) {
        self.container = NSPersistentContainer(name: name, managedObjectModel: managedObjectModel)
        self.setupFor(storageType: storageType)
        self.container.loadPersistentStores { (/*storeDescription*/ _, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

private extension RJPSCDataStore {
        
    func setupFor(storageType: RJPSCDataStorageType) {
        if storageType  == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.container.persistentStoreDescriptions = [description]
        }
    }
    
}

/*
 * https://blog.nfnlabs.in/run-tasks-on-background-thread-swift-5d3aec272140
 *
 * NSMainQueueConcurrencyType is specifically for use with your application interface and can only be used on the main queue of an application.
 * The NSPrivateQueueConcurrencyType configuration creates its own queue upon initialization and can be used only on that queue.
 */
public extension RJPSCDataStore {
    var privateQueue: NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.viewContext.persistentStoreCoordinator
        return managedObjectContext
    }
    
    var mainQueue: NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.viewContext.persistentStoreCoordinator
        return managedObjectContext
    }
}


import CoreData

public extension RJSCDataFRP {
    class CDataStoreManager: FRPCDataStoreDataStoringProtocol {
        
        public func newBackgroundContext() -> NSManagedObjectContext {
            container.newBackgroundContext()
        }
        
        private let container: NSPersistentContainer
            
        public var viewContext: NSManagedObjectContext {
            container.viewContext
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
            container = NSPersistentContainer(name: name, managedObjectModel: managedObjectModel)
            setupFor(storageType: storageType)
            container.loadPersistentStores { (/*storeDescription*/ _, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        }
    }
}


private extension RJS_FRPCDataStore {
        
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
public extension RJS_FRPCDataStore {
    var privateQueue: NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = viewContext.persistentStoreCoordinator
        return managedObjectContext
    }
    
    var mainQueue: NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = viewContext.persistentStoreCoordinator
        return managedObjectContext
    }
}


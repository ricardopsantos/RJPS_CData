import CoreData

public extension RJSCData.FRP {
    class CDataStoreManager: RJSCDataFRPProtocol, RJSCDataSugarProtocols {

        public func newBackgroundContext() -> NSManagedObjectContext {
            container.newBackgroundContext()
        }

        private let container: NSPersistentContainer

        public var viewContext: NSManagedObjectContext {
            container.viewContext
        }

        public convenience init(name: String, in storageType: RJSCData.StorageType = .persistent, bundle: String) {

            guard let managedObjectModel = RJPSCDataStoreUtils.tryManagedObjectModelWith(dbName: name, bundle: bundle) else {
                fatalError("Invalid name or bundle")
            }
            self.init(name: name, in: storageType, managedObjectModel: managedObjectModel)
        }

        public init(name: String, in storageType: RJSCData.StorageType = .persistent, managedObjectModel: NSManagedObjectModel) {
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

    func setupFor(storageType: RJSCData.StorageType) {
        if storageType  == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.container.persistentStoreDescriptions = [description]
        }
    }
}

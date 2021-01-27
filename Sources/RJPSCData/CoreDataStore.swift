import CoreData

enum StorageType {
    case persistent, inMemory
}

extension NSManagedObject {
    class var entityName: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

public protocol EntityCreating {
    var viewContext: NSManagedObjectContext { get }
    func createEntity<T: NSManagedObject>() -> T
}

extension EntityCreating {
    public func createEntity<T: NSManagedObject>() -> T {
        T(context: viewContext)
    }
}

public protocol CoreDataFetchResultsPublishing {
    var viewContext: NSManagedObjectContext { get }
    func publicher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T>
}

extension CoreDataFetchResultsPublishing {
    public func publicher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T> {
        return CoreDataFetchResultsPublisher(request: request, context: viewContext)
    }
}

public protocol CoreDataDeleteModelPublishing {
    var viewContext: NSManagedObjectContext { get }
    func publicher<T: NSManagedObject>(delete request: NSFetchRequest<T>) -> CoreDataDeleteModelPublisher<T>
}

extension CoreDataDeleteModelPublishing {
    public func publicher<T: NSManagedObject>(delete request: NSFetchRequest<T>) -> CoreDataDeleteModelPublisher<T> {
        return CoreDataDeleteModelPublisher(delete: request, context: viewContext)
    }
}

public protocol CoreDataSaveModelPublishing {
    var viewContext: NSManagedObjectContext { get }
    func publicher(save action: @escaping Action) -> CoreDataSaveModelPublisher
    func reset()
}

extension CoreDataSaveModelPublishing {
    public func publicher(save action: @escaping Action) -> CoreDataSaveModelPublisher {
        return CoreDataSaveModelPublisher(action: action, context: viewContext)
    }
}

public protocol CoreDataStoringProtocol: EntityCreating, CoreDataFetchResultsPublishing, CoreDataDeleteModelPublishing, CoreDataSaveModelPublishing {
    var viewContext: NSManagedObjectContext { get }
}

public class CoreDataStore: CoreDataStoringProtocol {

    private let container: NSPersistentContainer
    
    public static var `default`: CoreDataStoringProtocol = {
        let dbName = "CoreDataDB"
        guard let bundle = Bundle(identifier: "com.rjps.GoodToGo.Core"),
              let modelURL = bundle.url(forResource: dbName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("fix me")
        }
        return CoreDataStore(name: dbName, in: .persistent, managedObjectModel: managedObjectModel)
    }()
    
    public var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    public func reset() {
        viewContext.reset()
    }
    
    init(name: String, in storageType: StorageType, managedObjectModel: NSManagedObjectModel) {
        
        self.container = NSPersistentContainer(name: name, managedObjectModel: managedObjectModel)
        self.setupIfMemoryStorage(storageType)
        self.container.loadPersistentStores { (/*storeDescription*/ _, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    private func setupIfMemoryStorage(_ storageType: StorageType) {
        if storageType  == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.container.persistentStoreDescriptions = [description]
        }
    }
}

//
//  Created by Ricardo Santos on 28/01/2021.
//

import Foundation
import CoreData

//
// MARK: - RJPSCDataEntityCreatingProtocol
//

public protocol RJSCDataFRPEntityCreatingProtocol {
    var viewContext: NSManagedObjectContext { get }
    func createEntity<T: NSManagedObject>() -> T
}

extension RJSCDataFRPEntityCreatingProtocol {
    public func createEntity<T: NSManagedObject>() -> T {
        T(context: viewContext)
    }
}

//
// MARK: - FRPCDataStoreFetchProtocol
//

public protocol RJSCDataFRPFetchProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publicher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> RJPSCDataFetchResultsPublisher<T>
}

extension RJSCDataFRPFetchProtocol {
    public func publicher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> RJPSCDataFetchResultsPublisher<T> {
        return RJPSCDataFetchResultsPublisher(request: request, context: viewContext)
    }
}

//
// MARK: - FRPCDataStoreDeleteProtocol
//

public protocol RJSCDataFRPDeleteProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publicher<T: NSManagedObject>(delete request: NSFetchRequest<T>) -> RJPSCDataDeleteModelPublisher<T>
}

extension RJSCDataFRPDeleteProtocol {
    public func publicher<T: NSManagedObject>(delete request: NSFetchRequest<T>) -> RJPSCDataDeleteModelPublisher<T> {
        return RJPSCDataDeleteModelPublisher(delete: request, context: viewContext)
    }
}

//
// MARK: - FRPCDataStoreSaveProtocol
//

public protocol FRPCDataStoreSaveProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publicher(save action: @escaping RJPSCDataAction) -> RJPSCDataSaveModelPublisher
    func reset()
}

public extension FRPCDataStoreSaveProtocol {
    func publicher(save action: @escaping RJPSCDataAction) -> RJPSCDataSaveModelPublisher {
        return RJPSCDataSaveModelPublisher(action: action, context: viewContext)
    }
}

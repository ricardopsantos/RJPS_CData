//
//  Created by Ricardo Santos on 28/01/2021.
//

import Foundation
import CoreData

public protocol RJPSCDataEntityCreatingProtocol {
    var viewContext: NSManagedObjectContext { get }
    func createEntity<T: NSManagedObject>() -> T
}

extension RJPSCDataEntityCreatingProtocol {
    public func createEntity<T: NSManagedObject>() -> T {
        T(context: viewContext)
    }
}

public protocol RJPSCDataFetchResultsPublishingProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publicher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> RJPSCDataFetchResultsPublisher<T>
}

extension RJPSCDataFetchResultsPublishingProtocol {
    public func publicher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> RJPSCDataFetchResultsPublisher<T> {
        return RJPSCDataFetchResultsPublisher(request: request, context: viewContext)
    }
}

public protocol RJPSCDataDeleteModelPublishingProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publicher<T: NSManagedObject>(delete request: NSFetchRequest<T>) -> RJPSCDataDeleteModelPublisher<T>
}

extension RJPSCDataDeleteModelPublishingProtocol {
    public func publicher<T: NSManagedObject>(delete request: NSFetchRequest<T>) -> RJPSCDataDeleteModelPublisher<T> {
        return RJPSCDataDeleteModelPublisher(delete: request, context: viewContext)
    }
}

public protocol RJPSCDataSaveModelPublishingProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publicher(save action: @escaping RJPSCDataAction) -> RJPSCDataSaveModelPublisher
    func reset()
}

public extension RJPSCDataSaveModelPublishingProtocol {
    func publicher(save action: @escaping RJPSCDataAction) -> RJPSCDataSaveModelPublisher {
        return RJPSCDataSaveModelPublisher(action: action, context: viewContext)
    }
}

public protocol RJPSCDataStoringProtocol: RJPSCDataEntityCreatingProtocol, RJPSCDataFetchResultsPublishingProtocol, RJPSCDataDeleteModelPublishingProtocol, RJPSCDataSaveModelPublishingProtocol {
    var viewContext: NSManagedObjectContext { get }
    var privateQueue: NSManagedObjectContext { get }
    var mainQueue: NSManagedObjectContext { get }
}

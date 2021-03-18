//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol RJSCDataFRPEntityFetchProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> RJSCDataFRPEntityFetchPublisher<T>
}

extension RJSCDataFRPEntityFetchProtocol {
    public func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> RJSCDataFRPEntityFetchPublisher<T> {
        RJSCDataFRPEntityFetchPublisher(request: request, context: viewContext)
    }
}

//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol RJSCDataFRPEntityDeleteProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publicher<T: NSManagedObject>(delete request: NSFetchRequest<T>) -> RJSCDataFRPEntityDeletePublisher<T>
}

extension RJSCDataFRPEntityDeleteProtocol {
    public func publicher<T: NSManagedObject>(delete request: NSFetchRequest<T>) -> RJSCDataFRPEntityDeletePublisher<T> {
        RJSCDataFRPEntityDeletePublisher(delete: request, context: viewContext)
    }
}

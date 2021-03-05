//
//  Created by Ricardo Santos on 28/01/2021.
//

import Foundation
import CoreData

public protocol RJSCDataFRPEntityCreatingProtocol {
    var viewContext: NSManagedObjectContext { get }
    func createEntity<T: NSManagedObject>() -> T
}

extension RJSCDataFRPEntityCreatingProtocol {
    public func createEntity<T: NSManagedObject>() -> T {
        T(context: viewContext)
    }
}

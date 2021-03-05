//
//  Created by Ricardo Santos on 07/02/2021.
//

import Foundation
import CoreData

/**
 iOS Core Data with Sugar Syntax:
 https://medium.com/dev-genius/ios-core-data-with-sugar-syntax-ef53a0e06efe
 */

//
// Just use anywere hearn the protocol extension behavior
//

protocol RJSCDataEntityFetchSugarProtocol {
    var viewContext: NSManagedObjectContext { get }
    func fectch<T: NSManagedObject>(predicate: NSPredicate?,
                                    sortDescriptors: [NSSortDescriptor]?,
                                    limit: Int?,
                                    batchSize: Int?) -> [T]
}

extension RJSCDataEntityFetchSugarProtocol {
    func fectch<T: NSManagedObject>(predicate: NSPredicate? = nil,
                                    sortDescriptors: [NSSortDescriptor]? = nil,
                                    limit: Int? = nil,
                                    batchSize: Int? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        if let limit = limit, limit > 0 {
            request.fetchLimit = limit
        }

        if let batchSize = batchSize, batchSize > 0 {
            request.fetchBatchSize = batchSize
        }

        do {
            let items = try viewContext.fetch(request)
            return items
        } catch {
            fatalError("Couldnt fetch the enities for \(T.entityName) " + error.localizedDescription)
        }
    }
}

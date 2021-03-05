//
//  Created by Ricardo Santos on 07/02/2021.
//

import Foundation
import CoreData

/**
 iOS Core Data with Sugar Syntax:
 https://medium.com/dev-genius/ios-core-data-with-sugar-syntax-ef53a0e06efe
 */

protocol RJPSCDataEntityDeletingProtocol {
    var viewContext: NSManagedObjectContext { get }
    func delete(request: NSFetchRequest<NSFetchRequestResult>)
}

extension RJPSCDataEntityDeletingProtocol {
    func delete(request: NSFetchRequest<NSFetchRequestResult>) {
        do {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            batchDeleteRequest.resultType = .resultTypeCount
            try viewContext.execute(batchDeleteRequest)
        } catch {
            fatalError("Couldnt delete the enities " + error.localizedDescription)
        }
    }
}

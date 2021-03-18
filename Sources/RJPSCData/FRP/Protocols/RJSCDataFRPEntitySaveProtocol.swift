//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol RJSCDataFRPEntitySaveProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publisher(save action: @escaping RJS_FRPCDataStorePublisherAction) -> RJSCDataFRPEntitySavePublisher
    func reset()
}

public extension RJSCDataFRPEntitySaveProtocol {
    func publisher(save action: @escaping RJS_FRPCDataStorePublisherAction) -> RJSCDataFRPEntitySavePublisher {
        RJSCDataFRPEntitySavePublisher(action: action, context: viewContext)
    }
}

//
//  Created by Ricardo Santos on 05/03/2021.
//

import Foundation
import CoreData

public protocol RJSCDataFRPEntitySaveProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publicher(save action: @escaping RJPSCDataAction) -> RJPSCDataSaveModelPublisher
    func reset()
}

public extension RJSCDataFRPEntitySaveProtocol {
    func publicher(save action: @escaping RJPSCDataAction) -> RJPSCDataSaveModelPublisher {
        return RJPSCDataSaveModelPublisher(action: action, context: viewContext)
    }
}
